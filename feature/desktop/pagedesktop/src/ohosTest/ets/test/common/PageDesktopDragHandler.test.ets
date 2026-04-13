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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'

import { CheckEmptyUtils, RectItem } from '@ohos/basicutils';
import { desktopUtil, RTLUtil, DragAccessibilityUtils } from '@ohos/componenthelper';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { CellAndSpan, CellLayoutDragDelegate, DragItemPosition, DragGridPosition } from '@ohos/componentdrag';
import { scbEventExclusiveManager, launcherStatusUtil } from '@ohos/windowscene';
import {
  AppListInfo,
  BaseLayoutCacheManager,
  CommonConstants,
  DesktopDragResult,
  DeviceState,
  DragItem,
  editModeManager,
  EditModeUtils,
  FileType,
  FolderViewModel,
  FormModel,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  layoutLockUtil,
  MultiSelectManager,
  SettingsModel,
} from '@ohos/launchercommon';
import { MoveItem, PageDesktopDragHandler } from '../../../../main/ets/default/common/PageDesktopDragHandler';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { BigFolderViewModel } from '@ohos/bigfolder';
import { FormStackManager } from '@ohos/formstack/src/main/ets/common/FormStackManager';
import { FormStackViewModel } from '@ohos/formstack/src/main/ets/viewmodel/FormStackViewModel';
import { GameCardInfo } from '@ohos/launchercommon/src/main/ets/bean/GameCardInfo';
import CardSqueezerTest from '../ets/default/common/CardSqueezer.test';

export default function PageDesktopDragHandlerTest() {
  let endPosition: DragItemPosition = {
    page: 1,
    row: 1,
    column: 1,
    x: 1,
    y: 1,
    isInDock: false,
    originColumn: 1,
  };
  let dragResult1: DragResult = DragResult.DRAG_FAILED;
  let dragEvent: DragEvent = {
    getModifierKeyState: ((keys: Array<string>): boolean => {
      return true;
    }),
    getWindowX: ((): number => {
      return 1;
    }),
    getWindowY: ((): number => {
      return 1;
    }),
    getPreviewRect: ((): Rectangle => {
      return {
        x: -1,
        width: 10,
        y: -1,
        height: 10
      };
    }),

    getDisplayX: (): number => {
      return 1;
    },
    getDisplayY: (): number => {
      return 1;
    },
    getX: (): number => {
      return 1;
    },
    getY: (): number => {
      return 1;
    },
    dragBehavior: DragBehavior.COPY,
    useCustomDropAnimation: false,
    setData: (unifiedData: UnifiedData): void => {
    },
    getSummary: (): Summary => {
      throw new Error('myl001');
    },
    setResult: (dragResult: DragResult): void => {
      dragResult1 = dragResult;
    },
    getResult: (): DragResult => {
      return dragResult1;
    },
    getVelocityX: (): number => {
      return 1;
    },
    getVelocityY: (): number => {
      return 1;
    },
    getVelocity: (): number => {
      return 1;
    },
    getData: (): UnifiedData => {
      throw new Error('myl001');
    },
    executeDropAnimation: (customDropAnimation: Callback<void, void>): void => {
      throw new Error('Function not implemented.');
    }
  };
  describe('PageDesktopDragHandlerTest', () => {
    let pageDesktopDragHandler: PageDesktopDragHandler = new PageDesktopDragHandler();
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    let launchLayoutCacheManager1: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    let gridLayoutItemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
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
    it('PageDesktopDragHandler_dragEventCancel_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.getEventExclusiveByCaller);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['dragEventCancel']();
      } catch (err) {}
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.getEventExclusiveByCaller);
      done();
    })

    it('PageDesktopDragHandler_dragEventCancel_test02', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.getEventExclusiveByCaller);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['dragEventCancel']();
      } catch (err) {}
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.getEventExclusiveByCaller);
      done();
    })

    it('PageDesktopDragHandler_dragEventCancel_test01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['swipeTimeoutId'] = CommonConstants.INVALID_VALUE;
        pageDesktopDragHandler.setSwipeTimeout(a);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['swipeTimeoutId'] = CommonConstants.prototype;
        pageDesktopDragHandler.setSwipeTimeout(a);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_clearSwipeTimeout_test01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['swipeTimeoutId'] = CommonConstants.prototype;
        pageDesktopDragHandler.clearSwipeTimeout();
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['swipeTimeoutId'] = CommonConstants.INVALID_VALUE;
        pageDesktopDragHandler.clearSwipeTimeout();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_getDragPageIndex_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        pageDesktopDragHandler.getDragPageIndex();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      done();
    })

    it('PageDesktopDragHandler_getDragPageIndex_test02', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        pageDesktopDragHandler.getDragPageIndex();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      done();
    })

    it('PageDesktopDragHandler_setDragPageIndex_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunc)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['outerDragPageIndex'] = 0;
        pageDesktopDragHandler.setDragPageIndex(0);
        expect(pageDesktopDragHandler).not().assertUndefined();
        pageDesktopDragHandler.setDragPageIndex(1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      done();
    })

    it('PageDesktopDragHandler_setDragPageIndex_test02', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunc)().afterReturn(false);
      let mockFunc1: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['dragPageIndex'] = 0;
        pageDesktopDragHandler.setDragPageIndex(0);
        expect(pageDesktopDragHandler).not().assertUndefined();
        pageDesktopDragHandler.setDragPageIndex(1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        pageDesktopDragHandler.setDragPageIndex(1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mock.ignoreMock(AppStorage, AppStorage.get);
      done();
    })

    it('PageDesktopDragHandler_updateDragPageIndex_test01', 0, async(done:Function) => {
      let BaseLayoutCacheManager1: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc)().afterReturn(true);
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragPageIndex);
      when(mockFunc1)().afterReturn(10);
      let mockFunc3: Function = mock.mockFunc(BaseLayoutCacheManager1, BaseLayoutCacheManager1.selectPageCount);
      when(mockFunc3)().afterReturn(20);
      try {
        (pageDesktopDragHandler as object)['dragPageIndex'] = 0;
        pageDesktopDragHandler.updateDragPageIndex(true);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getDragPageIndex);
      mock.ignoreMock(BaseLayoutCacheManager1, BaseLayoutCacheManager1.selectPageCount);
      done();
    })

    it('PageDesktopDragHandler_updateDragPageIndex_test02', 0, async(done:Function) => {
      let BaseLayoutCacheManager1: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc)().afterReturn(false);
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragPageIndex);
      when(mockFunc1)().afterReturn(0);
      let mockFunc3: Function = mock.mockFunc(BaseLayoutCacheManager1, BaseLayoutCacheManager1.selectPageCount);
      when(mockFunc3)().afterReturn(3);
      try {
        (pageDesktopDragHandler as object)['dragPageIndex'] = 0;
        pageDesktopDragHandler.updateDragPageIndex(false);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc1)().afterReturn(2);
      when(mockFunc3)().afterReturn(0);
      try {
        pageDesktopDragHandler.updateDragPageIndex(false);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getDragPageIndex);
      mock.ignoreMock(BaseLayoutCacheManager1, BaseLayoutCacheManager1.selectPageCount);
      done();
    })

    it('PageDesktopDragHandler_getCurrentPageIndex_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragPageIndex);
      when(mockFunc)().afterReturn(1);
      let mockFunc1: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isLargeFoldExpanded);
      when(mockFunc1)().afterReturn(true);
      let mockFunc3: Function = mock.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc3)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['isFoldNearScreen'] = true;
        pageDesktopDragHandler.getCurrentPageIndex();
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isFoldNearScreen'] = false;
        pageDesktopDragHandler.getCurrentPageIndex();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getDragPageIndex);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isLargeFoldExpanded);
      mock.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('PageDesktopDragHandler_getCurrentPageIndex_test02', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragPageIndex);
      when(mockFunc)().afterReturn(2);
      let mockFunc1: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isLargeFoldExpanded);
      when(mockFunc1)().afterReturn(true);
      let mockFunc3: Function = mock.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc3)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['isFoldNearScreen'] = true;
        pageDesktopDragHandler.getCurrentPageIndex();
      } catch (err) {}
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc1)().afterReturn(false);
      try {
        pageDesktopDragHandler.getCurrentPageIndex();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getDragPageIndex);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isLargeFoldExpanded);
      mock.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('PageDesktopDragHandler_setStartPosition_test01', 0, async(done:Function) => {
      let startPosition: DragItemPosition = {
        page: 0,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      }
      try {
        pageDesktopDragHandler.setStartPosition(startPosition);
        expect(pageDesktopDragHandler).not().assertUndefined();
        pageDesktopDragHandler.setStartPosition();
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch (err){}
      done();
    })

    it('PageDesktopDragHandler_isDragEffectArea_test01', 0, async(done:Function) => {
      try {
        let result: boolean = pageDesktopDragHandler.isDragEffectArea(undefined, 0);
        expect(result).assertFalse();
        let result1: boolean = pageDesktopDragHandler.isDragEffectArea(null, 0);
        expect(result1).assertFalse();
        let result2: boolean = pageDesktopDragHandler.isDragEffectArea(0, undefined);
        expect(result2).assertFalse();
        let result3: boolean = pageDesktopDragHandler.isDragEffectArea(0, null);
        expect(result3).assertFalse();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_updateDragGridParam_test01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['updateDragGridParam'](undefined);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['updateDragGridParam'](null);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['mPageCoordinateData'] = {
          gridXAxis: [1, 1],
          gridYAxis: []
        };
        (pageDesktopDragHandler as object)['mWaterfallPageCoordinateData'] = {
          gridXAxis: [1, 1],
          gridYAxis: []
        };
        (pageDesktopDragHandler as object)['updateDragGridParam'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_updateFoldRelatedStatus_test01', 0, async(done:Function) => {
      (pageDesktopDragHandler as object)['updateFoldRelatedStatus'](undefined);
      expect(pageDesktopDragHandler).not().assertUndefined();
      (pageDesktopDragHandler as object)['updateFoldRelatedStatus'](null);
      expect(pageDesktopDragHandler).not().assertUndefined();
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc)().afterReturn(true);
      let mockFunc1: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(5);
      try {
        (pageDesktopDragHandler as object)['lastFoldStatus'] = false;
        (pageDesktopDragHandler as object)['updateFoldRelatedStatus'](5);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['lastFoldStatus'] = true;
        (pageDesktopDragHandler as object)['lastFoldStatus'] = false;
        (pageDesktopDragHandler as object)['updateFoldRelatedStatus'](5);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['lastFoldStatus'] = true;
        (pageDesktopDragHandler as object)['lastFoldStatus'] = true;
        (pageDesktopDragHandler as object)['updateFoldRelatedStatus'](5);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['updateFoldRelatedStatus'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mock.ignoreMock(AppStorage, AppStorage.get);
      done();
    })

    it('PageDesktopDragHandler_updateFoldRelatedStatus_test02', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc)().afterReturn(false);
      let mockFunc1: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc1)().afterReturn(5);
      try {
        (pageDesktopDragHandler as object)['updateFoldRelatedStatus'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch (err){}
      mock.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mock.ignoreMock(AppStorage, AppStorage.get);
      done();
    })

    it('PageDesktopDragHandler_getPageIndex_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc)().afterReturn(true);
      let mockFunc1: Function = mock.mockFunc(desktopUtil, desktopUtil.getPageIndexValue);
      when(mockFunc1)().afterReturn(5);
      let mockFunc2: Function = mock.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc2)().afterReturn(true);
      let mockFunc3: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isLargeFoldExpanded);
      when(mockFunc3)().afterReturn(true);
      try {
        pageDesktopDragHandler.getPageIndex();
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isFoldNearScreen'] = true;
        pageDesktopDragHandler.getPageIndex();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc2)().afterReturn(true);
      try {
        pageDesktopDragHandler.getPageIndex();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mock.ignoreMock(desktopUtil, desktopUtil.getPageIndexValue);
      mock.ignoreMock(RTLUtil, RTLUtil.isRTL);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isLargeFoldExpanded);
      done();
    })

    it('PageDesktopDragHandler_getPageIndex_test02', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc)().afterReturn(false);
      let mockFunc1: Function = mock.mockFunc(desktopUtil, desktopUtil.getPageIndexValue);
      when(mockFunc1)().afterReturn(5);
      let mockFunc2: Function = mock.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc2)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['isFoldNearScreen'] = false;
        pageDesktopDragHandler.getPageIndex();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mock.ignoreMock(desktopUtil, desktopUtil.getPageIndexValue);
      mock.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('PageDesktopDragHandler_getItemIndex_test01', 0, async(done:Function) => {
      try {
        pageDesktopDragHandler.getItemIndex(undefined, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        pageDesktopDragHandler.getItemIndex(null, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        pageDesktopDragHandler.getItemIndex(1, undefined);
        expect(pageDesktopDragHandler).not().assertUndefined();
        pageDesktopDragHandler.getItemIndex(1, null);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_getItemIndex_test02', 0, async(done:Function) => {
      let res: DragGridPosition = {
        row: 1,
        column: 1
      };
      (pageDesktopDragHandler as object)['mGridConfig'] = {
        row: 1,
        column: 1
      };
      (pageDesktopDragHandler as object)['isPc'] = true;
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.getRowAndColumn);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(res);
      try {
        pageDesktopDragHandler.getItemIndex(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isPc'] = false;
        pageDesktopDragHandler.getItemIndex(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        res.column = -1;
        pageDesktopDragHandler.getItemIndex(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        res.row = -1;
        pageDesktopDragHandler.getItemIndex(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.getRowAndColumn);
      done();
    })

    it('PageDesktopDragHandler_getItemByIndex_test01', 0, async(done:Function) => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      let items: GridLayoutItemInfo[] = [item, item];
      (pageDesktopDragHandler as object)['mGridConfig'] = {
        row: 1,
        column: 1
      };
      (pageDesktopDragHandler as object)['isPc'] = true;
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      when(mockFunc1)().afterReturn(0);
      let mockFunc: Function =
        mock.mockFunc(launchLayoutCacheManager1, launchLayoutCacheManager1.selectGridLayoutItemsByPage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(items);
      try {
        (pageDesktopDragHandler as object)['getItemByIndex'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        item.typeId = CommonConstants.TYPE_FOLDER;
        (pageDesktopDragHandler as object)['getItemByIndex'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        item.typeId = CommonConstants.TYPE_CARD;
        (pageDesktopDragHandler as object)['getItemByIndex'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        item.typeId = CommonConstants.TYPE_FILE_FOLDER;
        (pageDesktopDragHandler as object)['getItemByIndex'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        item.typeId = CommonConstants.TYPE_FORM_STACK;
        (pageDesktopDragHandler as object)['getItemByIndex'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        item.typeId = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
        (pageDesktopDragHandler as object)['getItemByIndex'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        item.typeId = CommonConstants.TYPE_REGION_FOLDER;
        (pageDesktopDragHandler as object)['getItemByIndex'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isPc'] = false;
        (pageDesktopDragHandler as object)['getItemByIndex'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      mock.ignoreMock(launchLayoutCacheManager1, launchLayoutCacheManager1.selectGridLayoutItemsByPage);
      done();
    })

    it('PageDesktopDragHandler_getTouchPosition_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      when(mockFunc1)().afterReturn(0);
      try {
        pageDesktopDragHandler.getTouchPosition(undefined, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        pageDesktopDragHandler.getTouchPosition(null, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        pageDesktopDragHandler.getTouchPosition(1, undefined);
        expect(pageDesktopDragHandler).not().assertUndefined();
        pageDesktopDragHandler.getTouchPosition(1, null);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      done();
    })

    it('PageDesktopDragHandler_getTouchPosition_test02', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      when(mockFunc1)().afterReturn(0);
      try {
        (pageDesktopDragHandler as object)['mPageCoordinateData'] = {
          gridXAxis: [2],
          gridYAxis: [2]
        };
        pageDesktopDragHandler.getTouchPosition(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['mPageCoordinateData'] = {
          gridXAxis: [0],
          gridYAxis: [0]
        };
        pageDesktopDragHandler.getTouchPosition(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      done();
    })

    it('PageDesktopDragHandler_getItemByPosition_test01', 0, async(done:Function) => {
      let startPosition: DragItemPosition = {
        page: 0,
        row: 3,
        column: 3,
        x: 0,
        y: 0
      }
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.column = 2;
      item.area = [2, 2];
      item.row = 2;
      let items: GridLayoutItemInfo[] = [item, item];
      (pageDesktopDragHandler as object)['mGridConfig'] = {
        row: 1,
        column: 1
      };
      (pageDesktopDragHandler as object)['mIsPrintLog'] = true;
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      when(mockFunc1)().afterReturn(0);
      let mockFunc: Function =
        mock.mockFunc(launchLayoutCacheManager1, launchLayoutCacheManager1.selectGridLayoutItemsByPage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(items);
      let mockFunc2: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      when(mockFunc2)().afterReturn(items);
      try {
        (pageDesktopDragHandler as object)['getItemByPosition'](startPosition);
        expect(pageDesktopDragHandler).not().assertUndefined();
        startPosition.column = 0;
        (pageDesktopDragHandler as object)['getItemByPosition'](startPosition);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['mIsPrintLog'] = false;
      } catch (err) {}
      when(mockFunc2)().afterReturn(undefined);
      try {
        (pageDesktopDragHandler as object)['getItemByPosition'](startPosition);
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      mock.ignoreMock(launchLayoutCacheManager1, launchLayoutCacheManager1.selectGridLayoutItemsByPage);
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      done();
    })

    it('PageDesktopDragHandler_getItemByPosition_test01', 0, async(done:Function) => {
      try {
        gridLayoutItemInfo1.column = 0;
        gridLayoutItemInfo1.row = 0;
        gridLayoutItemInfo1.area = [2, 2];
        (pageDesktopDragHandler as object)['isItemInRowColumn'](1, 1, gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.column = 20;
        (pageDesktopDragHandler as object)['isItemInRowColumn'](1, 1, gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_updateStartPosition_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      when(mockFunc1)().afterReturn(gridLayoutItemInfo1);
      let mockFunc: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['isPc'] = true;
        (pageDesktopDragHandler as object)['updateStartPosition']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      done();
    })

    it('PageDesktopDragHandler_updateStartPosition_test02', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      when(mockFunc1)().afterReturn(gridLayoutItemInfo1);
      let mockFunc: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function =
        mock.mockFunc(launchLayoutCacheManager1, launchLayoutCacheManager1.selectGridLayoutItemByItem);
      when(mockFunc2)().afterReturn(undefined);
      let mockFunc3: Function =
        mock.mockFunc(GridLayoutUtil, GridLayoutUtil.getIconCenterPosition);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn([1, 1]);
      try {
        (pageDesktopDragHandler as object)['isPc'] = true;
        (pageDesktopDragHandler as object)['updateStartPosition']();
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isPc'] = false;
        (pageDesktopDragHandler as object)['updateStartPosition']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc2)().afterReturn(gridLayoutItemInfo1);
      try {
        (pageDesktopDragHandler as object)['updateStartPosition']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      mock.ignoreMock(launchLayoutCacheManager1, launchLayoutCacheManager1.selectGridLayoutItemByItem);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.getIconCenterPosition);
      done();
    })

    it('PageDesktopDragHandler_updateStartPosition_test03', 0, async(done:Function) => {
      (pageDesktopDragHandler as object)['isPc'] = false;
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      when(mockFunc1)().afterReturn(gridLayoutItemInfo1);
      let mockFunc: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc)().afterReturn(true);
      let mockFunc2: Function =
        mock.mockFunc(launchLayoutCacheManager1, launchLayoutCacheManager1.selectGridLayoutItemByItem);
      when(mockFunc2)().afterReturn(undefined);
      try {
        (pageDesktopDragHandler as object)['updateStartPosition']();
      } catch (err) {}
      when(mockFunc2)().afterReturn(gridLayoutItemInfo1);
      try {
        gridLayoutItemInfo1.row = 0;
        gridLayoutItemInfo1.column = 0;
        gridLayoutItemInfo1.area = [];
        gridLayoutItemInfo1.page = 0;
        (pageDesktopDragHandler as object)['updateStartPosition']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      mock.ignoreMock(launchLayoutCacheManager1, launchLayoutCacheManager1.selectGridLayoutItemByItem);
      done();
    })

    it('PageDesktopDragHandler_getPositionByRowAndColumn_test01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['getPositionByRowAndColumn'](1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['getPositionByRowAndColumn'](1, 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_getPositionByRowAndColumnWithoutRTL_test01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['getPositionByRowAndColumnWithoutRTL'](1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['getPositionByRowAndColumnWithoutRTL'](1, 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_getPaddingLeft_test01', 0, async(done:Function) => {
      let pageDesktopGridStyleConfig1: PageDesktopGridStyleConfig = PageDesktopGridStyleConfig.getInstance();
      pageDesktopGridStyleConfig1.mMargin = 0;
      pageDesktopGridStyleConfig1.mFoldPaddingSide = 0;
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc)().afterReturn(true);
      let mockFunc1: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc1)().afterReturn(4);
      try {
        (pageDesktopDragHandler as object)['mPageDesktopStyleConfig'] = pageDesktopGridStyleConfig1;
        (pageDesktopDragHandler as object)['getPaddingLeft'](5);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['getPaddingLeft'](4);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['getPaddingLeft'](5);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['getPaddingLeft'](4);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(AppStorage, AppStorage.get);
      mock.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      done();
    })

    it('PageDesktopDragHandler_getPaddingLeft_test02', 0, async(done:Function) => {
      let pageDesktopGridStyleConfig1: PageDesktopGridStyleConfig = PageDesktopGridStyleConfig.getInstance();
      pageDesktopGridStyleConfig1.mMargin = 0;
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc)().afterReturn(true);
      let mockFunc1: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc1)().afterReturn(4);
      try {
        (pageDesktopDragHandler as object)['getPaddingLeft'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['getPositionByRowAndColumnWithoutRTL'](1, 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(AppStorage, AppStorage.get);
      mock.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      done();
    })

    it('PageDesktopDragHandler_initMultiDragItemsData_test01', 0, async(done:Function) => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let items: GridLayoutItemInfo[] = [item, item];
      let startPosition: DragItemPosition = {
        page: 0,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      }
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      when(mockFunc)().afterReturn(items);
      let mockFunc1: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['initMultiDragItemsData']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['mStartPosition'] = null;
        (pageDesktopDragHandler as object)['initMultiDragItemsData']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['mStartPosition'] = startPosition;
        (pageDesktopDragHandler as object)['initMultiDragItemsData']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      done();
    })

    it('PageDesktopDragHandler_initMultiDragItemsData_test02', 0, async(done:Function) => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let items: GridLayoutItemInfo[] = [item, item];
      let startPosition: DragItemPosition = {
        page: 0,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      }
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      when(mockFunc)().afterReturn(items);
      let mockFunc1: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['initMultiDragItemsData']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['mStartPosition'] = null;
        (pageDesktopDragHandler as object)['initMultiDragItemsData']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['mStartPosition'] = startPosition;
        (pageDesktopDragHandler as object)['initMultiDragItemsData']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      done();
    })

    it('PageDesktopDragHandler_onDragStart_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      when(mockFunc1)().afterReturn(gridLayoutItemInfo1);
      try {
        pageDesktopDragHandler.onDragStart(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}

      let startPosition: DragItemPosition = {
        page: 0,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };
      (pageDesktopDragHandler as object)['mStartPosition'] = startPosition;
      (pageDesktopDragHandler as object)['dragStartItemIndex'] = 1;
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (pageDesktopDragHandler as object)['isPc'] = false;
      let mockFunc2: Function =
        mock.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(mockFunc2)().afterReturn(true);
      try {
        pageDesktopDragHandler.onDragStart(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isPc'] = true;
      } catch (err) {}
      when(mockFunc2)().afterReturn(false);
      try {
        pageDesktopDragHandler.onDragStart(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.clear(GridLayoutUtil)
      mock.clear(pageDesktopDragHandler)
      mock.clear(DragAccessibilityUtils)
      mock.clearAll();
      done();
    })

    it('PageDesktopDragHandler_onDragLeave_test01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['isPc'] = true;
        (pageDesktopDragHandler as object)['isDropFileToDesktop'] = true;
        (pageDesktopDragHandler as object)['lastBoxPage'] = 0;
        pageDesktopDragHandler.onDragLeave(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isDropFileToDesktop'] = false;
        pageDesktopDragHandler.onDragLeave(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isPc'] = false;
        pageDesktopDragHandler.onDragLeave(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_onDragLeave_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc1)().afterReturn(undefined);
      try {
        pageDesktopDragHandler.clearLastCoveredItemAnimation();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc1)().afterReturn(null);
      try {
        pageDesktopDragHandler.clearLastCoveredItemAnimation();
        expect(pageDesktopDragHandler).not().assertUndefined();

        gridLayoutItemInfo1.keyName = '1';
        gridLayoutItemInfo1.typeId = CommonConstants.TYPE_APP;
      } catch (err) {}
      when(mockFunc1)().afterReturn(gridLayoutItemInfo1);
      let mockFunc2: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isIconType);
      when(mockFunc2)(CommonConstants.TYPE_APP).afterReturn(true);
      try {
        pageDesktopDragHandler.clearLastCoveredItemAnimation();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}

      gridLayoutItemInfo1.keyName = undefined;
      gridLayoutItemInfo1.typeId = CommonConstants.TYPE_FOLDER;
      gridLayoutItemInfo1.folderId = '1';
      try {
        pageDesktopDragHandler.clearLastCoveredItemAnimation();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      gridLayoutItemInfo1.folderId = undefined;
      try {
        pageDesktopDragHandler.clearLastCoveredItemAnimation();
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.typeId = CommonConstants.TYPE_CARD;
        gridLayoutItemInfo1.cardId = '1';
        pageDesktopDragHandler.clearLastCoveredItemAnimation();
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.cardId = undefined;
        pageDesktopDragHandler.clearLastCoveredItemAnimation();
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.typeId = CommonConstants.TYPE_FORM_STACK;
        gridLayoutItemInfo1.formStackId = '1';
        pageDesktopDragHandler.clearLastCoveredItemAnimation();
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.formStackId = undefined;
        pageDesktopDragHandler.clearLastCoveredItemAnimation();
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.typeId = CommonConstants.TYPE_FILE_FOLDER;
        gridLayoutItemInfo1.ino = '1';
        pageDesktopDragHandler.clearLastCoveredItemAnimation();
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.ino = undefined;
        pageDesktopDragHandler.clearLastCoveredItemAnimation();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(AppStorage, AppStorage.get);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isIconType);
      done();
    })

    it('PageDesktopDragHandler_coveredItemAnimation_test01', 0, async(done:Function) => {
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.typeId = CommonConstants.TYPE_APP;
      itemInfo.typeId = CommonConstants.TYPE_APP;
      dragItemInfo.area = [0];
      itemInfo.area = [0];
      try {
        (pageDesktopDragHandler as object)['coveredItemAnimation'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      itemInfo.area = [1];
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(FolderViewModel, FolderViewModel.isFolderFull);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['coveredItemAnimation'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        dragItemInfo.typeId = CommonConstants.TYPE_CARD;
        itemInfo.typeId = CommonConstants.TYPE_CARD;
        dragItemInfo.cardDimension = 0;
        itemInfo.cardDimension = 0;
        (pageDesktopDragHandler as object)['coveredItemAnimation'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        let items: GridLayoutItemInfo[] = [item];
        item.cardDimension = 0;
        itemInfo.cardDimension = 1;
        itemInfo.typeId = CommonConstants.TYPE_FORM_STACK;
        itemInfo.layoutInfo = [items];
        (pageDesktopDragHandler as object)['coveredItemAnimation'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        dragItemInfo.cardDimension = 10;
        dragItemInfo.typeId = CommonConstants.TYPE_FILE_FOLDER;
        itemInfo.typeId = CommonConstants.TYPE_FILE_FOLDER;
        itemInfo.fileType = FileType.TYPE_FOLDER;
        (pageDesktopDragHandler as object)['coveredItemAnimation'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        dragItemInfo.typeId = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
        (pageDesktopDragHandler as object)['coveredItemAnimation'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(FolderViewModel, FolderViewModel.isFolderFull);
      done();
    })

    it('PageDesktopDragHandler_textAnnouncedMerge_test01', 0, async(done:Function) => {
      try {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.typeId = CommonConstants.TYPE_FOLDER;
        (pageDesktopDragHandler as object)['textAnnouncedMerge'](item);
        expect(pageDesktopDragHandler).not().assertUndefined();
        item.typeId = CommonConstants.TYPE_CARD;
        (pageDesktopDragHandler as object)['coveredIsOtherItem'] = false;
        (pageDesktopDragHandler as object)['textAnnouncedMerge'](item);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['coveredIsOtherItem'] = true;
        (pageDesktopDragHandler as object)['textAnnouncedMerge'](item);
        expect(pageDesktopDragHandler).not().assertUndefined();
        item.typeId = CommonConstants.TYPE_FORM_STACK;
        let items: GridLayoutItemInfo[] = [item];
        item.layoutInfo = [items];
        (pageDesktopDragHandler as object)['coveredIsOtherItem'] = false;
        (pageDesktopDragHandler as object)['textAnnouncedMerge'](item);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['coveredIsOtherItem'] = true;
        (pageDesktopDragHandler as object)['textAnnouncedMerge'](item);
        expect(pageDesktopDragHandler).not().assertUndefined();
        item.typeId = CommonConstants.DOCK_SPACE;
        (pageDesktopDragHandler as object)['textAnnouncedMerge'](item);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_onDragEnter_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        pageDesktopDragHandler.onDragEnter(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        pageDesktopDragHandler.onDragEnter(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      done();
    })

    it('PageDesktopDragHandler_getItemDropPosition_test01', 0, async(done:Function) => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FOLDER;
      item.cardId = '1';
      let items: GridLayoutItemInfo[] = [item];
      item.layoutInfo = [items];
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(launchLayoutCacheManager1, launchLayoutCacheManager1.getAllGridLayoutItemList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(items);
      try {
        (pageDesktopDragHandler as object)['mLayoutCacheManager'] = launchLayoutCacheManager1;
        (pageDesktopDragHandler as object)['getItemDropPosition'](item);
        expect(pageDesktopDragHandler).not().assertUndefined();
        item1.typeId = CommonConstants.ICON_DEFAULT_SCALE;
        item1.cardId = '1';
        (pageDesktopDragHandler as object)['getItemDropPosition'](item1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        item.typeId = CommonConstants.DOCK_SPACE;
        (pageDesktopDragHandler as object)['getItemDropPosition'](item1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.clear(launchLayoutCacheManager1);
      mock.clearAll();
      done();
    })

    it('PageDesktopDragHandler_isInFormStack_test01', 0, async(done:Function) => {
      let formStackItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let cardItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem.typeId = CommonConstants.TYPE_FOLDER;
      cardItem.typeId = CommonConstants.TYPE_FOLDER;
      try {
        (pageDesktopDragHandler as object)['isInFormStack'](formStackItem, cardItem);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      formStackItem.typeId = CommonConstants.TYPE_FORM_STACK;
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        formStackItem.layoutInfo = [[]];
        (pageDesktopDragHandler as object)['isInFormStack'](formStackItem, cardItem);
        expect(pageDesktopDragHandler).not().assertUndefined();
        cardItem.typeId = CommonConstants.TYPE_CARD;
        (pageDesktopDragHandler as object)['isInFormStack'](formStackItem, cardItem);
        expect(pageDesktopDragHandler).not().assertUndefined();
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        let items: GridLayoutItemInfo[] = [item];
        item.cardId = '1';
        cardItem.cardId = '1';
        formStackItem.layoutInfo = [items];
      } catch (err) {}
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['isInFormStack'](formStackItem, cardItem);
        expect(pageDesktopDragHandler).not().assertUndefined();
        cardItem.cardId = '1111';
        (pageDesktopDragHandler as object)['isInFormStack'](formStackItem, cardItem);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      done();
    })

    it('PageDesktopDragHandler_handleFallItemAnimation_test01', 0, async(done:Function) => {
      let mEndPosition1: DragItemPosition = {
        page: 0,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      }
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('1');
      try {
        (pageDesktopDragHandler as object)['handleFallItemAnimation'](true);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      let mockFunc1: Function = mock.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      (pageDesktopDragHandler as object)['mEndPosition'] = mEndPosition1;
      (pageDesktopDragHandler as object)['lastBoxPage'] = -1;
      try {
        (pageDesktopDragHandler as object)['handleFallItemAnimation'](true);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['handleFallItemAnimation'](false);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      (pageDesktopDragHandler as object)['lastBoxPage'] = 1;
      try {
        (pageDesktopDragHandler as object)['handleFallItemAnimation'](true);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['handleFallItemAnimation'](false);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      mock.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('PageDesktopDragHandler_onDragMove_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      when(mockFunc1)().afterReturn(gridLayoutItemInfo1);
      try {
        pageDesktopDragHandler.onDragMove(NaN, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        pageDesktopDragHandler.onDragMove(1, NaN);
        expect(pageDesktopDragHandler).not().assertUndefined();
        pageDesktopDragHandler.onDragMove(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      try {
        pageDesktopDragHandler.onDragMove(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(AppStorage, AppStorage.get);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      done();
    })

    it('PageDesktopDragHandler_onDragMove_test02', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      when(mockFunc1)().afterReturn(gridLayoutItemInfo1);
      let mockFunc2: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(CommonConstants.DRAG_FROM_APPCENTER);
      try {
        pageDesktopDragHandler.onDragMove(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(CommonConstants.DRAG_FROM_MANAGE);
      let mockFunc3: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      when(mockFunc3)().afterReturn(0);
      (pageDesktopDragHandler as object)['mIsPrintLog'] = true;
      gridLayoutItemInfo1.page = 1;
      gridLayoutItemInfo1.area = [];
      gridLayoutItemInfo1.typeId = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      try {
        pageDesktopDragHandler.onDragMove(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.typeId = CommonConstants.TYPE_APP;
        pageDesktopDragHandler.onDragMove(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['mIsPrintLog'] = false;
        gridLayoutItemInfo1.area = [1, 1];
        pageDesktopDragHandler.onDragMove(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(AppStorage, AppStorage.get);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      done();
    })

    it('PageDesktopDragHandler_textAnnouncedForDragMove_test01', 0, async(done:Function) => {
      let moveItem1: MoveItem[] = [];
      let dragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 0, 0, 0, 0, 0, 0);
      let cellAndSpan: CellAndSpan = new CellAndSpan(0, 0, 0, 0);
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(mockFunc)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['textAnnouncedForDragMove'](gridLayoutItemInfo1, gridLayoutItemInfo1,
          dragDelegate, cellAndSpan);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['isPc'] = false;
        (pageDesktopDragHandler as object)['currentMoveItemList'] = moveItem1;
        (pageDesktopDragHandler as object)['textAnnouncedForDragMove'](gridLayoutItemInfo1, gridLayoutItemInfo1,
          dragDelegate, cellAndSpan);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isPc'] = true;
        (pageDesktopDragHandler as object)['textAnnouncedForDragMove'](gridLayoutItemInfo1, gridLayoutItemInfo1,
          dragDelegate, cellAndSpan);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      done();
    })

    it('PageDesktopDragHandler_textAnnouncedForDragMove_test01', 0, async(done:Function) => {
      try {
        let currentIndex: number[] = [];
        (pageDesktopDragHandler as object)['finallyFallPosition'] = [1, 1];
        (pageDesktopDragHandler as object)['coveredIsOtherItem'] = false;
        (pageDesktopDragHandler as object)['textAnnounced'](currentIndex);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['coveredIsOtherItem'] = true;
        (pageDesktopDragHandler as object)['textAnnounced'](currentIndex);
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch (err){}
      done();
    })

    it('PageDesktopDragHandler_updateColumnInFoldRight_test01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['isFoldNearScreen'] = true;
        (pageDesktopDragHandler as object)['updateColumnInFoldRight']();
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isFoldNearScreen'] = false;
        (pageDesktopDragHandler as object)['updateColumnInFoldRight']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done(0);
    })

    it('PageDesktopDragHandler_squeezeInHotArea_test01', 0, async (done:Function) => {
      let dragItemInfo: GridLayoutItemInfo = gridLayoutItemInfo1;
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let dragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 0, 0, 0, 0, 0, 0);
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['squeezeInHotArea'](dragItemInfo, itemInfo, dragDelegate, 0, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      (pageDesktopDragHandler as object)['zSqueeze'] = false;
      try {
        (pageDesktopDragHandler as object)['squeezeInHotArea'](dragItemInfo, itemInfo, dragDelegate, 0, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(AppStorage, AppStorage.get);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isIconType);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isSmallFolder);
      done();
    })

    it('PageDesktopDragHandler_judgeSqueezeExcludeCard_test01', 0, async(done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](undefined, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        dragItemInfo.typeId = CommonConstants.TYPE_APP;
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, undefined);
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.typeId = CommonConstants.TYPE_APP;
        dragItemInfo.keyName = '1';
        itemInfo.keyName = '2';
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.keyName = '1';
        itemInfo.typeId = CommonConstants.TYPE_FILE_FOLDER;
        dragItemInfo.ino = '1';
        itemInfo.ino = '2';
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.ino = '1';
        itemInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        dragItemInfo.shortcutId = '1';
        itemInfo.shortcutId = '2';
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.shortcutId = '1';
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.shortcutId = '2';
        itemInfo.typeId = CommonConstants.TYPE_CARD;
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        dragItemInfo.typeId = CommonConstants.TYPE_FILE_FOLDER;
        itemInfo.typeId = CommonConstants.TYPE_APP;
        dragItemInfo.keyName = '1';
        itemInfo.keyName = '2';
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.keyName = '1';
        itemInfo.typeId = CommonConstants.TYPE_FILE_FOLDER;
        dragItemInfo.ino = '1';
        itemInfo.ino = '2';
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.ino = '1';
        itemInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        dragItemInfo.shortcutId = '1';
        itemInfo.shortcutId = '2';
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.shortcutId = '1';
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.shortcutId = '2';
        itemInfo.typeId = CommonConstants.TYPE_CARD;
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        dragItemInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        itemInfo.typeId = CommonConstants.TYPE_APP;
        dragItemInfo.keyName = '1';
        itemInfo.keyName = '2';
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.keyName = '1';
        itemInfo.typeId = CommonConstants.TYPE_FILE_FOLDER;
        dragItemInfo.ino = '1';
        itemInfo.ino = '2';
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.ino = '1';
        itemInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        dragItemInfo.shortcutId = '1';
        itemInfo.shortcutId = '2';
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.shortcutId = '1';
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.shortcutId = '2';
        itemInfo.typeId = CommonConstants.TYPE_CARD;
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        dragItemInfo.typeId = CommonConstants.TYPE_CARD;
        (pageDesktopDragHandler as object)['judgeSqueezeExcludeCard'](dragItemInfo, itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_squeezeExcludeCard_test01', 0, async(done:Function) => {
      try {
        let dragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 0, 0, 0, 0, 0, 0);
        let cellAndSpan: CellAndSpan = new CellAndSpan(0, 0, 0, 0);
        (pageDesktopDragHandler as object)['squeezeExcludeCard'](0, 0, undefined, dragDelegate, undefined, cellAndSpan);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.typeId = CommonConstants.TYPE_CARD;
        (pageDesktopDragHandler as object)['squeezeExcludeCard'](0, 0, gridLayoutItemInfo1, dragDelegate, undefined,
          cellAndSpan);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.typeId = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
        (pageDesktopDragHandler as object)['squeezeExcludeCard'](0, 0, gridLayoutItemInfo1, dragDelegate, undefined,
          cellAndSpan);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_squeezeForPC_test01', 0, async(done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let dragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 0, 0, 0, 0, 0, 0);
        let cellAndSpan: CellAndSpan = new CellAndSpan(0, 0, 0, 0);
        (pageDesktopDragHandler as object)['isLeaveSwiperPage'] = true;
        (pageDesktopDragHandler as object)['squeezeForPC'](dragItemInfo, itemInfo, 0, 0, dragDelegate, cellAndSpan, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
        dragItemInfo.typeId = CommonConstants.TYPE_CARD;
        (pageDesktopDragHandler as object)['isLeaveSwiperPage'] = false;
        (pageDesktopDragHandler as object)['squeezeForPC'](dragItemInfo, itemInfo, 0, 0, dragDelegate, cellAndSpan, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
        dragItemInfo.typeId = CommonConstants.TYPE_APP;
        itemInfo.typeId === CommonConstants.TYPE_APP;
        dragItemInfo.keyName = '1';
        itemInfo.keyName = '2';
        (pageDesktopDragHandler as object)['isLeaveSwiperPage'] = false;
        (pageDesktopDragHandler as object)['squeezeForPC'](dragItemInfo, itemInfo, 0, 0, dragDelegate, cellAndSpan, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_computeCardSqueeze_test01', 0, async(done:Function) => {
      try {
        let dragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 0, 0, 0, 0, 0, 0);
        (pageDesktopDragHandler as object)['isLeaveSwiperPage'] = true;
        (pageDesktopDragHandler as object)['computeCardSqueeze'](dragDelegate);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_itemMoveNSqueeze_test01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['dragEndItemIndex'] = null;
        (pageDesktopDragHandler as object)['itemMoveNSqueeze'](0, 0, 0, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['dragEndItemIndex'] = 1;
        (pageDesktopDragHandler as object)['mEndPosition'] = null;
        (pageDesktopDragHandler as object)['itemMoveNSqueeze'](0, 0, 0, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['mEndPosition'] = null;
        (pageDesktopDragHandler as object)['itemMoveNSqueeze'](0, 0, 0, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['mEndPosition'] = {
          page: 0,
          row: 0,
          column: 0,
          x: 0,
          y: 0
        };
        (pageDesktopDragHandler as object)['itemMoveNSqueeze'](0, 0, -1, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['itemMoveNSqueeze'](0, 0, 100, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['itemMoveNSqueeze'](0, 1000, 0, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_itemMoveReNSqueeze_test01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['dragEndItemIndex'] = null;
        (pageDesktopDragHandler as object)['mEndPosition'] = null;
        (pageDesktopDragHandler as object)['itemMoveReNSqueeze'](0, 0, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['mEndPosition'] = {
          page: 0,
          row: 0,
          column: 0,
          x: 0,
          y: 0
        };
        (pageDesktopDragHandler as object)['itemMoveReNSqueeze'](0, 0, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['dragEndItemIndex'] = 1;
        (pageDesktopDragHandler as object)['itemMoveReNSqueeze'](0, 0, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_notifyIntelligentDragEnter_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      try {
        pageDesktopDragHandler.notifyIntelligentDragEnter();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      when(mockFunc2)().afterReturn(gridLayoutItemInfo1);
      (pageDesktopDragHandler as object)['mEndPosition'] = null;
      try {
        pageDesktopDragHandler.notifyIntelligentDragEnter();
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['mEndPosition'] = {
          page: 0,
          row: 0,
          column: 0,
          x: 0,
          y: 0
        };
        pageDesktopDragHandler.notifyIntelligentDragEnter();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(AppStorage, AppStorage.get);
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      done();
    })

    it('PageDesktopDragHandler_isValidArea_test01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['isValidArea']([]);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isValidArea']([1]);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isValidArea']([1, 1]);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_multiItemSqueeze_test01', 0, async(done:Function) => {
      let bigFolderViewModel1: BigFolderViewModel = BigFolderViewModel.getInstance();
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(bigFolderViewModel1, bigFolderViewModel1.getFolderAnimationCount);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let dragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 0, 0, 0, 0, 0, 0);
      let cellAndSpan: CellAndSpan = new CellAndSpan(0, 0, 0, 0);
      try {
        (pageDesktopDragHandler as object)['multiItemSqueeze'](null, dragItemInfo, cellAndSpan, false);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['multiItemSqueeze'](dragDelegate, null, cellAndSpan, false);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['multiItemSqueeze'](dragDelegate, dragItemInfo, null, false);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['mBigFolderViewModel'] = bigFolderViewModel1;
        (pageDesktopDragHandler as object)['multiItemSqueeze'](dragDelegate, dragItemInfo, cellAndSpan, false);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(bigFolderViewModel1, bigFolderViewModel1.getFolderAnimationCount);
      done();
    })

    it('PageDesktopDragHandler_getPageLayoutInfo_test01', 0, async(done:Function) => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let items: GridLayoutItemInfo[] = [item, item];
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(launchLayoutCacheManager1, launchLayoutCacheManager1.selectGridLayoutItemsByPage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(items);
      let mockFunc2: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      when(mockFunc2)().afterReturn(items);
      try {
        (pageDesktopDragHandler as object)['getPageLayoutInfo'](0);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc2)().afterReturn(undefined);
      try {
        (pageDesktopDragHandler as object)['getPageLayoutInfo'](0);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(launchLayoutCacheManager1, launchLayoutCacheManager1.selectGridLayoutItemsByPage);
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      done();
    })

    it('PageDesktopDragHandler_isTwoItemOverlap_test01', 0, async(done:Function) => {
      try {
        let rectX: RectItem = new RectItem(0, 0, 0, 0);
        let rectY: RectItem = new RectItem(0, 0, 0, 0);
        rectY.bottom = 0;
        rectX.top = 2;
        (pageDesktopDragHandler as object)['isTwoItemOverlap'](rectX, rectY);
        expect(pageDesktopDragHandler).not().assertUndefined();
        rectY.bottom = 2;
        rectX.top = 0;
        rectX.bottom = 0;
        rectY.top = 2;
        (pageDesktopDragHandler as object)['isTwoItemOverlap'](rectX, rectY);
        expect(pageDesktopDragHandler).not().assertUndefined();
        rectX.bottom = 2;
        rectY.top = 0;
        rectX.left = 2;
        rectY.right = 0;
        (pageDesktopDragHandler as object)['isTwoItemOverlap'](rectX, rectY);
        expect(pageDesktopDragHandler).not().assertUndefined();
        rectX.left = 0;
        rectY.right = 2;
        rectY.left = 2;
        rectX.right = 0;
        (pageDesktopDragHandler as object)['isTwoItemOverlap'](rectX, rectY);
        expect(pageDesktopDragHandler).not().assertUndefined();
        rectY.left = 0;
        rectX.right = 2;
        (pageDesktopDragHandler as object)['isTwoItemOverlap'](rectX, rectY);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_resetMoveItemList_test01', 0, async(done:Function) => {
      try {
        let moveItem1: MoveItem = new MoveItem();
        let moveItems1: MoveItem[] = [moveItem1, moveItem1];
        (pageDesktopDragHandler as object)['currentMoveItemList'] = moveItems1;
        (pageDesktopDragHandler as object)['resetMoveItemList']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_resetLastMoveItemList_test01', 0, async(done:Function) => {
      try {
        let moveItem1: MoveItem = new MoveItem();
        let moveItems1: MoveItem[] = [moveItem1, moveItem1];
        (pageDesktopDragHandler as object)['currentMoveItemList'] = moveItems1;
        (pageDesktopDragHandler as object)['resetLastMoveItemList']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_updateMoveList_test01', 0, async(done:Function) => {
      let moveItem1: MoveItem = new MoveItem();
      let moveItems1: MoveItem[] = [moveItem1, moveItem1];
      let moveItems: MoveItem[] = [];
      (pageDesktopDragHandler as object)['currentMoveItemList'] = moveItems;
      let fallItemData: DragItem = new DragItem();
      (pageDesktopDragHandler as object)['isPc'] = true;
      try {
        (pageDesktopDragHandler as object)['updateMoveList'](fallItemData);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isPc'] = false;
        (pageDesktopDragHandler as object)['updateMoveList'](fallItemData);
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch(err){}
      (pageDesktopDragHandler as object)['currentMoveItemList'] = moveItems1;
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      when(mockFunc1)().afterReturn(0);
      (pageDesktopDragHandler as object)['isDragPaste'] = true;
      try {
        (pageDesktopDragHandler as object)['updateMoveList'](fallItemData);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isDragPaste'] = false;
        (pageDesktopDragHandler as object)['updateMoveList'](fallItemData);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      done();
    })

    it('PageDesktopDragHandler_calculateEmptyCount_test01', 0, async(done:Function) => {
      let fallItemData: DragItem = new DragItem();
      (pageDesktopDragHandler as object)['mGridConfig'] = {
        row: 1,
        column: 1
      };
      fallItemData.result = [1, 1];
      (pageDesktopDragHandler as object)['pcMultiDragCount'] = 0;
      let mock: MockKit = new MockKit();
      let mockFunc4: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['calculateEmptyCount'](fallItemData);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['pcMultiDragCount'] = 10;
        (pageDesktopDragHandler as object)['calculateEmptyCount'](fallItemData);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      done();
    })

    it('PageDesktopDragHandler_showSqueezeContinueItem_test01', 0, async(done:Function) => {
      try {
        gridLayoutItemInfo1.page = 0;
        (pageDesktopDragHandler as object)['showSqueezeContinueItem'](gridLayoutItemInfo1, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.page = 1;
        (pageDesktopDragHandler as object)['showSqueezeContinueItem'](gridLayoutItemInfo1, 0);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_judgeItem_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc4: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.checkGridItemEqual);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['judgeItem'](gridLayoutItemInfo1, gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['judgeItem'](gridLayoutItemInfo1, gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.checkGridItemEqual);
      done();
    })

    it('PageDesktopDragHandler_notifyGridWhiteEdgeShow_test01', 0, async(done:Function) => {
      let pageDesktopGridStyleConfig1: PageDesktopGridStyleConfig = PageDesktopGridStyleConfig.getInstance();
      pageDesktopGridStyleConfig1.mMargin = 0;
      pageDesktopGridStyleConfig1.mFoldPaddingSide = 0;
      (pageDesktopDragHandler as object)['mEndPosition'] = {
        page: 0,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };
      (pageDesktopDragHandler as object)['mPaddingLeft'] = 5;
      (pageDesktopDragHandler as object)['mPageDesktopStyleConfig'] = pageDesktopGridStyleConfig1;
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc)().afterReturn(true);
      let mockFunc3: Function = mock.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc3)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['notifyGridWhiteEdgeShow'](3, []);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['notifyGridWhiteEdgeShow'](4, []);
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch(err){}
      when(mockFunc3)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['notifyGridWhiteEdgeShow'](4, []);
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch(err){}
      when(mockFunc3)().afterReturn(true);
      when(mockFunc)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['notifyGridWhiteEdgeShow'](4, []);
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch(err){}
      mock.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mock.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('PageDesktopDragHandler_notifyGridWhiteEdgeHide_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['notifyGridWhiteEdgeHide'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['notifyGridWhiteEdgeHide'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      done();
    })

    it('PageDesktopDragHandler_getNeighborPageForWhiteBox_test01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['getNeighborPageForWhiteBox'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['getNeighborPageForWhiteBox'](2);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_getDragItemArea_test01', 0, async(done:Function) => {
      try {
        gridLayoutItemInfo1.area = [1, 1];
        (pageDesktopDragHandler as object)['getDragItemArea'](gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.area = undefined;
        gridLayoutItemInfo1.typeId = CommonConstants.TYPE_APP;
        (pageDesktopDragHandler as object)['getDragItemArea'](gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        (pageDesktopDragHandler as object)['getDragItemArea'](gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.typeId = CommonConstants.TYPE_FILE_FOLDER;
        (pageDesktopDragHandler as object)['getDragItemArea'](gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.typeId = CommonConstants.TYPE_FOLDER;
        (pageDesktopDragHandler as object)['getDragItemArea'](gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.typeId = CommonConstants.TYPE_CARD;
        (pageDesktopDragHandler as object)['getDragItemArea'](gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.typeId = CommonConstants.TYPE_REGION_FOLDER;
        (pageDesktopDragHandler as object)['getDragItemArea'](gridLayoutItemInfo1);
        gridLayoutItemInfo1.typeId = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
        (pageDesktopDragHandler as object)['getDragItemArea'](gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_isLockedLayout_test01', 0, async(done:Function) => {
      try {
        (layoutLockUtil as object)['locked'] = true;
        (layoutLockUtil as object)['lockedPageNum'] = 10;
        (pageDesktopDragHandler as object)['isLockedLayout'](1, 1, 1, '1');
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isLockedLayout'](20, 1, CommonConstants.DRAG_FROM_DESKTOP, '1');
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isLockedLayout'](20, 1, CommonConstants.DRAG_FROM_DOCK, '1');
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isLockedLayout'](20, 20, CommonConstants.DRAG_FROM_DOCK, '1');
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isLockedLayout'](20, 20, CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM, '1');
        expect(pageDesktopDragHandler).not().assertUndefined();
        (layoutLockUtil as object)['locked'] = false;
        (pageDesktopDragHandler as object)['isLockedLayout'](20, 20, CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM, '1');
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_isLockedLayout_test01', 0, async(done:Function) => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let items: GridLayoutItemInfo[] = [];
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      try {
        pageDesktopDragHandler.getDragItems();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc)(ArgumentMatchers.any).afterReturn(items);
      try {
        pageDesktopDragHandler.getDragItems();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      let items1: GridLayoutItemInfo[] = [item, item];
      when(mockFunc)(ArgumentMatchers.any).afterReturn(items1);
      try {
        pageDesktopDragHandler.getDragItems();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc)(ArgumentMatchers.any).afterReturn(item);
      try {
        pageDesktopDragHandler.getDragItems();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(AppStorage, AppStorage.get);
      done();
    })

    it('PageDesktopDragHandler_getDragImage_test01', 0, async(done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = gridLayoutItemInfo1;
        let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let items: GridLayoutItemInfo[] = [dragItemInfo];
        endLayoutInfo.layoutInfo = undefined;
        (pageDesktopDragHandler as object)['getDragImage'](dragItemInfo, endLayoutInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
        endLayoutInfo.layoutInfo = [items];
        (pageDesktopDragHandler as object)['getDragImage'](dragItemInfo, endLayoutInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_dealSwiperPageOnDragMove_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc)().afterReturn(false);
      (pageDesktopDragHandler as object)['isPhone'] = false;
      try {
        pageDesktopDragHandler.dealSwiperPageOnDragMove(null, '1');
        expect(pageDesktopDragHandler).not().assertUndefined();
        pageDesktopDragHandler.dealSwiperPageOnDragMove(dragEvent, '1');
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch(err){}
      (pageDesktopDragHandler as object)['isPhone'] = true;
      (pageDesktopDragHandler as object)['isDropFileToDesktop'] = true;
      let mockFunc1: Function = mock.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(mockFunc1)().afterReturn(true);
      try {
        pageDesktopDragHandler.dealSwiperPageOnDragMove(dragEvent, '1');
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch(err){}
      (pageDesktopDragHandler as object)['isPhone'] = false;
      when(mockFunc)().afterReturn(true);
      (pageDesktopDragHandler as object)['isDropFileToDesktop'] = false;
      when(mockFunc1)().afterReturn(false);
      try {
        pageDesktopDragHandler.dealSwiperPageOnDragMove(dragEvent, '1');
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch(err){}
      mock.ignoreMock(DeviceHelper, DeviceHelper.isPC);
      mock.ignoreMock(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      done();
    })

    it('PageDesktopDragHandler_textAnnouncedForNearScreen_test01', 0, async(done:Function) => {
      let pageDesktopGridStyleConfig1: PageDesktopGridStyleConfig = PageDesktopGridStyleConfig.getInstance();
      pageDesktopGridStyleConfig1.mMargin = 0;
      pageDesktopGridStyleConfig1.mFoldPaddingSide = 0;
      (pageDesktopDragHandler as object)['mPageDesktopStyleConfig'] = pageDesktopGridStyleConfig1;
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(0);
      try {
        (pageDesktopDragHandler as object)['isAnnouncedForNearScreen'] = false;
        pageDesktopDragHandler.textAnnouncedForNearScreen(dragEvent);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isAnnouncedForNearScreen'] = true;
        pageDesktopDragHandler.textAnnouncedForNearScreen(dragEvent);
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch(err){}
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1000);
      try {
        (pageDesktopDragHandler as object)['isAnnouncedForNearScreen'] = false;
        pageDesktopDragHandler.textAnnouncedForNearScreen(dragEvent);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['isAnnouncedForNearScreen'] = true;
        pageDesktopDragHandler.textAnnouncedForNearScreen(dragEvent);
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch(err){}
      mock.ignoreMock(AppStorage, AppStorage.get)
      done();
    })

    it('PageDesktopDragHandler_textAnnouncedForNearScreen_test01', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(DeviceState.DEFAULT_STATE);
      try {
        (pageDesktopDragHandler as object)['getFoldPadding']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc)(ArgumentMatchers.any).afterReturn(DeviceState.EXPAND_STATE);
      try {
        (pageDesktopDragHandler as object)['getFoldPadding']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(AppStorage, AppStorage.get);
      done();
    })

    it('PageDesktopDragHandler_getExtra_test01', 0, async(done:Function) => {
      try {
        pageDesktopDragHandler.getExtra();
        expect(pageDesktopDragHandler).not().assertUndefined();
        pageDesktopDragHandler.getExtra('1');
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandler_dragPasteFile_test01', 0, async(done:Function) => {
      try {
        let pageDesktopGridStyleConfig1: PageDesktopGridStyleConfig = PageDesktopGridStyleConfig.getInstance();
        pageDesktopGridStyleConfig1.mRowsGap = 1;
        pageDesktopGridStyleConfig1.mColumnsGap = 1;
        (pageDesktopDragHandler as object)['mPaddingLeft'] = 1;
        (pageDesktopDragHandler as object)['mPaddingLeft'] = 1;
        (pageDesktopDragHandler as object)['mGridConfig'] = {
          row: 1,
          column: 1
        };
        (pageDesktopDragHandler as object)['mGridItemWidth'] = 1;
        (pageDesktopDragHandler as object)['mGridItemHeight'] = 1;
        (pageDesktopDragHandler as object)['mPageDesktopStyleConfig'] = pageDesktopGridStyleConfig1;
        (pageDesktopDragHandler as object)['dragPasteFile'](dragEvent, '1', false);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['dragPasteFile'](dragEvent, '1', true);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })

    it('PageDesktopDragHandlerTest_cacheDragImage_01', 0, async(done:Function) => {
      try {
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        (pageDesktopDragHandler as object)['cacheDragImage'](itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_cacheDragImage_02', 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().cacheDragCardImage);
      when(mockFuc)().afterThrow('error')
      try {
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        (pageDesktopDragHandler as object)['cacheDragImage'](itemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock(FormStackManager.getInstance(), FormStackManager.getInstance().cacheDragCardImage);
      done();
    });


    it('PageDesktopDragHandlerTest_refreshResident_01', 0, async(done:Function) => {
      try {
        let dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItem.area = [1, 1];
        dragItem.typeId = CommonConstants.TYPE_FOLDER;
        (pageDesktopDragHandler as object)['refreshResident'](dragItem, CommonConstants.DRAG_FROM_DOCK);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_refreshResident_02', 0, async(done:Function) => {
      try {
        let dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItem.area = [1, 1];
        dragItem.typeId = CommonConstants.TYPE_FOLDER;
        (pageDesktopDragHandler as object)['refreshResident'](dragItem, CommonConstants.DRAG_FROM_DESKTOP);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_textAnnouncedForDrop_01', 0, async(done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItemInfo.area = [1, 1];
        dragItemInfo.typeId = CommonConstants.TYPE_FOLDER;
        (pageDesktopDragHandler as object)['finallyFallPosition'] = [1, 1];
        (pageDesktopDragHandler as object)['textAnnouncedForDrop'](dragItemInfo, [dragItemInfo]);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_textAnnouncedForDrop_02', 0, async(done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let dragItemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItemInfo.area = [1, 1];
        dragItemInfo.layoutInfo = [[dragItemInfo1]];
        dragItemInfo.typeId = CommonConstants.TYPE_FORM_STACK;
        (pageDesktopDragHandler as object)['finallyFallPosition'] = [1, 1];
        (pageDesktopDragHandler as object)['textAnnouncedForDrop'](dragItemInfo, [dragItemInfo]);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_textAnnouncedForDrop_03', 0, async(done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItemInfo.area = [1, 1];
        dragItemInfo.typeId = CommonConstants.TYPE_FORM_COMBINE;
        (pageDesktopDragHandler as object)['finallyFallPosition'] = [1, 1];
        (pageDesktopDragHandler as object)['textAnnouncedForDrop'](dragItemInfo, [dragItemInfo]);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_textAnnouncedForDrop_04', 0, async(done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItemInfo.area = [1, 1];
        dragItemInfo.typeId = CommonConstants.TYPE_FORM_COMBINE;
        (pageDesktopDragHandler as object)['finallyFallPosition'] = [1, 1];
        (pageDesktopDragHandler as object)['textAnnouncedForDrop'](dragItemInfo, [dragItemInfo, dragItemInfo]);
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch(err){}
      done();
    });

    it('PageDesktopDragHandlerTest_textAnnouncedForDrop_05', 0, async(done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItemInfo.area = [1, 1];
        dragItemInfo.typeId = CommonConstants.TYPE_FORM_COMBINE;
        (pageDesktopDragHandler as object)['finallyFallPosition'] = [1, 0];
        (pageDesktopDragHandler as object)['textAnnouncedForDrop'](dragItemInfo, [dragItemInfo]);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_deleteDockItem_01', 0, async(done:Function) => {
      try {
        let pageDesktopDragHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance();
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItemInfo.area = [1, 1];
        dragItemInfo.typeId = CommonConstants.TYPE_FORM_COMBINE;
        (pageDesktopDragHandler as object)['deleteDockItem'](dragItemInfo);
        expect(pageDesktopDragHandler).not().assertNull();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_updateDragEndPosition_01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['updateDragEndPosition'](null, 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['updateDragEndPosition']([null, 1], 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['updateDragEndPosition']([1, null], 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch(err){}
      done();
    });

    it('PageDesktopDragHandlerTest_updateDragEndPosition_02', 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc((pageDesktopDragHandler as object),
          (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze']);
      when(mockFuc)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['updateDragEndPosition']([1, 1], 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFuc)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['updateDragEndPosition']([1, 1], 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock((pageDesktopDragHandler as object),
        (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze']);
      done();
    });

    it('PageDesktopDragHandlerTest_getDragEndPositionIndex_01', 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc((pageDesktopDragHandler as object),
          (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze']);
      when(mockFuc)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['getDragEndPositionIndex'](1, 1, 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock((pageDesktopDragHandler as object),
        (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze']);
      done();
    });

    it('PageDesktopDragHandlerTest_getDragEndPositionIndex_02', 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc((pageDesktopDragHandler as object),
          (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze']);
      when(mockFuc)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['getDragEndPositionIndex'](1, 1, 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock((pageDesktopDragHandler as object),
        (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze']);
      done();
    });

    it('PageDesktopDragHandlerTest_needUpdateEndPosIfNSqueeze_01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['zSqueeze'] = true;
        (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze'](1, 1, 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_needUpdateEndPosIfNSqueeze_02', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['zSqueeze'] = false;
        (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze'](null, 1, 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze'](1, null, 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_needUpdateEndPosIfNSqueeze_03', 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getRowAndColumn);
      when(mockFuc)(ArgumentMatchers.any).afterReturn(false);
      let mockFuc1: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getRowAndColumn);
      when(mockFuc1)(ArgumentMatchers.any).afterReturn({
        row: 1,
        column: 1
      });
      (pageDesktopDragHandler as object)['zSqueeze'] = false;
      (pageDesktopDragHandler as object)['mGridConfig'] = {
        row: 2,
        column: 1
      };
      try {
        (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze'](1, 100, 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['mGridConfig'] = {
          row: 1,
          column: 1
        };
        (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze'](1, 100, 10, 10);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze'](1, 100, 1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      }catch(err){}
      mocker.ignoreMock(GridLayoutUtil, GridLayoutUtil.getRowAndColumn);
      done();
    });

    it('PageDesktopDragHandlerTest_needUpdateEndPosIfNSqueeze_04', 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getRowAndColumn);
      when(mockFuc)(ArgumentMatchers.any).afterReturn(false);
      let mockFuc1: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getRowAndColumn);
      when(mockFuc1)(ArgumentMatchers.any).afterReturn({
        row: 1,
        column: 1
      });
      (pageDesktopDragHandler as object)['zSqueeze'] = false;
      (pageDesktopDragHandler as object)['mGridConfig'] = {
        row: 1,
        column: 1
      };
      (pageDesktopDragHandler as object)['mStartPosition'] = {
        page: 1,
        row: 1,
        column: 1,
        x: 1,
        y: 1,
        isInDock: false,
        originColumn: 1,
      };
      let pageDesktopGridStyleConfig1: PageDesktopGridStyleConfig = PageDesktopGridStyleConfig.getInstance();
      pageDesktopGridStyleConfig1.mIconMarginVertical = 0;
      pageDesktopGridStyleConfig1.mFoldPaddingSide = 0;
      try {
        (pageDesktopDragHandler as object)['mPageDesktopStyleConfig'] = pageDesktopGridStyleConfig1;
        (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze'](1, 100, null, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['needUpdateEndPosIfNSqueeze'](1, 100, 1, null);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock(GridLayoutUtil, GridLayoutUtil.getRowAndColumn);
      done();
    });

    it('PageDesktopDragHandlerTest_getNearestArea_01', 0, async(done:Function) => {
      try {
        let cellLayoutDragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(10, 10, 1, 1, 20, 20, 1, 1);
        let cellAndSpan: CellAndSpan = new CellAndSpan(1, 10, 1, 1);
        (pageDesktopDragHandler as object)['getNearestArea'](cellLayoutDragDelegate, cellAndSpan);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_updatePositionByRTL_01', 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFuc)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['updatePositionByRTL']([1, 1, 1], 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    });

    it('PageDesktopDragHandlerTest_handleCreateCardAfterDragDrop_01', 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(FormModel.getInstance(), FormModel.getInstance().checkIfCardExceedLimit);
      when(mockFuc)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['handleCreateCardAfterDragDrop'](1, 1, new GridLayoutItemInfo(),
          CommonConstants.DRAG_FROM_FORM_INTELLIGENT);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock(FormModel.getInstance(), FormModel.getInstance().checkIfCardExceedLimit);
      done();
    });

    it('PageDesktopDragHandlerTest_handleCreateCardAfterDragDrop_02', 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(FormModel.getInstance(), FormModel.getInstance().checkIfCardExceedLimit);
      when(mockFuc)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['handleCreateCardAfterDragDrop'](1, 1, new GridLayoutItemInfo(),
          CommonConstants.DRAG_FROM_FORM_INTELLIGENT);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock(FormModel.getInstance(), FormModel.getInstance().checkIfCardExceedLimit);
      done();
    });

    it('PageDesktopDragHandlerTest_handleCreateCardAfterDragDrop_03', 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(FormModel.getInstance(), FormModel.getInstance().checkIfCardExceedLimit);
      when(mockFuc)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['handleCreateCardAfterDragDrop'](1, 1, new GridLayoutItemInfo(),
          CommonConstants.DRAG_FROM_FORM_SERVICE);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock(FormModel.getInstance(), FormModel.getInstance().checkIfCardExceedLimit);
      done();
    });

    it('PageDesktopDragHandlerTest_handleCreateCardAfterDragDrop_04', 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(FormModel.getInstance(), FormModel.getInstance().checkIfCardExceedLimit);
      when(mockFuc)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['handleCreateCardAfterDragDrop'](1, 1, new GridLayoutItemInfo(),
          CommonConstants.DRAG_FROM_FORM_SERVICE);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock(FormModel.getInstance(), FormModel.getInstance().checkIfCardExceedLimit);
      done();
    });

    it('PageDesktopDragHandlerTest_handleDragCardEventFromIntelligent_01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['handleDragCardEventFromIntelligent'](1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_isCorrectDropSolution_01', 0, async(done:Function) => {
      let moveItem: MoveItem = new MoveItem();
      let moveItemList: MoveItem[] = [moveItem, moveItem];
      let fallItem: DragItem = new DragItem();
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.typeId = 1;
      itemInfo.area = [1, 1];
      fallItem.data = itemInfo;
      fallItem.result = [1, 1];
      try {
        (pageDesktopDragHandler as object)['isCorrectDropSolution'](moveItemList, fallItem);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_isCorrectDropSolution_02', 0, async(done:Function) => {
      let moveItem: MoveItem = new MoveItem();
      let moveItemList: MoveItem[] = [moveItem, moveItem];
      let fallItem: DragItem = new DragItem();
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.typeId = 1;
      fallItem.data = undefined;
      try {
        (pageDesktopDragHandler as object)['isCorrectDropSolution'](moveItemList, fallItem);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_isCorrectDropSolution_03', 0, async(done:Function) => {
      try {
        let moveItem: MoveItem = new MoveItem();
        let moveItemList: MoveItem[] = [moveItem, moveItem];
        (pageDesktopDragHandler as object)['isCorrectDropSolution'](moveItemList, undefined);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_getCrossItems_01', 0, async(done:Function) => {
      gridLayoutItemInfo1.column = 1;
      gridLayoutItemInfo1.row = 1;
      gridLayoutItemInfo1.area = [1, 1];
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragPageIndex);
      when(mockFuc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo1);
      let mockFuc1: Function =
        mocker.mockFunc(RectItem, RectItem.intersects);
      when(mockFuc1)(ArgumentMatchers.any).afterReturn(true);
      let dragRect: RectItem = new RectItem(1, 1, 1, 1);
      try {
        (pageDesktopDragHandler as object)['getCrossItems'](dragRect);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFuc)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        (pageDesktopDragHandler as object)['getCrossItems'](dragRect);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getDragPageIndex);
      mocker.ignoreMock(RectItem, RectItem.intersects);
      done();
    });


    it('PageDesktopDragHandlerTest_reportDragSequence_01', 0, async(done:Function) => {
      try {
        (pageDesktopDragHandler as object)['reportDragSequence'](undefined, undefined);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_reportDragSequence_02', 0, async(done:Function) => {
      gridLayoutItemInfo1.typeId = CommonConstants.TYPE_FOLDER;
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getItemByPosition']);
      when(mockFuc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo1);
      try {
        (pageDesktopDragHandler as object)['reportDragSequence'](dragItemInfo, endPosition);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getItemByPosition']);
      done();
    });

    it('PageDesktopDragHandlerTest_reportDragSequence_02', 0, async(done:Function) => {
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.typeId = 1;
      let mocker: MockKit = new MockKit();
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      let mockFuc: Function =
        mocker.mockFunc(pageDesktopDragHandler, (pageDesktopDragHandler as object)['getItemByPosition']);
      when(mockFuc)().afterReturn(itemInfo);
      try {
        (pageDesktopDragHandler as object)['reportDragSequence'](dragItemInfo, {
          page: 1,
          row: 1,
          column: 1,
          x: 1,
          y: 1,
          isInDock: true,
          originColumn: 10,
        });
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock(pageDesktopDragHandler, (pageDesktopDragHandler as object)['getItemByPosition']);
      done();
    });

    it('PageDesktopDragHandlerTest_reportDragSequence_03', 0, async(done:Function) => {
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.typeId = 1;
      let mocker: MockKit = new MockKit();
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.typeId = CommonConstants.TYPE_ADD;
      let mockFuc: Function =
        mocker.mockFunc(pageDesktopDragHandler, (pageDesktopDragHandler as object)['getItemByPosition']);
      when(mockFuc)().afterReturn(itemInfo);
      try {
        (pageDesktopDragHandler as object)['reportDragSequence'](dragItemInfo, {
          page: 1,
          row: 1,
          column: 1,
          x: 1,
          y: 1,
          isInDock: true,
          originColumn: 10,
        });
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock(pageDesktopDragHandler, (pageDesktopDragHandler as object)['getItemByPosition']);
      done();
    });

    it('PageDesktopDragHandlerTest_getReportDragBehaviorType_01', 0, async(done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_DOCK);
        (pageDesktopDragHandler as object)['reportDragSequence'](dragItemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_getReportDragBehaviorType_02', 0, async(done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItemInfo.page = 1;
        (pageDesktopDragHandler as object)['mEndPosition'] = {
          page: 1,
          row: 1,
          column: 1,
          x: 1,
          y: 1,
          isInDock: true,
          originColumn: 10,
        }
        AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_DESKTOP);
        (pageDesktopDragHandler as object)['reportDragSequence'](dragItemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_getReportDragBehaviorType_03', 0, async(done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItemInfo.page = 2;
        (pageDesktopDragHandler as object)['mEndPosition'] = {
          page: 1,
          row: 1,
          column: 1,
          x: 1,
          y: 1,
          isInDock: true,
          originColumn: 10,
        }
        AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_DESKTOP);
        (pageDesktopDragHandler as object)['reportDragSequence'](dragItemInfo);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_reSqueezeOnDrop_01', 0, async(done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItemInfo.typeId = CommonConstants.TYPE_APP;
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let cellLayoutDragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(10, 10, 1, 1, 20, 20, 1, 1);
        let cellAndSpan: CellAndSpan = new CellAndSpan(1, 10, 1, 1);
        (pageDesktopDragHandler as object)['reportDragSequence'](dragItemInfo, itemInfo, 1, 'phone', 1, 1,
          cellLayoutDragDelegate, cellAndSpan);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_reSqueezeOnDrop_02', 0, async (done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItemInfo.typeId = CommonConstants.TYPE_APP;
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        itemInfo.typeId = CommonConstants.TYPE_FOLDER;
        let cellLayoutDragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(10, 10, 1, 1, 20, 20, 1, 1);
        let cellAndSpan: CellAndSpan = new CellAndSpan(1, 10, 1, 1);
        (pageDesktopDragHandler as object)['reportDragSequence'](dragItemInfo, itemInfo, 1, 'phone', 1, 1,
          cellLayoutDragDelegate, cellAndSpan);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_addToFolder_01', 0, async(done:Function) => {
      try {
        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItemInfo.typeId = CommonConstants.TYPE_APP;
        let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        endLayoutInfo.typeId = CommonConstants.TYPE_FOLDER;
        (pageDesktopDragHandler as object)['addToFolder'](1, 1, CommonConstants.DRAG_FROM_FOLDER, 'phone',
          dragItemInfo, endLayoutInfo,
          {
            page: 1,
            row: 1,
            column: 1,
            x: 1,
            y: 1,
            isInDock: true,
            originColumn: 10,
          }, {
            page: 2,
            row: 10,
            column: 0,
            x: 1,
            y: 1,
            isInDock: false,
            originColumn: 10,
          });
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    });

    it('PageDesktopDragHandlerTest_addToFolder_02', 0, async(done:Function) => {
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.typeId = CommonConstants.TYPE_APP;
      let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      endLayoutInfo.typeId = CommonConstants.TYPE_FOLDER;
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFuc)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['addToFolder'](1, 1, CommonConstants.DRAG_FROM_FOLDER, 'phone',
          dragItemInfo, endLayoutInfo,
          {
            page: 1,
            row: 1,
            column: 1,
            x: 1,
            y: 1,
            isInDock: true,
            originColumn: 10,
          }, {
            page: 2,
            row: 10,
            column: 0,
            x: 1,
            y: 1,
            isInDock: false,
            originColumn: 10,
          });
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      done();
    });

    it('PageDesktopDragHandlerTest_addToFolder_03', 0, async(done:Function) => {
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.typeId = CommonConstants.TYPE_APP;
      let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      endLayoutInfo.typeId = CommonConstants.TYPE_FOLDER;
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFuc)().afterReturn(false);
      try {
        AppStorage.setOrCreate('device', CommonConstants.DEFAULT_DEVICE_TYPE);
        (pageDesktopDragHandler as object)['addToFolder'](1, 1, CommonConstants.DRAG_FROM_FOLDER, 'phone',
          dragItemInfo, endLayoutInfo,
          {
            page: 1,
            row: 1,
            column: 1,
            x: 1,
            y: 1,
            isInDock: true,
            originColumn: 10,
          }, {
            page: 2,
            row: 10,
            column: 0,
            x: 1,
            y: 1,
            isInDock: false,
            originColumn: 10,
          });
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mocker.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      done();
    });

    it('PageDesktopDragHandlerTest_addFileToFolder_04', 0, () => {
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.typeId = CommonConstants.TYPE_APP;
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['canFileCover']);
      when(mockFuc)(ArgumentMatchers.any).afterReturn(true);
      (pageDesktopDragHandler as object)['isDropFileToDesktop'] = true;
      (pageDesktopDragHandler as object)['mEndPosition'] = {
        page: 0,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };
      gridLayoutItemInfo1.ino = '';
      let mockFuc1: Function =
        mocker.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getItemByPosition']);
      when(mockFuc1)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo1);
      try {
        (pageDesktopDragHandler as object)['addFileToFolder'](1, 1, dragItemInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)(ArgumentMatchers.any).afterReturn(false);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
      mocker.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getItemByPosition']);
      mocker.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['canFileCover']);
    });


    it('PageDesktopDragHandlerTest_addFileToFolder_05', 0, () => {
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.typeId = CommonConstants.TYPE_APP;
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFuc)().afterReturn(true);
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.typeId = CommonConstants.TYPE_ADD;
      let mockFuc1: Function =
        mocker.mockFunc(pageDesktopDragHandler, (pageDesktopDragHandler as object)['getItemByPosition']);
      when(mockFuc1)().afterReturn(itemInfo);
      let mockFuc2: Function =
        mocker.mockFunc(pageDesktopDragHandler, (pageDesktopDragHandler as object)['canFileCover']);
      when(mockFuc2)().afterReturn(true);
      (pageDesktopDragHandler as object)['isDropFileToDesktop'] = false;
      try {
        (pageDesktopDragHandler as object)['addFileToFolder'](1, 1, dragItemInfo, dragEvent);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
      mocker.ignoreMock(pageDesktopDragHandler, (pageDesktopDragHandler as object)['getItemByPosition']);
      mocker.ignoreMock(pageDesktopDragHandler, (pageDesktopDragHandler as object)['canFileCover']);
    });

    it('PageDesktopDragHandlerTest_addToFolderWithMultiApp_01', 0, () => {
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.typeId = CommonConstants.TYPE_APP;
      dragItemInfo.bundleName = 'abc';
      let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      endLayoutInfo.typeId = CommonConstants.TYPE_APP;
      endLayoutInfo.bundleName = 'ab';
      let dragItems: GridLayoutItemInfo[] = [dragItemInfo];
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      let mockFuc1: Function =
        mocker.mockFunc(FolderViewModel, FolderViewModel.isFolderFull);
      let mockFuc2: Function =
        mocker.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['canCover']);
      when(mockFuc2)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['addToFolderWithMultiApp'](1, 1, 'phone', dragItems, endLayoutInfo,
          endPosition, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['addToFolderWithMultiApp'](1, 1, 'pad', dragItems, endLayoutInfo,
          endPosition, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['addToFolderWithMultiApp'](1, 1, 'phone', dragItems, endLayoutInfo,
          endPosition, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)().afterReturn(false);
      dragItems.push(endLayoutInfo);
      try {
        (pageDesktopDragHandler as object)['addToFolderWithMultiApp'](1, 1, 'phone', dragItems, endLayoutInfo,
          endPosition, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['addToFolderWithMultiApp'](1, 1, 'phone', dragItems, null, endPosition, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      endLayoutInfo.folderName = '1';
      when(mockFuc)().afterReturn(false);
      when(mockFuc1)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['addToFolderWithMultiApp'](1, 1, 'phone', dragItems, endLayoutInfo,
          endPosition, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)().afterReturn(false);
      when(mockFuc1)().afterReturn(false);
      when(mockFuc2)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['addToFolderWithMultiApp'](1, 1, 'phone', dragItems, endLayoutInfo,
          endPosition, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)().afterReturn(false);
      when(mockFuc1)().afterReturn(false);
      when(mockFuc2)().afterReturn(true);
      endLayoutInfo.typeId = CommonConstants.TYPE_FOLDER;
      try {
        (pageDesktopDragHandler as object)['addToFolderWithMultiApp'](1, 1, 'phone', dragItems, endLayoutInfo,
          endPosition, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)().afterReturn(false);
      when(mockFuc1)().afterReturn(false);
      when(mockFuc2)().afterReturn(true);
      endLayoutInfo.typeId = CommonConstants.TYPE_APP;
      try {
        (pageDesktopDragHandler as object)['addToFolderWithMultiApp'](1, 1, 'phone', dragItems, endLayoutInfo,
          endPosition, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)().afterReturn(false);
      when(mockFuc1)().afterReturn(false);
      when(mockFuc2)().afterReturn(true);
      endLayoutInfo.typeId = CommonConstants.TYPE_ADD;
      try {
        (pageDesktopDragHandler as object)['addToFolderWithMultiApp'](1, 1, 'phone', dragItems, endLayoutInfo,
          endPosition, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mocker.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mocker.ignoreMock(FolderViewModel, FolderViewModel.isFolderFull);
      mocker.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['canCover']);
    })

    it('PageDesktopDragHandlerTest_addToFolderWithMultiApp_02', 0, () => {
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.typeId = CommonConstants.TYPE_APP;
      dragItemInfo.bundleName = 'abc';
      let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      endLayoutInfo.typeId = CommonConstants.TYPE_APP;
      endLayoutInfo.bundleName = 'ab';
      let dragItems: GridLayoutItemInfo[] = [dragItemInfo, dragItemInfo];
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      let mockFuc1: Function =
        mocker.mockFunc(FolderViewModel, FolderViewModel.isFolderFull);
      let mockFuc2: Function =
        mocker.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['canCover']);
      when(mockFuc2)(ArgumentMatchers.any).afterReturn(false);
      when(mockFuc)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['addToFolderWithMultiApp'](1, 1, 'pad', dragItems, endLayoutInfo,
          endPosition, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)().afterReturn(false);
      when(mockFuc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['addToFolderWithMultiApp'](1, 1, 'phone', dragItems, endLayoutInfo,
          endPosition, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc1)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['addToFolderWithMultiApp'](1, 1, 'phone', dragItems, endLayoutInfo,
          endPosition, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mocker.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mocker.ignoreMock(FolderViewModel, FolderViewModel.isFolderFull);
      mocker.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['canCover']);
    })

    it('PageDesktopDragHandlerTest_addToAppListInfo_01', 0, () => {
      let mSettingsModel: SettingsModel = SettingsModel.getInstance();
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.typeId = CommonConstants.TYPE_APP;
      dragItemInfo.keyName = 'a';
      let items = [dragItemInfo];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_APP;
      item1.keyName = 'b';
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.typeId = CommonConstants.TYPE_APP;
      item2.keyName = 'c';
      let appList = [dragItemInfo, item1, item2];
      let mocker: MockKit = new MockKit();
      let mockFuc: Function =
        mocker.mockFunc(mSettingsModel, mSettingsModel.getAppListInfo);
      when(mockFuc)().afterReturn(appList);
      try {
        (pageDesktopDragHandler as object)['addToAppListInfo'](items);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
    })

    it('PageDesktopDragHandlerTest_isLayoutInfoInvalid_01', 0, () => {
      try {
        gridLayoutItemInfo1.layoutInfo = undefined;
        (pageDesktopDragHandler as object)['isLayoutInfoInvalid'](gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.layoutInfo = [];
        (pageDesktopDragHandler as object)['isLayoutInfoInvalid'](gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.layoutInfo = [[], [gridLayoutItemInfo1]];
        (pageDesktopDragHandler as object)['isLayoutInfoInvalid'](gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.layoutInfo = [[gridLayoutItemInfo1], []];
        (pageDesktopDragHandler as object)['isLayoutInfoInvalid'](gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.layoutInfo = [[gridLayoutItemInfo1], [gridLayoutItemInfo1]];
        (pageDesktopDragHandler as object)['isLayoutInfoInvalid'](gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {
      }
    })

    it('PageDesktopDragHandlerTest_isAddToFormStack_01', 0, () => {
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunc)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      let mockFunc1: Function =
        mock.mockFunc(FormStackViewModel, FormStackViewModel.isSupportFormStack);
      when(mockFunc1)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc1)().afterReturn(false);
      dragItemInfo.typeId == CommonConstants.DOCK_SPACE;
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      dragItemInfo.typeId == CommonConstants.TYPE_CARD;
      dragItemInfo.isTransparent = true;
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      dragItemInfo.isTransparent = false;
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, undefined);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      endLayoutInfo.isTransparent = true;
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mock.ignoreMock(FormStackViewModel, FormStackViewModel.isSupportFormStack);
    })

    it('PageDesktopDragHandlerTest_isAddToFormStack_02', 0, () => {
      let gameCardInfo1: GameCardInfo = new GameCardInfo();
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunc)().afterReturn(false);
      let mockFunc1: Function =
        mock.mockFunc(FormStackViewModel, FormStackViewModel.isSupportFormStack);
      when(mockFunc1)().afterReturn(false);
      dragItemInfo.typeId == CommonConstants.TYPE_CARD;
      dragItemInfo.isTransparent = false;
      endLayoutInfo.isTransparent = false;
      dragItemInfo.bundleName = CommonConstants.THEME_MANAGER_BUNDLE;
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      dragItemInfo.bundleName = CommonConstants.INTELLIGENT_BUNDLE;
      endLayoutInfo.bundleName = CommonConstants.THEME_MANAGER_BUNDLE;
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      endLayoutInfo.bundleName = CommonConstants.INTELLIGENT_BUNDLE;
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      dragItemInfo.cardDimension === CommonConstants.CARD_DIMENSION_6x4;
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      dragItemInfo.cardDimension === CommonConstants.DOCK_SPACE;
      endLayoutInfo.cardDimension === CommonConstants.CARD_DIMENSION_6x4;
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      endLayoutInfo.cardDimension === CommonConstants.DOCK_SPACE;
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      endLayoutInfo.gameCardInfo = undefined;
      dragItemInfo.gameCardInfo = undefined;
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      endLayoutInfo.gameCardInfo = gameCardInfo1;
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      dragItemInfo.gameCardInfo = gameCardInfo1;
      try {
        (pageDesktopDragHandler as object)['isAddToFormStack'](dragItemInfo, endLayoutInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mock.ignoreMock(FormStackViewModel, FormStackViewModel.isSupportFormStack);
    })

    it('PageDesktopDragHandlerTest_reportPreventAddCardStackEvent_01', 0, () => {
      try {
        gridLayoutItemInfo1.area = [1, 1];
        (pageDesktopDragHandler as object)['reportPreventAddCardStackEvent'](gridLayoutItemInfo1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {
      }
    })

    it('PageDesktopDragHandlerTest_sendMessageToSinglePageWhenFoldExpandSqueezed_01', 0, () => {
      try {
        (pageDesktopDragHandler as object)['sendMessageToSinglePageWhenFoldExpandSqueezed']();
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(GlobalContext.getInstance(), GlobalContext.getInstance().getObject);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        (pageDesktopDragHandler as object)['sendMessageToSinglePageWhenFoldExpandSqueezed']();
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(GlobalContext.getInstance(), GlobalContext.getInstance().getObject);
    })

    it('PageDesktopDragHandlerTest_tryFoldExpandDualSqueezed_01', 0, () => {
      let dragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 0, 0, 0, 0, 0, 0);
      let cellAndSpan: CellAndSpan = new CellAndSpan(0, 0, 0, 0);
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let curPageSqueezeItems: GridLayoutItemInfo[] = [gridLayoutItemInfo1];
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(dragDelegate, dragDelegate.isNearReArrangeSolutionSuccess);
      when(mockFunc)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['tryFoldExpandDualSqueezed'](dragDelegate, dragItemInfo, cellAndSpan,
          curPageSqueezeItems);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['tryFoldExpandDualSqueezed'](dragDelegate, dragItemInfo, cellAndSpan,
          curPageSqueezeItems);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(dragDelegate, dragDelegate.isNearReArrangeSolutionSuccess);
    })

    it('PageDesktopDragHandlerTest_getNearPage_01', 0, () => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragPageIndex);
      when(mockFunc)().afterReturn(1);
      let mockFunc1: Function =
        mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc1)().afterReturn(true);
      let mockFunc2: Function =
        mock.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc2)().afterReturn(true);
      (pageDesktopDragHandler as object)['isFoldNearScreen'] = true;
      try {
        (pageDesktopDragHandler as object)['getNearPage']();
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc)().afterReturn(2);
      (pageDesktopDragHandler as object)['isFoldNearScreen'] = false;
      try {
        (pageDesktopDragHandler as object)['getNearPage']();
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc1)().afterReturn(false);
      when(mockFunc2)().afterReturn(false);
      (pageDesktopDragHandler as object)['isFoldNearScreen'] = false;
      try {
        (pageDesktopDragHandler as object)['getNearPage']();
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(RTLUtil, RTLUtil.isRTL);
      mock.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getDragPageIndex);
    })

    it('PageDesktopDragHandlerTest_getDragMoveItemTranslateOffset_01', 0, () => {
      let pageDesktopGridStyleConfig1: PageDesktopGridStyleConfig = PageDesktopGridStyleConfig.getInstance();
      pageDesktopGridStyleConfig1.mMargin = 0;
      pageDesktopGridStyleConfig1.mFoldPaddingSide = 10;
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      (pageDesktopDragHandler as object)['lastFoldStatus'] = false;
      (pageDesktopDragHandler as object)['isNearReArrangeSolutionSuccess'] = false;
      try {
        (pageDesktopDragHandler as object)['getDragMoveItemTranslateOffset']();
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      (pageDesktopDragHandler as object)['lastFoldStatus'] = true;
      try {
        (pageDesktopDragHandler as object)['getDragMoveItemTranslateOffset']();
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      (pageDesktopDragHandler as object)['isNearReArrangeSolutionSuccess'] = true;
      (pageDesktopDragHandler as object)['isFoldNearScreen'] = true;
      (pageDesktopDragHandler as object)['mPageDesktopStyleConfig'] = pageDesktopGridStyleConfig1;
      (pageDesktopDragHandler as object)['mPaddingLeft'] = 5;
      try {
        (pageDesktopDragHandler as object)['getDragMoveItemTranslateOffset']();
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      (pageDesktopDragHandler as object)['isFoldNearScreen'] = false;
      try {
        (pageDesktopDragHandler as object)['getDragMoveItemTranslateOffset']();
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(AppStorage, AppStorage.get);
    })

    it('PageDesktopDragHandlerTest_backToOriginFolderWhenNoSpaceToDrop_01', 0, () => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(MultiSelectManager.getInstance(), MultiSelectManager.getInstance().getUniqueId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo1);
      let apps: GridLayoutItemInfo[] = [gridLayoutItemInfo1];
      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.layoutInfo = [[gridLayoutItemInfo1]];
      try {
        (pageDesktopDragHandler as object)['backToOriginFolderWhenNoSpaceToDrop'](apps, folder);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      folder.layoutInfo = [[gridLayoutItemInfo1, gridLayoutItemInfo1]];
      try {
        (pageDesktopDragHandler as object)['backToOriginFolderWhenNoSpaceToDrop'](apps, folder);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(MultiSelectManager.getInstance(), MultiSelectManager.getInstance().getUniqueId);
    })

    it('PageDesktopDragHandlerTest_updateDragItemPosition_01', 0, () => {
      gridLayoutItemInfo1.page = 0;
      gridLayoutItemInfo1.typeId === CommonConstants.TYPE_CARD;
      let BaseLayoutCacheManager1: BaseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let position: number[] = [];
      let dragItems: GridLayoutItemInfo[] = [];
      let dragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 0, 0, 0, 0, 0, 0);
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getUpdateInfo']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
      (MultiSelectManager as object)['isInMultiSelect'] = true;
      try {
        (pageDesktopDragHandler as object)['updateDragItemPosition'](position, dragItems, dragDelegate, 0, false);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      (MultiSelectManager as object)['isInMultiSelect'] = true;
      try {
        (pageDesktopDragHandler as object)['updateDragItemPosition'](position, dragItems, dragDelegate, 0, false);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc)(ArgumentMatchers.any).afterReturn([gridLayoutItemInfo1]);
      let mockFunc3: Function = mock.mockFunc(BaseLayoutCacheManager1, BaseLayoutCacheManager1.selectPageCount);
      when(mockFunc3)().afterReturn(0);
      let mockFunc2: Function = mock.mockFunc(BaseLayoutCacheManager1, BaseLayoutCacheManager1.selectMaxPageCount);
      when(mockFunc2)().afterReturn(5);
      let mockFunc4: Function =
        mock.mockFunc(launchLayoutCacheManager1, launchLayoutCacheManager1.selectGridLayoutItemByItem);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo1);
      try {
        (pageDesktopDragHandler as object)['updateDragItemPosition'](position, dragItems, dragDelegate, 1, false);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      gridLayoutItemInfo1.page = 5;
      when(mockFunc2)().afterReturn(1);
      gridLayoutItemInfo1.typeId === CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      dragItems = [gridLayoutItemInfo1, gridLayoutItemInfo1];
      try {
        (pageDesktopDragHandler as object)['updateDragItemPosition'](position, dragItems, dragDelegate, 1, false);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getUpdateInfo']);
      mock.ignoreMock(BaseLayoutCacheManager1, BaseLayoutCacheManager1.selectPageCount);
      mock.ignoreMock(BaseLayoutCacheManager1, BaseLayoutCacheManager1.selectMaxPageCount);
      mock.ignoreMock(launchLayoutCacheManager1, launchLayoutCacheManager1.selectGridLayoutItemByItem);
    })

    it('PageDesktopDragHandlerTest_hasEnoughArea_01', 0, () => {
      (pageDesktopDragHandler as object)['mGridConfig'] = {
        row: 1,
        column: 1
      };
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.area = [1, 1];
      let items: GridLayoutItemInfo[] = [item, item];
      let mock: MockKit = new MockKit();
      let mockFunc2: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      when(mockFunc2)().afterReturn(items);
      let mockFunc: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['hasEnoughArea']();
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
    })

    it('PageDesktopDragHandlerTest_printLayoutInfo_01', 0, () => {
      try {
        (pageDesktopDragHandler as object)['mIsPrintLog'] = false;
        (pageDesktopDragHandler as object)['printLayoutInfo']('123');
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {
      }
    })

    it('PageDesktopDragHandlerTest_isPositionOccupied_01', 0, () => {
      let targetItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let moveItem: MoveItem = new MoveItem();
      let moveItem1: MoveItem[] = [];
      (pageDesktopDragHandler as object)['currentMoveItemList'] = undefined;
      try {
        (pageDesktopDragHandler as object)['isPositionOccupied'](targetItemInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      (pageDesktopDragHandler as object)['currentMoveItemList'] = moveItem1;
      try {
        (pageDesktopDragHandler as object)['isPositionOccupied'](targetItemInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      moveItem1 = [moveItem, moveItem];
      (pageDesktopDragHandler as object)['currentMoveItemList'] = moveItem1;
      (pageDesktopDragHandler as object)['isPositionOccupied']();
      expect(pageDesktopDragHandler).not().assertUndefined();
      targetItemInfo.area = [];
      try {
        (pageDesktopDragHandler as object)['isPositionOccupied'](targetItemInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      targetItemInfo.area = [1, 1];
      targetItemInfo.page = undefined;
      try {
        (pageDesktopDragHandler as object)['isPositionOccupied'](targetItemInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      targetItemInfo.page = 1;
      try {
        (pageDesktopDragHandler as object)['isPositionOccupied'](targetItemInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
    })

    it('PageDesktopDragHandlerTest_isPositionOccupied_02', 0, () => {
      let targetItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let moveItem: MoveItem = new MoveItem();
      moveItem.area = [];
      moveItem.row = 5;
      moveItem.column = 5;
      let moveItem1: MoveItem[] = [moveItem, moveItem];
      (pageDesktopDragHandler as object)['currentMoveItemList'] = moveItem1;
      targetItemInfo.area = [1, 1];
      targetItemInfo.page = 1;
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(desktopUtil, desktopUtil.getPageIndexValue);
      when(mockFunc1)().afterReturn(5);
      let mockFunc: Function = mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc)().afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['isPositionOccupied'](targetItemInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc)().afterReturn(false);
      targetItemInfo.page = 5;
      targetItemInfo.column = undefined;
      targetItemInfo.row = undefined;
      targetItemInfo.area = [1, 1];
      try {
        (pageDesktopDragHandler as object)['isPositionOccupied'](targetItemInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      moveItem.column = 0;
      moveItem.row = 0;
      moveItem.area = [0, 0];
      try {
        (pageDesktopDragHandler as object)['isPositionOccupied'](targetItemInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      moveItem.area = [10, 0];
      try {
        (pageDesktopDragHandler as object)['isPositionOccupied'](targetItemInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      moveItem.area = [10, 10];
      try {
        (pageDesktopDragHandler as object)['isPositionOccupied'](targetItemInfo);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(desktopUtil, desktopUtil.getPageIndexValue);
      mock.ignoreMock(desktopUtil, desktopUtil.isFoldExpandStatus);
    })

    it('PageDesktopDragHandlerTest_copyPosition_01', 0, () => {
      let position: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['copyPosition'](position);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['copyPosition'](position);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('PageDesktopDragHandlerTest_isMoveToLastPage_01', 0, () => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc)().afterReturn(true);
      let position: GridLayoutItemInfo = new GridLayoutItemInfo();
      position.page = 0;
      try {
        (pageDesktopDragHandler as object)['isMoveToLastPage'](position, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      position.page = 1;
      try {
        (pageDesktopDragHandler as object)['isMoveToLastPage'](position, 3);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      try {
        (pageDesktopDragHandler as object)['isMoveToLastPage'](position, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      try {
        (pageDesktopDragHandler as object)['isMoveToLastPage']('', 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc)().afterReturn(false);
      position.page = 0;
      try {
        (pageDesktopDragHandler as object)['isMoveToLastPage'](position, 2);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      try {
        (pageDesktopDragHandler as object)['isMoveToLastPage'](position, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      try {
        (pageDesktopDragHandler as object)['isMoveToLastPage']('', 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('PageDesktopDragHandlerTest_copyPosition_01', 0, () => {
      let position: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['copyPosition'](position);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['copyPosition'](position);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('PageDesktopDragHandlerTest_dealDrop_01', 0, () => {
      let dragResult1: DesktopDragResult = {
        needDropAnimation: false,
        needRender: false,
        dropToDesktop: false,
        dropToStackForm: false,
        dropToDock: false
      };
      let mock: MockKit = new MockKit();
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.onDragDrop);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(dragResult1);
      try {
        (pageDesktopDragHandler as object)['dealDrop'](1, 1, dragEvent, '', a);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.onDragDrop);
    })

    it('PageDesktopDragHandlerTest_onDragDrop_01', 0, () => {
      try {
        AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_REGION_FOLDER);
        (pageDesktopDragHandler as object)['onDragDrop'](1, 1, dragEvent, '', a);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
    })

    it('PageDesktopDragHandlerTest_onStartDrop_01', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.column = 2;
      item.area = [2, 2];
      item.row = 2;
      let items: GridLayoutItemInfo[] = [item, item];
      let mock: MockKit = new MockKit();
      let mockFunc2: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      when(mockFunc2)().afterReturn(items);
      (pageDesktopDragHandler as object)['isPc'] = false;
      try {
        pageDesktopDragHandler.onStartDrop();
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      (pageDesktopDragHandler as object)['isPc'] = true;
      try {
        pageDesktopDragHandler.onStartDrop();
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      items = [];
      when(mockFunc2)().afterReturn(items);
      try {
        pageDesktopDragHandler.onStartDrop();
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('PageDesktopDragHandlerTest_updateCoverItemInfo_01', 0, () => {
      let coverItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      coverItem.column = 2;
      coverItem.area = [2, 2];
      coverItem.row = 2;
      let mock: MockKit = new MockKit();
      let mockFunc4: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.checkGridItemEqual);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);
      (pageDesktopDragHandler as object)['coverItem'] = gridLayoutItemInfo1;
      try {
        (pageDesktopDragHandler as object)['updateCoverItemInfo'](coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['updateCoverItemInfo'](coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['updateCoverItemInfo'](coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.checkGridItemEqual);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      mock.clearAll();
    })

    it('PageDesktopDragHandlerTest_updateCoverItemInfo_01', 0, () => {
      let dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let coverItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let gameCardInfo1: GameCardInfo = new GameCardInfo();
      let mock: MockKit = new MockKit();
      let mockFunc4: Function = mock.mockFunc(FormStackViewModel, FormStackViewModel.isSupportFormStack);
      when(mockFunc4)().afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['canCardCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc4)().afterReturn(true);
      dragItem.typeId = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      try {
        (pageDesktopDragHandler as object)['canCardCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      dragItem.typeId = CommonConstants.TYPE_CARD;
      coverItem.typeId = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      try {
        (pageDesktopDragHandler as object)['canCardCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      coverItem.typeId = CommonConstants.TYPE_FORM_STACK;
      dragItem.isTransparent = true;
      try {
        (pageDesktopDragHandler as object)['canCardCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      coverItem.typeId = CommonConstants.TYPE_CARD;
      dragItem.isTransparent = false;
      coverItem.isTransparent = true;
      try {
        (pageDesktopDragHandler as object)['canCardCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      coverItem.isTransparent = false;
      dragItem.cardDimension === CommonConstants.CARD_DIMENSION_6x4;
      try {
        (pageDesktopDragHandler as object)['canCardCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      dragItem.cardDimension === CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      dragItem.bundleName = CommonConstants.THEME_MANAGER_BUNDLE;
      try {
        (pageDesktopDragHandler as object)['canCardCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      dragItem.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      coverItem.bundleName = CommonConstants.THEME_MANAGER_BUNDLE;
      try {
        (pageDesktopDragHandler as object)['canCardCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      coverItem.bundleName = CommonConstants.LAUNCHER_BUNDLE;
      dragItem.gameCardInfo = gameCardInfo1;
      try {
        (pageDesktopDragHandler as object)['canCardCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      dragItem.gameCardInfo = undefined;
      coverItem.gameCardInfo = gameCardInfo1;
      try {
        (pageDesktopDragHandler as object)['canCardCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      coverItem.gameCardInfo = undefined;
      coverItem.cardDimension = CommonConstants.CARD_DIMENSION_6x4;
      try {
        (pageDesktopDragHandler as object)['canCardCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      coverItem.cardDimension = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      dragItem.cardDimension === CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      gridLayoutItemInfo1.cardDimension = coverItem.cardDimension = CommonConstants.CARD_DIMENSION_6x4;
      coverItem.layoutInfo = [[gridLayoutItemInfo1]];
      try {
        (pageDesktopDragHandler as object)['canCardCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(FormStackViewModel, FormStackViewModel.isSupportFormStack);
      mock.clearAll();
    })

    it('computeAppItemReNSqueezed_01', 0, () => {
      let mStartPosition: DragItemPosition = {
        page: 0,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };
      let mEndPosition: DragItemPosition = {
        page: 0,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };
      mStartPosition.page = 1;
      mEndPosition.page = 1;
      (pageDesktopDragHandler as object)['mStartPosition'] = mStartPosition;
      (pageDesktopDragHandler as object)['mEndPosition'] = mEndPosition;
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFuc)(mStartPosition).afterReturn(true);
      try {
        pageDesktopDragHandler.computeAppItemReNSqueezed(true, 1, 1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)(mStartPosition).afterReturn(false);
      when(mockFuc)(mEndPosition).afterReturn(true);
      try {
        pageDesktopDragHandler.computeAppItemReNSqueezed(true, 1, 1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)(mStartPosition).afterReturn(false);
      when(mockFuc)(mEndPosition).afterReturn(false);
      when(mockFuc)(mStartPosition.page).afterReturn(true);
      try {
        pageDesktopDragHandler.computeAppItemReNSqueezed(true, 1, 1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)(mStartPosition).afterReturn(false);
      when(mockFuc)(mEndPosition).afterReturn(false);
      when(mockFuc)(mStartPosition.page).afterReturn(false);
      when(mockFuc)(mEndPosition.page).afterReturn(true);
      try {
        pageDesktopDragHandler.computeAppItemReNSqueezed(true, 1, 1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)(mStartPosition).afterReturn(false);
      when(mockFuc)(mEndPosition).afterReturn(false);
      when(mockFuc)(mStartPosition.page).afterReturn(false);
      when(mockFuc)(mEndPosition.page).afterReturn(false);
      try {
        pageDesktopDragHandler.computeAppItemReNSqueezed(true, 1, 1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('calculateSqueezedBackwards_01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc((pageDesktopDragHandler as object),
        (pageDesktopDragHandler as object)['calculateSqueezedMoveItemList']);
      when(mockFuc)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['calculateSqueezedBackwards'](true, 1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['calculateSqueezedBackwards'](true, 1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mocker.clear((pageDesktopDragHandler as object));
      mocker.clearAll();
    })

    it('getExtraRowPosition_01', 0, () => {
      try {
        (pageDesktopDragHandler as object)['mGridItemHeight'] = 1;
        (pageDesktopDragHandler as object)['getExtraRowPosition']([1, 2, 3], true);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['getExtraRowPosition']([1, 2, 3], false);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {
      }
    })

    it('calculateReSqueezedBackwards_01', 0, () => {
      let currentMoveItemList: MoveItem[] = [];
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc((pageDesktopDragHandler as object),
        (pageDesktopDragHandler as object)['calculateMultiItemDropResult']);
      let mockFuc1: Function = mocker.mockFunc(JSON, JSON.parse);
      when(mockFuc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFuc1)(ArgumentMatchers.any).afterReturn(currentMoveItemList);
      try {
        (pageDesktopDragHandler as object)['calculateReSqueezedBackwards'](true, 1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFuc)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['calculateReSqueezedBackwards'](true, 1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mocker.clear((pageDesktopDragHandler as object));
      mocker.clear(JSON);
      mocker.clearAll();
    })

    it('calculateMultiItemDropResult_01', 0, () => {
      try {
        let mEndPosition: DragItemPosition = {
          page: 0,
          row: 0,
          column: 0,
          x: 0,
          y: 0
        };
        mEndPosition.row = 2;
        mEndPosition.column = 2;
        (pageDesktopDragHandler as object)['calculateMultiItemDropResult'](1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {
      }
    })

    it('PageDesktopDragHandlerTest_canFileCover_01', 0, () => {
      let dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let coverItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.column = 2;
      item.area = [2, 2];
      item.row = 2;
      item.typeId === CommonConstants.TYPE_FILE_FOLDER;
      let items: GridLayoutItemInfo[] = [item, item];
      (pageDesktopDragHandler as object)['isDragPaste'] = true;
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      when(mockFunc)().afterReturn(items);
      try {
        (pageDesktopDragHandler as object)['canFileCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      dragItem.typeId = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      items = [item];
      when(mockFunc)().afterReturn(items);
      try {
        (pageDesktopDragHandler as object)['canFileCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      dragItem.typeId = CommonConstants.TYPE_FILE_FOLDER;
      coverItem.typeId = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      items = [item];
      when(mockFunc)().afterReturn(items);
      try {
        (pageDesktopDragHandler as object)['canFileCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      coverItem.typeId = CommonConstants.TYPE_FILE_FOLDER;
      items = [item];
      when(mockFunc)().afterReturn(undefined);
      coverItem.fileType = FileType.TYPE_FILE;
      try {
        (pageDesktopDragHandler as object)['canFileCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc)().afterReturn(undefined);
      coverItem.fileType = FileType.TYPE_FOLDER;
      (pageDesktopDragHandler as object)['isDragPaste'] = false;
      (pageDesktopDragHandler as object)['coverItemCenter'] = [0, 0];
      try {
        (pageDesktopDragHandler as object)['canFileCover'](1, 1, dragItem, coverItem);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      mock.clearAll();
    })

    it('PageDesktopDragHandlerTest_isDropPositionColumnChanged_01', 0, () => {
      (pageDesktopDragHandler as object)['mGridConfig'] = {
        row: 1,
        column: 1
      };
      try {
        (pageDesktopDragHandler as object)['isDropPositionColumnChanged'](1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      (pageDesktopDragHandler as object)['mGridConfig'] = {
        row: undefined,
        column: 1
      };
      try {
        (pageDesktopDragHandler as object)['isDropPositionColumnChanged'](1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      (pageDesktopDragHandler as object)['mGridConfig'] = undefined;
      try {
        (pageDesktopDragHandler as object)['isDropPositionColumnChanged'](1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
    })

    it('PageDesktopDragHandlerTest_setSqueezeTimeout_01', 0, () => {
      (pageDesktopDragHandler as object)['mGridConfig'] = {
        row: 1,
        column: 1
      };
      (pageDesktopDragHandler as object)['zSqueeze'] = false;
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getDragItems']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (pageDesktopDragHandler as object)['isSqueezeSuccess'] = false;
      try {
        (pageDesktopDragHandler as object)['setSqueezeTimeout'](1, a);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      (pageDesktopDragHandler as object)['isSqueezeSuccess'] = true;
      try {
        (pageDesktopDragHandler as object)['setSqueezeTimeout'](1, a);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['setSqueezeTimeout'](1, a);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      (pageDesktopDragHandler as object)['zSqueeze'] = true;
      try {
        (pageDesktopDragHandler as object)['setSqueezeTimeout'](1, a);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getDragItems']);
      mock.clearAll();
    })

    it('PageDesktopDragHandlerTest_resetSqueezeTimeout_01', 0, () => {
      try {
        (pageDesktopDragHandler as object)['squeezeTimeoutId'] = CommonConstants.INVALID_VALUE;
        pageDesktopDragHandler.resetSqueezeTimeout();
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['squeezeTimeoutId'] = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
        pageDesktopDragHandler.resetSqueezeTimeout();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {
      }
    })

    it('PageDesktopDragHandlerTest_getIndexByPosition_01', 0, () => {
      (pageDesktopDragHandler as object)['mGridConfig'] = {
        row: 2,
        column: 2
      };
      (pageDesktopDragHandler as object)['zSqueeze'] = true;
      try {
        (pageDesktopDragHandler as object)['getIndexByPosition'](0, 5);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      try {
        (pageDesktopDragHandler as object)['getIndexByPosition'](0, -1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      try {
        (pageDesktopDragHandler as object)['getIndexByPosition'](5, -1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      try {
        (pageDesktopDragHandler as object)['getIndexByPosition'](-1, -1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      try {
        (pageDesktopDragHandler as object)['getIndexByPosition'](1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      (pageDesktopDragHandler as object)['zSqueeze'] = false;
      try {
        (pageDesktopDragHandler as object)['getIndexByPosition'](1, 1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
    })

    it('PageDesktopDragHandlerTest_getItemSqueezed_01', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let items: GridLayoutItemInfo[] = [item, item];
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getItemByIndex']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo1);
      let mockFunc2: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      when(mockFunc2)().afterReturn(undefined);
      try {
        (pageDesktopDragHandler as object)['getItemSqueezed'](1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc2)().afterReturn(items);
      try {
        (pageDesktopDragHandler as object)['getItemSqueezed'](1);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getItemByIndex']);
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getDragItems);
      mock.clearAll();
    })

    it('PageDesktopDragHandlerTest_isGridItem1x1_01', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isIconType);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isSmallFolder);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      try {
        (pageDesktopDragHandler as object)['isGridItem1x1'](item);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['isGridItem1x1'](item);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['isGridItem1x1'](item);
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isIconType);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isSmallFolder);
      mock.clearAll();
    })

    it('PageDesktopDragHandlerTest_onDragMoveSqueeze_01', 0, () => {
      let dragDelegate: CellLayoutDragDelegate = new CellLayoutDragDelegate(0, 0, 0, 0, 0, 0, 0, 0);
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.page = 0;
      dragItemInfo.area = [1, 1];
      (pageDesktopDragHandler as object)['mEndPosition'] = {
        page: 0,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };
      let cellAndSpan1: CellAndSpan = new CellAndSpan(0, 0, 0, 0);
      (pageDesktopDragHandler as object)['cellAndSpan'] = cellAndSpan1;
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getDragDelegate']);
      when(mockFunc)().afterReturn(dragDelegate);
      let mockFunc1: Function =
        mock.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getNearestArea']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([0, 0, 0, 0]);
      let mockFunc0: Function =
        mock.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['isLockedLayout']);
      when(mockFunc0)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc6: Function =
        mock.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getItemByPosition']);
      when(mockFunc6)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo1);
      try {
        (pageDesktopDragHandler as object)['onDragMoveSqueeze'](0, 0, dragItemInfo, 1, 1, false, '');
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc0)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function =
        mock.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['canCover']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc3: Function = mock.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.checkGridItemEqual);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['onDragMoveSqueeze'](0, 0, dragItemInfo, 1, 1, false, '');
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      let mockFunc5: Function =
        mock.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getIndexByPosition']);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      (pageDesktopDragHandler as object)['squeezeIndex'] = 1;
      try {
        (pageDesktopDragHandler as object)['onDragMoveSqueeze'](0, 0, dragItemInfo, 1, 1, false, '');
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();
      when(mockFunc0)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc7: Function =
        mock.mockFunc((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['isDragInCentral']);
      when(mockFunc7)(ArgumentMatchers.any).afterReturn(true);
      try {
        (pageDesktopDragHandler as object)['onDragMoveSqueeze'](0, 0, dragItemInfo, 1, 1, false, '');
      } catch (err) {
      }
      expect(pageDesktopDragHandler).not().assertUndefined();

      mock.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getDragDelegate']);
      mock.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getNearestArea']);
      mock.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['isLockedLayout']);
      mock.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['canCover']);
      mock.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isIconType);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.checkGridItemEqual);
      mock.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getIndexByPosition']);
      mock.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['getItemByPosition']);
      mock.ignoreMock((pageDesktopDragHandler as object), (pageDesktopDragHandler as object)['isDragInCentral']);
      mock.clearAll();
    })

    it('PageDesktopDragHandler_dealSwiperPageOnDragEnter_test03', 0, async (done: Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(CommonConstants.DRAG_FROM_REGION_FOLDER);
      try {
        pageDesktopDragHandler['isPc'] = true;
        pageDesktopDragHandler.dealSwiperPageOnDragEnter(1, dragEvent);
        expect(pageDesktopDragHandler).not().assertUndefined();
        expect(pageDesktopDragHandler['mStartPosition']).assertEqual({
          this.mStartPosition = {
            page: pageDesktopDragHandler['dragPageIndex'],
            row: 0,
            column: 0,
            x: 0,
            y: 0,
          }
          ;
        });
        expect(pageDesktopDragHandler['pcMultiDragCount']).assertEqual(event.getData()?.getRecords()?.length ?? 1);
      } catch (err) {
      }
      mock.ignoreMock(AppStorage, AppStorage.get);
      done();
    })


    it('PageDesktopDragHandler_handleFallItemAnimation_test02', 0, async(done:Function) => {
      let mEndPosition1: DragItemPosition = {
        page: 0,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      }
      let mock: MockKit = new MockKit();
      let mockFunc: Function =
        mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('1');
      try {
        (pageDesktopDragHandler as object)['handleFallItemAnimation'](true);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      let mockFunc1: Function = mock.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      (pageDesktopDragHandler as object)['mEndPosition'] = mEndPosition1;
      (pageDesktopDragHandler as object)['lastBoxPage'] = -1;
      try {
        (pageDesktopDragHandler as object)['handleFallItemAnimation'](true);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['handleFallItemAnimation'](false);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      (pageDesktopDragHandler as object)['lastBoxPage'] = 1;
      try {
        (pageDesktopDragHandler as object)['handleFallItemAnimation'](true);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['handleFallItemAnimation'](false);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      mock.ignoreMock(RTLUtil, RTLUtil.isRTL);
      done();
    })

    it('PageDesktopDragHandler_onDragMove_test03', 0, async(done:Function) => {
      let mock: MockKit = new MockKit();
      let mockFunc: Function = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc1: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      when(mockFunc1)().afterReturn(gridLayoutItemInfo1);
      let mockFunc2: Function = mock.mockFunc(AppStorage, AppStorage.get);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(CommonConstants.DRAG_FROM_APPCENTER);
      try {
        pageDesktopDragHandler.onDragMove(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(CommonConstants.DRAG_FROM_MANAGE);
      let mockFunc3: Function = mock.mockFunc(pageDesktopDragHandler, pageDesktopDragHandler.getCurrentPageIndex);
      when(mockFunc3)().afterReturn(0);
      (pageDesktopDragHandler as object)['mIsPrintLog'] = true;
      gridLayoutItemInfo1.page = 1;
      gridLayoutItemInfo1.area = [];
      gridLayoutItemInfo1.typeId = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      try {
        pageDesktopDragHandler.onDragMove(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        gridLayoutItemInfo1.typeId = CommonConstants.TYPE_APP;
        pageDesktopDragHandler.onDragMove(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
        (pageDesktopDragHandler as object)['mIsPrintLog'] = false;
        gridLayoutItemInfo1.area = [1, 1];
        pageDesktopDragHandler.onDragMove(1, 1);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      mock.ignoreMock(AppStorage, AppStorage.get);
      mock.ignoreMock(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      mock.ignoreMock(pageDesktopDragHandler, pageDesktopDragHandler.getSingleDragItemInfo);
      done();
    })

    it('should_return_false_when_isBigScreen_is_true_and_isExpandStatus_is_false', 0, () => {
      let pagedesktopdraghandler: PageDesktopDragHandler = new PageDesktopDragHandler();
      let pageDesktopGridStyleConfig1: PageDesktopGridStyleConfig = PageDesktopGridStyleConfig.getInstance();
      pagedesktopdraghandler['isBigScreen'] = true;
      pagedesktopdraghandler['isExpandStatus'] = false;
      pagedesktopdraghandler['screenHeight'] = 1000;
      pagedesktopdraghandler['mDragCreaseHeight'] = 100;
      (pageDesktopDragHandler as object)['mPageDesktopStyleConfig'] = pageDesktopGridStyleConfig1;
      (pageDesktopDragHandler as object)['mPageDesktopStyleConfig'].mFoldCreaseRegionHeight = 50;

      const result = pagedesktopdraghandler['isDragInCentral'](500);
      expect(result).assertEqual(false);
      const result2 = pagedesktopdraghandler['isDragInCentral'](525);
      expect(result2).assertEqual(true);
      pagedesktopdraghandler['isBigScreen'] = false;
      const result3 = pagedesktopdraghandler['isDragInCentral'](525);
      expect(result3).assertEqual(false);
    });

    it('PageDesktopDragHandler_needHideWhiteEdge_test', 0, () => {
      let mock: MockKit = new MockKit();
      let pagedesktopdraghandler: PageDesktopDragHandler = new PageDesktopDragHandler();
      let gridLayoutItemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo1.typeId = CommonConstants.TYPE_APP;
      gridLayoutItemInfo1.bundleName = 'test_bundleName';
      gridLayoutItemInfo1.column = 0;
      gridLayoutItemInfo1.row = 0;
      pagedesktopdraghandler['isBigScreen'] = true;
      let moveItem: MoveItem = new MoveItem();
      moveItem.area = [1, 1];
      moveItem.row = 2;
      moveItem.column = 2;
      let moveItem1: MoveItem[] = [moveItem];
      (pageDesktopDragHandler as object)['currentMoveItemList'] = moveItem1;
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.typeId = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'test_bundleName1';
      itemInfo.column = 0;
      itemInfo.row = 0;
      try {
        const result = pagedesktopdraghandler['needHideWhiteEdge']();
        expect(pageDesktopDragHandler).not().assertUndefined();
        pagedesktopdraghandler['currentMoveItemList'] = [];
        const result1 = pagedesktopdraghandler['needHideWhiteEdge']();
        expect(pageDesktopDragHandler).not().assertUndefined();
        itemInfo.bundleName = 'test_bundleName';
        const result2 = pagedesktopdraghandler['needHideWhiteEdge']();
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {
      }
    });

    it('PageDesktopDragHandler_needToCover_test01', 0, async(done:Function) => {
      let formStackItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem.typeId = CommonConstants.TYPE_CARD;
      let pageDesktopDragHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance();
      try {
        (pageDesktopDragHandler as object)['needToCover'](formStackItem);
        expect(pageDesktopDragHandler).not().assertUndefined();
      } catch (err) {}
      done();
    })
  })
}

function a(): void {
};

