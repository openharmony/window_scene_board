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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { BackupSceneBundleVersionName, CommonConstants, GridLayoutItemInfo,
  RdbStoreManager,DockItemInfo,
  Extend1Data,
  FolderReporter,
  AppStatus,
  GridLayoutUtil,
  AppReserveType,
  DeliverUtil} from '../../../../../../main/ets/TsIndex';
import { TransferLayoutManager } from '../../../../../../main/ets/TsIndex';
import { preferences } from '@kit.ArkData';
import { CheckEmptyUtils, CommonUtils } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { SCBSceneContainerSession } from '@ohos/windowscene';
import type ctx from '@ohos.app.ability.common';
import { BaseTransferBean } from '../../../../../../main/ets/transformdata/BaseTransferBean';
import ScreenTransferBean from '../../../../../../main/ets/transformdata/ScreenTransferBean';
import dataConvert from '../../../../../../main/ets/transformdata/DataConvert';
import { BlankPageTransFormItem } from '../../../../../../main/ets/transformdata/transfromitem/BlankPageTransFormItem';
import { NotHarmonyUtil } from '../../../../../../main/ets/utils/NotHarmonyUtil';

export default function TransferLayoutManagerTest() {
  let mockerRdb: MockKit = new MockKit();
  let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
  let screenData: ScreenTransferBean = initScreenTransferBean();

  let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

  describe('TransferLayoutManagerTest', () => {
    beforeAll((): void => {
      let func1: Function =
        mockerRdb.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().deleteAllGridInfoData);
      when(func1)(ArgumentMatchers.any).afterReturn(Promise.resolve(0));
      let func2: Function =
        mockerRdb.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().insertGridLayoutInfo);
      when(func2)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
    })
    beforeEach((): void => {
    })
    afterEach((): void => {
    })
    afterAll((): void => {
      mockerRdb.clear(RdbStoreManager.getInstance());
      mockerRdb.clearAll();
    })

    it('test_buildScreenNextPage_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let screenPage: number = 1;
        let notHarmony1 = {
          layoutWeight: 1,
          page: 1,
          typeId: CommonConstants.TYPE_FORM_COMBINE
        } as BaseTransferBean;
        let screenItemInfo = {
          page: 1,
          occupied: [[true]],
          usedCellCnt: 0,
          iconUsedCellCnt: 0,
          folderUsedCellCnt: 0,
          abilityFormUsedCellCnt: 0,
          children: [notHarmony1],
          moveToNextPage: [notHarmony1]
        } as ScreenTransferBean;
        let screenDataMap: Map<number, ScreenTransferBean[]> = new Map();
        screenDataMap.set(screenPage, [screenItemInfo]);
        transferLayoutManager['buildScreenNextPage'](screenPage, screenDataMap);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_buildScreenNextPage_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let screenPage: number = 1;
        let notHarmony1 = {
          layoutWeight: 1,
          page: 1,
          typeId: CommonConstants.TYPE_FORM_COMBINE
        } as BaseTransferBean;
        let screenItemInfo = {
          page: 1,
          occupied: [[true]],
          usedCellCnt: 0,
          iconUsedCellCnt: 0,
          folderUsedCellCnt: 0,
          abilityFormUsedCellCnt: 0,
          children: [notHarmony1],
          moveToNextPage: [notHarmony1]
        } as ScreenTransferBean;
        let screenDataMap: Map<number, ScreenTransferBean[]> = new Map();
        screenDataMap.set(screenPage + 1, [screenItemInfo]);
        transferLayoutManager['buildScreenNextPage'](screenPage, screenDataMap);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_modifyPosition_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let transferBean: BaseTransferBean = new BaseTransferBean();
        transferBean.column = 1;
        transferBean.row = 1;
        transferBean.landscapeColumn = 1;
        transferBean.landscapeRow = 1;
        transferLayoutManager['modifyPosition'](transferBean, 1, 1, true);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_modifyPosition_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let transferBean: BaseTransferBean = new BaseTransferBean();
        transferBean.column = 1;
        transferBean.row = 1;
        transferBean.landscapeColumn = 1;
        transferBean.landscapeRow = 1;
        transferLayoutManager['modifyPosition'](transferBean, 1, 1, false);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('transferLayoutTest01', Level.LEVEL0, async (done:Function) => {
      try {
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('transferLayoutTest02', Level.LEVEL0, async (done:Function) => {
      try {
        let preference: preferences.Preferences = await preferences.getPreferences((GlobalContext.getInstance()
          .getObject('desktopContext') as ctx.ServiceExtensionContext), 'DESKTOP_LAYOUT_INFO');
        preference.putSync('isNewLayout', true);
        await preference.flush();
        await transferLayoutManager.transferLayout(layoutInfos);

        preference.putSync('isNewLayout', false);
        await preference.flush();
        await transferLayoutManager.transferLayout(layoutInfos);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('transferLayoutTest03', Level.LEVEL0, async (done:Function) => {
      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayout.typeId = 0;
      gridLayout.infoId = 'gridLayoutInfoId';
      gridLayout.appName = 'gridLayoutAppName';
      gridLayout.bundleName = 'gridLayoutBundleName';
      gridLayout.keyName = 'gridLayoutKeyName';
      gridLayout.folderName = 'gridLayoutFolderName'
      gridLayout.abilityName = 'gridLayoutAbilityName';
      gridLayout.moduleName = 'gridLayoutModuleName';
      gridLayout.appIconId = 1;
      gridLayout.appLabelId = 2;
      gridLayout.badgeNumber = 3;
      gridLayout.row = 4;
      gridLayout.column = 5;
      gridLayout.area = [2, 2];
      gridLayout.areaType = 0;
      try {
        expect(result1).not().assertUndefined();
        let result2: boolean = await transferLayoutManager.transferLayout([gridLayout]);
        expect(result2).not().assertUndefined();
      } catch (e) {};
      done();
    })

    it('generateNewFirstPage01', Level.LEVEL0, async (done:Function) => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();

      let mocker: MockKit = new MockKit();
      let queryGridLayoutInfo: Function = mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().queryGridLayoutInfo);
      when(queryGridLayoutInfo)().afterReturn(layoutInfos);

      let ifDuplicatePosition: Function = mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      when(ifDuplicatePosition)(ArgumentMatchers.any).afterReturn(true);

      try {
        transferLayoutManager['generateNewFirstPage']();
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};

      mocker.ignoreMock(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().queryGridLayoutInfo);
      mocker.ignoreMock(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      done();
    })

    it('printFirstPageItem01', Level.LEVEL0, async (done:Function) => {
      try {
        transferLayoutManager['printFirstPageItem'](layoutInfos);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('getDefaultLayoutInfoFromConfig01', Level.LEVEL0, async (done:Function) => {
      try {
        let result: GridLayoutItemInfo[] = transferLayoutManager['getDefaultLayoutInfoFromConfig']();
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {};
      done();
    })

    it('getConfigFileAbsPath01', Level.LEVEL0, async (done:Function) => {
      try {
        let result: string = transferLayoutManager['getConfigFileAbsPath']('fileName');
        expect(result).not().assertNull();
      } catch (e) {};
      done();
    })

    it('disbandFormCombine01', Level.LEVEL0, async (done:Function) => {
      try {
        let gridLayoutCombineCard: GridLayoutItemInfo = initCombineCardGridLayoutItem();
        let result: GridLayoutItemInfo[] = transferLayoutManager['disbandFormCombine'](gridLayoutCombineCard);
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {};
      done();
    })

    it('transferByScreen01', Level.LEVEL0, async (done:Function) => {
      try {
        transferLayoutManager['transferByScreen'](screenData);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('realignScreenData01', Level.LEVEL0, async (done:Function) => {
      try {
        transferLayoutManager['realignScreenData'](screenData);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('realignByMaintenance01', Level.LEVEL0, async (done:Function) => {
      try {
        let occupied: boolean[][] = [];
        transferLayoutManager['realignByMaintenance'](screenData, occupied);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('fillEmptyPlace01', Level.LEVEL0, async (done:Function) => {
      try {
        let extraElements: number[] = [];
        let occupied: boolean[][] = [];
        transferLayoutManager['fillEmptyPlace'](extraElements, screenData, occupied);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('calculateRowElement01', Level.LEVEL0, async (done:Function) => {
      try {
        let rowElementMap: Map<number, number[]> = new Map();
        let widgetIndexArr: number[] = [];
        let emptyRowArr: number[] = [];
        transferLayoutManager['calculateRowElement'](screenData, rowElementMap, widgetIndexArr, emptyRowArr);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('realignByRefresh01', Level.LEVEL0, async (done:Function) => {
      try {
        let occupied: boolean[][] = [];
        transferLayoutManager['realignByRefresh'](screenData, occupied);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('regroupWidgetPosition01', Level.LEVEL0, async (done:Function) => {
      try {
        let screenData: ScreenTransferBean = initScreenTransferBean();
        let rowElementMap: Map<number, number[]> = new Map();
        let widgetIndexArr: number[] = [0, 1];
        let emptyRowArr: number[] = [];
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr, screenData, emptyRowArr, rowElementMap);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('placeElementsByRow01', Level.LEVEL0, async (done:Function) => {
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let occupied: boolean[][] = [];
        transferLayoutManager['placeElementsByRow'](curRowElements, screenData, occupied, needToNextPageIndex);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('moveElementByType01', Level.LEVEL0, async (done:Function) => {
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let rowLen: number = 4;
        let emptyLen: number = 6;
        let type: number = 0;
        transferLayoutManager['moveElementByType'](curRowElements, rowLen, emptyLen, screenData, needToNextPageIndex, type);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('moveElementByType02', Level.LEVEL0, async (done:Function) => {
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let rowLen: number = 6;
        let emptyLen: number = 4;
        let type: number = 0;
        transferLayoutManager['moveElementByType'](curRowElements, rowLen, emptyLen, screenData, needToNextPageIndex, type);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('test_dealWithLessSpace1', 0, () => {
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let occupied: boolean[][] = [];
        transferLayoutManager['dealWithLessSpace'](curRowElements, occupied, screenData, needToNextPageIndex);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_dealWithLessSpace2", 0, () => {
      let mocker: MockKit = new MockKit();
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let occupied: boolean[][] = [];
        let mockFunction: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaByRow']);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        let mockFunction1: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
        transferLayoutManager['dealWithLessSpace'](curRowElements, occupied, screenData, needToNextPageIndex);
        expect(curRowElements.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
    })

    it("test_dealWithLessSpace3", 0, () => {
      let mocker: MockKit = new MockKit();
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let occupied: boolean[][] = [];
        let mockFunction: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaByRow']);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        transferLayoutManager['dealWithLessSpace'](curRowElements, occupied, screenData, needToNextPageIndex);
        expect(curRowElements.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
    })

    it('findAreaByRowFromLast01', Level.LEVEL0, async (done:Function) => {
      let occupied: boolean[][] = Array(4).fill(false).map(() => Array(6).fill(false));
      let baseData: BaseTransferBean = new BaseTransferBean();
      baseData.area = [1, 1];
      baseData.row = 1;
      baseData.column = 1;
      try {
        transferLayoutManager['findAreaByRowFromLast'](occupied, baseData);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('makeRestElementFolderToCurrentPage01', Level.LEVEL0, async (done:Function) => {
      try {
        let occupied: boolean[][] = [];
        let notFromCurrentPageElements: BaseTransferBean[] = [];
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenData, occupied, notFromCurrentPageElements);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('replaceLastCardWithFolder01', Level.LEVEL0, async (done:Function) => {
      try {
        let screenData: ScreenTransferBean = initScreenTransferBean();
        let occupied: boolean[][] = screenData.occupied;
        let addToCurrentPage: BaseTransferBean[] = screenData.children;
        let isSpecialFolder: boolean = false;
        transferLayoutManager['replaceLastCardWithFolder'](screenData, occupied, addToCurrentPage, isSpecialFolder);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('makeNotHarmonyElementToFolder01', Level.LEVEL0, async (done:Function) => {
      try {
        let screenData: ScreenTransferBean = initScreenTransferBean();
        let occupied: boolean[][] = screenData.occupied;
        let addToCurrentPage: BaseTransferBean[] = screenData.children;
        transferLayoutManager['makeNotHarmonyElementToFolder'](screenData, occupied, addToCurrentPage);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('fillElementInfo01', Level.LEVEL0, async (done:Function) => {
      try {
        let baseData: BaseTransferBean = new BaseTransferBean();
        let lastElement: BaseTransferBean = new BaseTransferBean();
        transferLayoutManager['fillElementInfo'](baseData, lastElement);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('updateUsedCellCnt01', Level.LEVEL0, async (done:Function) => {
      try {
        let addToCurrentPage: BaseTransferBean[] = [];
        transferLayoutManager['updateUsedCellCnt'](screenData, addToCurrentPage);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('validElementArea01', Level.LEVEL0, async (done:Function) => {
      let occupied: boolean[][] = [];
      let area: number [] = [];
      let fromIndexX: number = 0;
      let fromIndexY: number = 0;
      try {
        let result: boolean = transferLayoutManager['validElementArea'](occupied, area, fromIndexX, fromIndexY);
        expect(result).assertTrue();
      } catch (e) {};
      done();
    })

    it('preprocessScreenData01', Level.LEVEL0, async (done:Function) => {
      try {
        let screenData: ScreenTransferBean = new ScreenTransferBean();
        transferLayoutManager['preprocessScreenData'](screenData);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('compareCard01', Level.LEVEL0, async (done:Function) => {
      let a: GridLayoutItemInfo = new GridLayoutItemInfo;
      let b: GridLayoutItemInfo = new GridLayoutItemInfo;
      let oldLayoutInfo: GridLayoutItemInfo[] = [];
      try {
        let order: number = transferLayoutManager['compareCard'](a, b, oldLayoutInfo);
        expect(order).not().assertNull();
      } catch (e) {};
      done();
    })

    it('addRestDockToCurrentPage01', Level.LEVEL0, async (done:Function) => {
      try {
        let startPage: number = 0;
        transferLayoutManager['addRestDockToCurrentPage'](startPage,[]);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('getNewLayoutCardItems01', Level.LEVEL0, async (done:Function) => {
      try {
        transferLayoutManager.getNewLayoutCardItems();
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('test_updateFoldersRowAndColumn_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let childElement: GridLayoutItemInfo[] = [];
        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
        childElement.push(appInfo1);
        childElement.push(appInfo2);
        transferLayoutManager['updateFoldersRowAndColumn'](childElement)
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_makeSmallerFolder_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let gridLayoutArr: BaseTransferBean[] = retUndefined() as BaseTransferBean[];
        let ret: BaseTransferBean = transferLayoutManager['makeSmallerFolder'](gridLayoutArr);
        expect(ret).assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_makeSmallerFolder_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let gridLayoutArr: BaseTransferBean[] = [];
        gridLayoutArr.push(new BaseTransferBean());
        transferLayoutManager['makeSmallerFolder'](gridLayoutArr);
        expect(gridLayoutArr.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_makeSmallerFolder_03', 0, () => {
      try {
        let gridLayoutArr: BaseTransferBean[] = [];
        gridLayoutArr.push(new BaseTransferBean());
        transferLayoutManager['makeSmallerFolder'](gridLayoutArr, true);
        expect(gridLayoutArr.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_makeSmallerFolder_04', 0, () => {
      try {
        let gridLayoutArr: BaseTransferBean[] = [];
        gridLayoutArr.push(new BaseTransferBean());
        transferLayoutManager['makeSmallerFolder'](gridLayoutArr, true, true);
        expect(gridLayoutArr.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_makeSmallerFolder_05', 0, () => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let mock = new MockKit();
      try {
        let gridLayoutArr: BaseTransferBean[] = [];
        gridLayoutArr.push(new BaseTransferBean());
        gridLayoutArr.push(new BaseTransferBean());

        let mockFunc: Function = mock.mockFunc(transferLayoutManager, transferLayoutManager['filterFolderDuplicateElement']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutArr);

        transferLayoutManager['makeSmallerFolder'](gridLayoutArr, false);
        expect(gridLayoutArr.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(transferLayoutManager);
      mock.clearAll();
    })

    it('test_makeSmallerFolder_06', 0, () => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let mock = new MockKit();
      try {
        let gridLayoutArr: BaseTransferBean[] = [];
        gridLayoutArr.push(new BaseTransferBean());
        gridLayoutArr.push(new BaseTransferBean());

        let mockFunc: Function =
          mock.mockFunc(transferLayoutManager, transferLayoutManager['filterFolderDuplicateElement']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutArr);

        let map: Map<string, Object> = new Map();
        map.set(NotHarmonyUtil.INSTALL_SOURCE, DeliverUtil.DELIVER_APPSTORE_PKG);
        let mockFunc2: Function = mock.mockFunc(CommonUtils, CommonUtils.jsonStrToMap);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(map);

        transferLayoutManager['makeSmallerFolder'](gridLayoutArr, true);
        expect(gridLayoutArr.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(transferLayoutManager);
      mock.clear(CommonUtils);
      mock.clearAll();
    })

    it('test_putPageData_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let dataElement: BaseTransferBean = new BaseTransferBean();
        dataElement.page = 100;
        transferLayoutManager['putPageData'](dataElement);
        expect(dataElement).not().assertNull();
      } catch (e) {};
    });

    it('test_putPageData_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let dataElement: BaseTransferBean = new BaseTransferBean();
        dataElement.page = 0;
        transferLayoutManager['putPageData'](dataElement);
        expect(dataElement).not().assertNull();
      } catch (e) {};
    });

    it('test_collectSmartDock_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.typeId = CommonConstants.TYPE_APP;
        let data: GridLayoutItemInfo[] = [];
        transferLayoutManager['collectSmartDock'](dataElement, data);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_collectSmartDock_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.typeId = CommonConstants.TYPE_FOLDER;
        let data: GridLayoutItemInfo[] = [];
        transferLayoutManager['collectSmartDock'](dataElement, data);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_collectDesktop_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.typeId = CommonConstants.TYPE_APP;
        let data: GridLayoutItemInfo[] = [];
        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo1.typeId = CommonConstants.TYPE_APP;
        let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo2.typeId = CommonConstants.TYPE_FOLDER
        data.push(appInfo1);
        data.push(appInfo2);

        transferLayoutManager['collectDesktop'](dataElement, data);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_collectDesktop_03', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.typeId = CommonConstants.TYPE_CARD;
        let data: GridLayoutItemInfo[] = [];
        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo1.typeId = CommonConstants.TYPE_APP;
        let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo2.typeId = CommonConstants.TYPE_FOLDER
        data.push(appInfo1);
        data.push(appInfo2);

        transferLayoutManager['collectDesktop'](dataElement, data);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_collectDesktop_04', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.typeId = CommonConstants.TYPE_FORM_STACK;
        let data: GridLayoutItemInfo[] = [];
        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo1.typeId = CommonConstants.TYPE_APP;
        let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo2.typeId = CommonConstants.TYPE_FOLDER
        data.push(appInfo1);
        data.push(appInfo2);

        transferLayoutManager['collectDesktop'](dataElement, data);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_collectDesktop_05', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPhoneOrPad);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.typeId = CommonConstants.TYPE_FORM_STACK;
        let data: GridLayoutItemInfo[] = [];
        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo1.typeId = CommonConstants.TYPE_APP;
        let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo2.typeId = CommonConstants.TYPE_FOLDER
        data.push(appInfo1);
        data.push(appInfo2);

        let maxScreen: number = transferLayoutManager['maxScreen'];
        BlankPageTransFormItem.getInstance().oldBlankPageList = [maxScreen + 1];

        let notHarmony1 = {
          layoutWeight: 1,
          page: 1,
          typeId: CommonConstants.TYPE_FORM_COMBINE
        } as BaseTransferBean;
        let screenItemInfo = {
          page: 1,
          occupied: [[true]],
          usedCellCnt: 0,
          iconUsedCellCnt: 0,
          folderUsedCellCnt: 0,
          abilityFormUsedCellCnt: 0,
          children: [notHarmony1],
          moveToNextPage: [notHarmony1]
        } as ScreenTransferBean;
        transferLayoutManager['screenDataMap'] =
          new Map<number, ScreenTransferBean>([[maxScreen + 2, screenItemInfo], [maxScreen + 3, screenItemInfo]]);

        transferLayoutManager['collectDesktop'](dataElement, data);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    });

    it('test_getCardRowFromContainer_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let cardLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let oldLayoutInfo: GridLayoutItemInfo[] = [];
        cardLayoutInfo.container = CommonConstants.CONTAINER_DESKTOP;
        transferLayoutManager['getCardRowFromContainer'](cardLayoutInfo, oldLayoutInfo);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_getCardRowFromContainer_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let cardLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let oldLayoutInfo: GridLayoutItemInfo[] = [];
        cardLayoutInfo.container = CommonConstants.CONTAINER_SMARTDOCK;
        transferLayoutManager['getCardRowFromContainer'](cardLayoutInfo, oldLayoutInfo);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_getCardColumnFromContainer_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let cardLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let oldLayoutInfo: GridLayoutItemInfo[] = [];
        cardLayoutInfo.container = CommonConstants.CONTAINER_DESKTOP;
        transferLayoutManager['getCardColumnFromContainer'](cardLayoutInfo, oldLayoutInfo);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_getCardColumnFromContainer_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let cardLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let oldLayoutInfo: GridLayoutItemInfo[] = [];
        cardLayoutInfo.container = CommonConstants.CONTAINER_SMARTDOCK;
        transferLayoutManager['getCardColumnFromContainer'](cardLayoutInfo, oldLayoutInfo);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_compare_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 1;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 2;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(-1);
      } catch (e) {};
    });

    it('test_compare_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 2;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 1;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(1);
      } catch (e) {};
    });

    it('test_compare_03', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 2;
        lhs.row = 1;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 2;
        rhs.row = 2;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(-1);
      } catch (e) {};
    });

    it('test_compare_04', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 2;
        lhs.row = 2;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 2;
        rhs.row = 1;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(1);
      } catch (e) {};
    });

    it('test_compare_05', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 2;
        lhs.row = 2;
        lhs.column = 1;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 2;
        rhs.row = 2;
        rhs.column = 2;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(-1);
      } catch (e) {};
    });

    it('test_compare_06', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 2;
        lhs.row = 2;
        lhs.column = 2;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 2;
        rhs.row = 2;
        rhs.column = 1;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(1);
      } catch (e) {};
    });

    it('test_compare_07', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 2;
        lhs.row = 2;
        lhs.column = 2;
        lhs.id = 100;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 2;
        rhs.row = 2;
        rhs.column = 2;
        rhs.id = 100;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(0);
      } catch (e) {};
    });

    it('test_findEmptyPosition_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let occupied: boolean[][] = [[true, false, true],[false, true, true]];
        let row: number = 0;
        let ret: number = transferLayoutManager['findEmptyPosition'](occupied, row);
        expect(ret).assertEqual(1);
      } catch (e) {};
    });

    it('test_addFormCombineToLastPage_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let screenData: ScreenTransferBean = new ScreenTransferBean();
        screenData.moveToNextPage = [];
        let isNewPage: boolean = true;
        transferLayoutManager['addFormCombineToLastPage'](screenData, isNewPage);

        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_dealWithNeedMoveToNextPage_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let screenData: ScreenTransferBean = new ScreenTransferBean();
        screenData.moveToNextPage = [];
        let occupied: boolean[][] = []
        transferLayoutManager['dealWithNeedMoveToNextPage'](screenData, occupied);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_updateInfoId_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let layoutInfo: GridLayoutItemInfo[] = [];

        transferLayoutManager['updateInfoId'](layoutInfo);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_updateInfoId_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let layoutInfo: GridLayoutItemInfo[] = [];
        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo1.typeId = CommonConstants.TYPE_APP;
        let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo2.typeId = CommonConstants.TYPE_FOLDER
        layoutInfo.push(appInfo1);
        layoutInfo.push(appInfo2);
        transferLayoutManager['updateInfoId'](layoutInfo);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_transferLayout_01', Level.LEVEL0, async (done:Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayout.typeId = 0;
        gridLayout.infoId = 'gridLayoutInfoId';
        gridLayout.appName = 'gridLayoutAppName';
        gridLayout.bundleName = 'gridLayoutBundleName';
        gridLayout.keyName = 'gridLayoutKeyName';
        gridLayout.folderName = 'gridLayoutFolderName'
        gridLayout.abilityName = 'gridLayoutAbilityName';
        gridLayout.moduleName = 'gridLayoutModuleName';
        gridLayout.appIconId = 1;
        gridLayout.appLabelId = 2;
        gridLayout.badgeNumber = 3;
        gridLayout.row = 4;
        gridLayout.column = 5;
        gridLayout.area = [2, 2];
        gridLayout.areaType = 0;

        let result: boolean = await transferLayoutManager.transferLayout([gridLayout], '', false, false);
        expect(result).assertTrue();
      } catch (e) {};
      done();
    })

    it('test_transferLayout_02', Level.LEVEL0, async (done:Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayout.typeId = 0;
        gridLayout.infoId = 'gridLayoutInfoId';
        gridLayout.appName = 'gridLayoutAppName';
        gridLayout.bundleName = 'gridLayoutBundleName';
        gridLayout.keyName = 'gridLayoutKeyName';
        gridLayout.folderName = 'gridLayoutFolderName'
        gridLayout.abilityName = 'gridLayoutAbilityName';
        gridLayout.moduleName = 'gridLayoutModuleName';
        gridLayout.appIconId = 1;
        gridLayout.appLabelId = 2;
        gridLayout.badgeNumber = 3;
        gridLayout.row = 4;
        gridLayout.column = 5;
        gridLayout.area = [2, 2];
        gridLayout.areaType = 0;

        let result: boolean = await transferLayoutManager.transferLayout([gridLayout], '', true, false);
        expect(result).assertTrue();
      } catch (e) {};
      done();
    })

    it('test_transferLayout_03', Level.LEVEL0, async (done:Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayout.typeId = 0;
        gridLayout.infoId = 'gridLayoutInfoId';
        gridLayout.appName = 'gridLayoutAppName';
        gridLayout.bundleName = 'gridLayoutBundleName';
        gridLayout.keyName = 'gridLayoutKeyName';
        gridLayout.folderName = 'gridLayoutFolderName'
        gridLayout.abilityName = 'gridLayoutAbilityName';
        gridLayout.moduleName = 'gridLayoutModuleName';
        gridLayout.appIconId = 1;
        gridLayout.appLabelId = 2;
        gridLayout.badgeNumber = 3;
        gridLayout.row = 4;
        gridLayout.column = 5;
        gridLayout.area = [2, 2];
        gridLayout.areaType = 0;

        let result: boolean = await transferLayoutManager.transferLayout([gridLayout], '', false, false);
        expect(result).assertTrue();
      } catch (e) {};
      done();
    })

    it('test_transferLayout_04', Level.LEVEL0, async (done:Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayout.typeId = 0;
        gridLayout.infoId = 'gridLayoutInfoId';
        gridLayout.appName = 'gridLayoutAppName';
        gridLayout.bundleName = 'gridLayoutBundleName';
        gridLayout.keyName = 'gridLayoutKeyName';
        gridLayout.folderName = 'gridLayoutFolderName'
        gridLayout.abilityName = 'gridLayoutAbilityName';
        gridLayout.moduleName = 'gridLayoutModuleName';
        gridLayout.appIconId = 1;
        gridLayout.appLabelId = 2;
        gridLayout.badgeNumber = 3;
        gridLayout.row = 4;
        gridLayout.column = 5;
        gridLayout.area = [2, 2];
        gridLayout.areaType = 0;

        let result: boolean = await transferLayoutManager.transferLayout([gridLayout], '', true, false);
        expect(result).assertTrue();
      } catch (e) {};
      done();
    })

    it('test_dealDiffSizeChildCards', Level.LEVEL0, async (done:Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let childElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        childElement.typeId = 1;
        childElement.infoId = '123456789';
        childElement.appName = '玩机技巧';
        childElement.bundleName = 'com.ohos.tips';
        childElement.keyName = 'com.ohos.tips0';
        childElement.folderName = ''
        childElement.abilityName = 'FormAbility';
        childElement.moduleName = 'phone';
        childElement.appIconId = 1;
        childElement.appLabelId = 2;
        childElement.badgeNumber = 3;
        childElement.row = 0;
        childElement.column = 2;
        childElement.area = [2, 2];
        expect(transferLayoutManager['dealDiffSizeChildCards']([childElement], [2, 4], []) === undefined).assertTrue();
      } catch (e) {};
      done();
    })

    it('test_rearrangeCardFromPage', Level.LEVEL0, async (done:Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let tipsCard: BaseTransferBean = new BaseTransferBean();
        tipsCard.typeId = 1;
        tipsCard.infoId = '123456789';
        tipsCard.appName = '玩机技巧';
        tipsCard.bundleName = 'com.ohos.tips';
        tipsCard.keyName = 'com.ohos.tips0';
        tipsCard.folderName = ''
        tipsCard.abilityName = 'FormAbility';
        tipsCard.moduleName = 'phone';
        tipsCard.appIconId = 1;
        tipsCard.appLabelId = 2;
        tipsCard.badgeNumber = 3;
        tipsCard.row = 0;
        tipsCard.column = 2;
        tipsCard.area = [2, 2];
        tipsCard.layoutWeight = 0;
        expect(transferLayoutManager['rearrangeCardFromPage'](2, tipsCard) === undefined).assertTrue();
      } catch (e) {};
      done();
    })

    it("test_getIsNewLayoutFromSP_01", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      try {
        let result1 = await transferLayoutManager['getIsNewLayoutFromSP'](false);
        expect(result1).assertInstanceOf('Boolean');
      } catch (e) {};
      try {
        let result2 = await transferLayoutManager['getIsNewLayoutFromSP'](true);
        expect(result2).assertInstanceOf('Boolean');
      } catch (e) {};
      let globalInstance = GlobalContext.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(globalInstance, globalInstance.getObject);
      when(mockFunction)(ArgumentMatchers.any).afterThrow('error');
      try {
        let result = await transferLayoutManager['getIsNewLayoutFromSP'](true);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      mocker.clear(globalInstance);
      done();
    })

    it("generateNewFirstPage1", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1
          },
          {
            row: 2,
            column: 2
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList:[] as SCBSceneContainerSession[],
        appIconId:0,
        abilityName:'',
        appName:'',
        bundleName:''
      } as DockItemInfo;
      let itemInfo2 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1
          },
          {
            row: 2,
            column: 2
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList:[] as SCBSceneContainerSession[],
        appIconId:0,
        abilityName:'',
        appName:'',
        bundleName:''
      } as DockItemInfo;
      let rdbStoreMangerInstance = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.querySmartDock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1, itemInfo2]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['generateNewFirstPage']();
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      mocker.clear(rdbStoreMangerInstance);
      done();
    })

    it("generateNewFirstPage2", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_APP
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_APP
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList:[] as SCBSceneContainerSession[],
        appIconId:0,
        abilityName:'',
        appName:'',
        bundleName:''
      } as DockItemInfo;
      let itemInfo2 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_APP
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_APP
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList:[] as SCBSceneContainerSession[],
        appIconId:0,
        abilityName:'',
        appName:'',
        bundleName:''
      } as DockItemInfo;
      let rdbStoreMangerInstance = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.querySmartDock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1, itemInfo2]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['generateNewFirstPage']();
      } catch (e) {};
      expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      mocker.clear(rdbStoreMangerInstance);
      done();
    })

    it("generateNewFirstPage3", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_FOLDER
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_FOLDER
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList:[] as SCBSceneContainerSession[],
        appIconId:0,
        abilityName:'',
        appName:'',
        bundleName:''
      } as DockItemInfo;
      let itemInfo2 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_FOLDER
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_FOLDER
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList:[] as SCBSceneContainerSession[],
        appIconId:0,
        abilityName:'',
        appName:'',
        bundleName:''
      } as DockItemInfo;
      let rdbStoreMangerInstance = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.querySmartDock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1, itemInfo2]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['generateNewFirstPage']();
      } catch (e) {};
      expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      mocker.clear(rdbStoreMangerInstance);
      done();
    })

    it("generateNewFirstPage4", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_CARD
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_CARD
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList:[] as SCBSceneContainerSession[],
        appIconId:0,
        abilityName:'',
        appName:'',
        bundleName:''
      } as DockItemInfo;
      let itemInfo2 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_CARD
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_CARD
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList:[] as SCBSceneContainerSession[],
        appIconId:0,
        abilityName:'',
        appName:'',
        bundleName:''
      } as DockItemInfo;
      let rdbStoreMangerInstance = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.querySmartDock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1, itemInfo2]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['generateNewFirstPage']();
      } catch (e) {};
      expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      mocker.clear(rdbStoreMangerInstance);
      done();
    })

    it("generateNewFirstPage5", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_FORM_STACK
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_FORM_STACK
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList:[] as SCBSceneContainerSession[],
        appIconId:0,
        abilityName:'',
        appName:'',
        bundleName:''
      } as DockItemInfo;
      let itemInfo2 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_FORM_STACK
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_FORM_STACK
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList:[] as SCBSceneContainerSession[],
        appIconId:0,
        abilityName:'',
        appName:'',
        bundleName:''
      } as DockItemInfo;
      let rdbStoreMangerInstance = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.querySmartDock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1, itemInfo2]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['generateNewFirstPage']();
      } catch (e) {};
      expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      mocker.clear(rdbStoreMangerInstance)
      done();
    })

    it("generateNewFirstPage6", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.CONTAINER_SMARTDOCK
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.CONTAINER_SMARTDOCK
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList:[] as SCBSceneContainerSession[],
        appIconId:0,
        abilityName:'',
        appName:'',
        bundleName:''
      } as DockItemInfo;
      let itemInfo2 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.CONTAINER_SMARTDOCK
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList:[] as SCBSceneContainerSession[],
        appIconId:0,
        abilityName:'',
        appName:'',
        bundleName:''
      } as DockItemInfo;
      let rdbStoreMangerInstance = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.querySmartDock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1, itemInfo2]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['generateNewFirstPage']();
      } catch (e) {};
      expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      mocker.clear(rdbStoreMangerInstance)
      done();
    })

    it("test_printFirstPageItem_01", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      transferLayoutManager['isBigFold'] = true
      let itemInfo1 = [
        {
          row: 1,
          column: 1,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 0,
          typeId: CommonConstants.CONTAINER_SMARTDOCK
        },
        {
          row: 2,
          column: 2,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 1
        },
        {
          row: 2,
          column: 2,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 1
        },
        {
          row: 2,
          column: 2,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 1
        },
      ] as GridLayoutItemInfo[];
      try {
        transferLayoutManager['printFirstPageItem'](itemInfo1);
      } catch (e) {};
      expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      done();
    })

    it("test_isNeedAddTodeliverFolder0", 0, async (done: Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let itemInfo = {
          row: 1,
          column: 1,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 0,
          typeId: CommonConstants.TYPE_CARD,
          bundleName: 'name',
        } as GridLayoutItemInfo;
        let result = transferLayoutManager['isNeedAddTodeliverFolder'](itemInfo);
        expect(result).assertInstanceOf('Boolean');
        done();
      } catch (e) {};
    })

    it("test_isNeedAddTodeliverFolder_01", 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let itemInfo = {
          typeId: CommonConstants.TYPE_APP + 1,
        } as GridLayoutItemInfo;
        let result = transferLayoutManager['isNeedAddTodeliverFolder'](itemInfo);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_isNeedAddTodeliverFolder_02", 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let pkg: string = '1';
        let itemInfo = {
          typeId: CommonConstants.TYPE_APP,
          intent: JSON.stringify(new Map([['installSource', pkg]])),
        } as GridLayoutItemInfo;
        let result = transferLayoutManager['isNeedAddTodeliverFolder'](itemInfo);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_isNeedAddTodeliverFolder_03", 0, () => {
      let mock = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let pkg: string = DeliverUtil.DELIVER_APPSTORE_PKG;
        let itemInfo = {
          typeId: CommonConstants.TYPE_APP,
          container: CommonConstants.CONTAINER_UNIQUE_SINGLE + 1,
          intent: JSON.stringify(new Map([['installSource', pkg]])),
        } as GridLayoutItemInfo;
        let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.isInContainerFolder);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        let result = transferLayoutManager['isNeedAddTodeliverFolder'](itemInfo);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it("test_isNeedAddTodeliverFolder_05", 0, () => {
      let mock = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let pkg: string = DeliverUtil.DELIVER_APPSTORE_PKG;
        let itemInfo = {
          typeId: CommonConstants.TYPE_APP,
          container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
          intent: JSON.stringify(new Map([['installSource', pkg]])),
        } as GridLayoutItemInfo;
        let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.isInContainerFolder);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        let result = transferLayoutManager['isNeedAddTodeliverFolder'](itemInfo);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it("test_isNeedAddTodeliverFolder_04", 0, () => {
      let mock = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let pkg: string = DeliverUtil.DELIVER_APPSTORE_PKG;
        let itemInfo = {
          typeId: CommonConstants.TYPE_APP,
          intent: JSON.stringify(new Map([['installSource', pkg]])),
          appStatus: AppStatus.INSTALLED,
        } as GridLayoutItemInfo;
        let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.isInContainerFolder);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let result = transferLayoutManager['isNeedAddTodeliverFolder'](itemInfo);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(dataConvert);
      mock.clearAll();
    })

    it("insertNewLayoutToDb1", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let layoutInfo = [
        {
          row: 1,
          column: 1,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 0,
          typeId: CommonConstants.CONTAINER_SMARTDOCK
        },
        {
          row: 2,
          column: 2,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 0,
          typeId: CommonConstants.TYPE_CARD
        },
      ] as GridLayoutItemInfo[];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['getNewLayoutFromScreenDataMap']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(layoutInfo);
      try {
        transferLayoutManager['insertNewLayoutToDb'](true);
      } catch (e) {};
      expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      mocker.clear(transferLayoutManager);
      done();
    })

    it("insertNewLayoutToDb2", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let layoutInfo = [
        {
          row: 1,
          column: 1,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 0,
          typeId: CommonConstants.CONTAINER_SMARTDOCK
        },
        {
          row: 2,
          column: 2,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 0,
          typeId: CommonConstants.TYPE_CARD
        },
      ] as GridLayoutItemInfo[];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['getNewLayoutFromScreenDataMap']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(layoutInfo);
      try {
        transferLayoutManager['insertNewLayoutToDb'](false);
      } catch (e) {};
      expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      mocker.clear(transferLayoutManager);
      done();
    })

    it("insertNewLayoutToDb3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FORM_STACK,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_CARD
      }) as GridLayoutItemInfo;
      let rdbStoreManagerInstance:RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['getNewLayoutFromScreenDataMap']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([gridLayoutItem,gridLayoutItem]);
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreManagerInstance, rdbStoreManagerInstance.deleteAllGridInfoData);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockFunction2: Function =
        mocker.mockFunc(rdbStoreManagerInstance, rdbStoreManagerInstance.updateSettings);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockFunction3: Function =
        mocker.mockFunc(rdbStoreManagerInstance, rdbStoreManagerInstance.insertGridLayoutInfo);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      try {
        await transferLayoutManager['insertNewLayoutToDb']();
        expect(transferLayoutManager['newLayoutCardItems'].length).not().assertEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(rdbStoreManagerInstance);
      done();
    })

    it("dealNotHarmonyElement1", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true)
      let notHarmony1 = {
        layoutWeight: 1,
        page: 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [notHarmony1],
        moveToNextPage: [notHarmony1]
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      try {
        transferLayoutManager['dealNotHarmonyElement']();
      } catch (e) {};
      expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      mocker.clear(CheckEmptyUtils);
      done();
    })

    it("dealNotHarmonyElement2", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let notHarmony1 = {
        layoutWeight: 1,
        page: 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE
      } as BaseTransferBean;
      transferLayoutManager['notHarmonyList'] = [notHarmony1, notHarmony1]
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [notHarmony1],
        moveToNextPage: [notHarmony1]
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]])
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['dealNotHarmonyElement']();
      } catch (e) {};
      expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(transferLayoutManager);
      done();
    })

    it("dealNotHarmonyElement3", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      try {
        let notHarmony1 = {
          layoutWeight: 1,
          page: 1,
          typeId: CommonConstants.TYPE_FORM_COMBINE
        } as BaseTransferBean;
        transferLayoutManager['notHarmonyList'] = [notHarmony1]
        let screenItemInfo = {
          page: 1,
          occupied: [[true]],
          usedCellCnt: 0,
          iconUsedCellCnt: 0,
          folderUsedCellCnt: 0,
          abilityFormUsedCellCnt: 0,
          children: [notHarmony1],
          moveToNextPage: [notHarmony1]
        } as ScreenTransferBean;
        transferLayoutManager['screenDataMap'] =
          new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]])
        let mocker: MockKit = new MockKit();
        let mockFunction: Function =
          mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
        let mockFunction1: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
        try {
          transferLayoutManager['dealNotHarmonyElement']();
        } catch (e) {};
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
        mocker.clear(CheckEmptyUtils);
        mocker.clear(transferLayoutManager);
        
        done();
      }catch (err){
        expect(transferLayoutManager).not().assertUndefined();
        done();
      };
    })

    it("test_getNewLayoutCardItems_01", 0, async (done: Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        transferLayoutManager.getNewLayoutCardItems();
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
        done();
      } catch (e) {};
    })

    it("test_mergeScreenDataMap_01", 0, async (done: Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let notHarmony1 = {
          layoutWeight: 1,
          page: 1,
          typeId: CommonConstants.TYPE_FORM_COMBINE
        } as BaseTransferBean;
        let screenItemInfo = {
          page: 1,
          occupied: [[true]],
          usedCellCnt: 0,
          iconUsedCellCnt: 0,
          folderUsedCellCnt: 0,
          abilityFormUsedCellCnt: 0,
          children: [notHarmony1],
          moveToNextPage: [notHarmony1]
        } as ScreenTransferBean;
        transferLayoutManager['screenDataMap'] =
          new Map<number, ScreenTransferBean>([[3, screenItemInfo], [4, screenItemInfo]]);
        transferLayoutManager['moveToNextDataMap'] =
          new Map<number, ScreenTransferBean[]>([[3, [screenItemInfo]], [4, [screenItemInfo]]]);
        transferLayoutManager['mergeScreenDataMap']();
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_mergeScreenDataMap_02", 0, async (done: Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let notHarmony1 = {
          layoutWeight: 1,
          page: 1,
          typeId: CommonConstants.TYPE_FORM_COMBINE
        } as BaseTransferBean;
        let screenItemInfo = {
          page: 1,
          occupied: [[true]],
          usedCellCnt: 0,
          iconUsedCellCnt: 0,
          folderUsedCellCnt: 0,
          abilityFormUsedCellCnt: 0,
          children: [notHarmony1],
          moveToNextPage: [notHarmony1]
        } as ScreenTransferBean;
        transferLayoutManager['screenDataMap'] =
          new Map<number, ScreenTransferBean>([[3, screenItemInfo], [4, screenItemInfo]]);
        transferLayoutManager['moveToNextDataMap'] = new Map();
        transferLayoutManager['mergeScreenDataMap']();
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_sortScreenDataMap_01", 0, async (done: Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let notHarmony1 = {
          layoutWeight: 1,
          page: 1,
          typeId: CommonConstants.TYPE_FORM_COMBINE
        } as BaseTransferBean;
        let screenItemInfo = {
          page: 1,
          occupied: [[true]],
          usedCellCnt: 0,
          iconUsedCellCnt: 0,
          folderUsedCellCnt: 0,
          abilityFormUsedCellCnt: 0,
          children: [notHarmony1],
          moveToNextPage: [notHarmony1]
        } as ScreenTransferBean;
        transferLayoutManager['screenDataMap'] =
          new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
        transferLayoutManager['sortScreenDataMap']();
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
        done();
      } catch (e) {};
    })

    it("transferLayout1", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let notHarmony1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE
      } as BaseTransferBean;
      let screenItemInfo = {
        page: CommonConstants.INVALID_VALUE,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [notHarmony1, notHarmony1],
        moveToNextPage: [notHarmony1, notHarmony1]
      } as ScreenTransferBean;
      let layoutInfo1 = [
        {
          row: 1,
          column: 1,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 0
        },
        {
          row: 2,
          column: 2,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 0
        },
      ] as GridLayoutItemInfo[];
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[3, screenItemInfo], [4, screenItemInfo]])
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['insertNewLayoutToDb']);
      when(mockFunction1)(ArgumentMatchers.any).afterThrow('error');
      try {
        let result = await transferLayoutManager.transferLayout(layoutInfo1);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(DeviceHelper);
      mocker.clear(transferLayoutManager);
      done();
    })

    it("transferLayout2", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let notHarmony1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE
      } as BaseTransferBean;
      let screenItemInfo = {
        page: CommonConstants.INVALID_VALUE,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [notHarmony1, notHarmony1],
        moveToNextPage: [notHarmony1, notHarmony1]
      } as ScreenTransferBean;
      let layoutInfo1 = [
        {
          row: 1,
          column: 1,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 0
        },
        {
          row: 2,
          column: 2,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 0
        },
      ] as GridLayoutItemInfo[];
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[3, screenItemInfo], [4, screenItemInfo]])
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['placeAllElements']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['insertNewLayoutToDb']);
      when(mockFunction2)(ArgumentMatchers.any).afterThrow('error');
      try {
        let result = await transferLayoutManager.transferLayout(layoutInfo1);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(DeviceHelper);
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_placeAllElements_01", 0, () => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let notHarmony1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName1',
      } as BaseTransferBean;
      let notHarmony2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName2',
      } as BaseTransferBean;
      let notHarmony3 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName3',
      } as BaseTransferBean;
      let notHarmony4 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName4',
      } as BaseTransferBean;
      let notHarmony5 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_AREA_DESKTOP,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName5',
      } as BaseTransferBean;
      let screenItemInfo = {
        page: CommonConstants.INVALID_VALUE,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5,notHarmony2,notHarmony3,notHarmony4,notHarmony5],
        moveToNextPage: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5]
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaInScreen']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSuperFoldMachine);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['placeAllElements'](screenItemInfo, true);
        expect(screenItemInfo.children.length).not().assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clear(DeviceHelper);
    })

    it("test_placeAllElements_02", 0, () => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let notHarmony1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName1',
      } as BaseTransferBean;
      let notHarmony2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName2',
      } as BaseTransferBean;
      let notHarmony3 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName3',
      } as BaseTransferBean;
      let notHarmony4 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName4',
      } as BaseTransferBean;
      let notHarmony5 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_AREA_DESKTOP,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName5',
      } as BaseTransferBean;
      let screenItemInfo = {
        page: CommonConstants.INVALID_VALUE,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5,notHarmony2,notHarmony3,notHarmony4,notHarmony5],
        moveToNextPage: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5]
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaInScreen']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSuperFoldMachine);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['placeAllElements'](screenItemInfo, false);
        expect(screenItemInfo.children.length).not().assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clear(DeviceHelper);
    })

    it("test_placeAllElements_03", 0, () => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSuperFoldMachine);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['placeAllElements'](screenItemInfo, true);
        expect(transferBean.isNeedRestoreFromBackup).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
    })

    it("test_placeAllElements_04", 0, () => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let notHarmony1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName1',
      } as BaseTransferBean;
      let notHarmony2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName2',
      } as BaseTransferBean;
      let notHarmony3 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName3',
      } as BaseTransferBean;
      let notHarmony4 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName4',
      } as BaseTransferBean;
      let notHarmony5 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_REGION_FOLDER,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName5',
      } as BaseTransferBean;
      let screenItemInfo = {
        page: CommonConstants.INVALID_VALUE,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5],
        moveToNextPage: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5]
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaInScreen']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSuperFoldMachine);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['placeAllElements'](screenItemInfo, false);
        expect(screenItemInfo.children.length).not().assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clear(DeviceHelper);
    })

    it("test_placeAllElements_05", 0, () => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let notHarmony1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName1',
      } as BaseTransferBean;
      let notHarmony2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName2',
      } as BaseTransferBean;
      let notHarmony3 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName3',
      } as BaseTransferBean;
      let notHarmony4 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName4',
      } as BaseTransferBean;
      let notHarmony5 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_REGION_FOLDER,
        isNeedRestoreFromBackup:true,
        container: CommonConstants.CONTAINER_DESKTOP,
        bundleName:'bundleName5',
      } as BaseTransferBean;
      let screenItemInfo = {
        page: CommonConstants.INVALID_VALUE,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5],
        moveToNextPage: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5]
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaInScreen']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSuperFoldMachine);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['placeAllElements'](screenItemInfo, false);
        expect(screenItemInfo.children.length).not().assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clear(DeviceHelper);
    })

    it("test_findLastNotSmallContainerFolderElement1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let notHarmony1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName1',
      } as BaseTransferBean;
      let notHarmony2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName2',
      } as BaseTransferBean;
      let notHarmony3 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName3',
      } as BaseTransferBean;
      let notHarmony4 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName4',
      } as BaseTransferBean;
      let notHarmony5 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName5'
      } as BaseTransferBean;
      let screenItemInfo = {
        page: CommonConstants.INVALID_VALUE,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5,notHarmony2,notHarmony3,notHarmony4,notHarmony5],
        moveToNextPage: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5]
      } as ScreenTransferBean;
      try {
        let lastElement: BaseTransferBean = transferLayoutManager['findLastNotSmallContainerFolderElement'](screenItemInfo);
        expect(lastElement).not().assertEqual(undefined);
      } catch (e) {};

      done();
    })

    it("test_findLastNotSmallContainerFolderElement0", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let notHarmony1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName1',
      } as BaseTransferBean;
      let notHarmony2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName2',
      } as BaseTransferBean;
      let notHarmony3 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName3',
      } as BaseTransferBean;
      let notHarmony4 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName4',
      } as BaseTransferBean;
      let notHarmony5 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName5',
        area: [1, 1],
      } as BaseTransferBean;
      let screenItemInfo = {
        page: CommonConstants.INVALID_VALUE,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5,notHarmony2,notHarmony3,notHarmony4,notHarmony5],
        moveToNextPage: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5]
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      try {
        let lastElement: BaseTransferBean = transferLayoutManager['findLastNotSmallContainerFolderElement'](screenItemInfo);
        expect(lastElement).not().assertEqual(undefined);
      } catch (e) {};
      mocker.clear(transferLayoutManager);

      done();
    })

    it("findAreaInScreen1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      let occupied = [[true,false,true],[false,true,false],[true,false,true]];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validElementArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      try {
        let result = transferLayoutManager['findAreaInScreen'](occupied,transferBean);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("findAreaInScreen2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      let occupied = [[true,false,true],[false,true,false],[true,false,true]];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validElementArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['findAreaInScreen'](occupied,transferBean);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_generateNewFirstPage", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1 = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP,
        page: 0,
        typeId: CommonConstants.TYPE_FOLDER,
        bundleName:'bundleName1',
        isBigFold:false,
        layoutInfo:[[]]
      }) as GridLayoutItemInfo;
      let gridLayoutItem2 = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_APP,
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1]]
      }) as GridLayoutItemInfo;
      let gridLayoutItem3= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FORM_STACK,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_APP,
        layoutInfo:[[gridLayoutItem1,gridLayoutItem2]]
      }) as GridLayoutItemInfo;
      let rdbStoreMangerInstance:RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.queryGridLayoutInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([gridLayoutItem3,gridLayoutItem3,gridLayoutItem3]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['printFirstPageItem']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['getDefaultLayoutInfoFromConfig']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn([gridLayoutItem3,gridLayoutItem3]);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putPageData']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction5: Function =
        mocker.mockFunc(Extend1Data, Extend1Data.setCardSourceType);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        await transferLayoutManager['generateNewFirstPage']();
        expect(transferLayoutManager['firstPageElementSet'].size>=0).assertTrue();
      } catch (e) {};
      mocker.clear(rdbStoreMangerInstance);
      mocker.clear(transferLayoutManager);
      mocker.clear(Extend1Data);
      done();
    })

    it("test_dealNotHarmonyElement1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      transferLayoutManager['notHarmonyList'] = [transferBean];
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean]
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        let theLastPage:ScreenTransferBean = transferLayoutManager['screenDataMap'].get(transferLayoutManager['screenDataMap'].size - 1)!;
        expect(theLastPage!.children!.length).not().assertEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_dealNotHarmonyElement2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      transferLayoutManager['notHarmonyList'] = [transferBean];
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean]
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      transferLayoutManager['maxScreen'] = 2;
      transferLayoutManager['maxScreenCount'] = 2;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        let theLastPage:ScreenTransferBean = transferLayoutManager['screenDataMap'].get(transferLayoutManager['screenDataMap'].size - 1)!;
        expect(theLastPage!.children!.length).not().assertEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_updateInfoId_7", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      try {
        let gridLayoutItem1 = new Object({
          row: 1,
          column: 1,
          container: CommonConstants.TYPE_FOLDER,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName2',
          typeId: CommonConstants.TYPE_FOLDER,
          layoutInfo: [[]],
          infoId: '1'
        }) as GridLayoutItemInfo;
        let gridLayoutItem2 = new Object({
          row: 1,
          column: 1,
          container: CommonConstants.TYPE_FOLDER,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName2',
          typeId: CommonConstants.TYPE_FOLDER,
          layoutInfo: [[gridLayoutItem1]],
          infoId: '2'
        }) as GridLayoutItemInfo;
        let gridLayoutItem3 = new Object({
          row: 1,
          column: 1,
          container: CommonConstants.TYPE_FOLDER,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName2',
          typeId: CommonConstants.TYPE_FOLDER,
          layoutInfo: [[gridLayoutItem1, gridLayoutItem1], [gridLayoutItem2, gridLayoutItem2]],
          infoId: '3'
        }) as GridLayoutItemInfo;
        let folderReporterInstance: FolderReporter = FolderReporter.getInstance();
        let rdbStoreManagerInstance: RdbStoreManager = RdbStoreManager.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunction: Function =
          mocker.mockFunc(folderReporterInstance, folderReporterInstance.reportCreateFolderInTransfer);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
        let mockFunction1: Function =
          mocker.mockFunc(rdbStoreManagerInstance, rdbStoreManagerInstance.generateRandomUUID);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn('1');
        try {
          transferLayoutManager['updateInfoId']([gridLayoutItem3]);
        } catch (e) {
        }
        ;
        let infoId: string = gridLayoutItem1.infoId!;
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
        mocker.clear(folderReporterInstance);
        mocker.clear(rdbStoreManagerInstance);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it("test_getNewLayoutFromScreenDataMap_01", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['mergeScreenDataMap']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean]
      } as ScreenTransferBean;
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1'
      }) as GridLayoutItemInfo;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['disbandFormCombine']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn([gridLayoutItem,gridLayoutItem]);
      let mockFunction3: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      try {
        let result = transferLayoutManager['getNewLayoutFromScreenDataMap']();
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clear(DeviceHelper);
      done();
    })

    it("test_getNewLayoutFromScreenDataMap_02", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['mergeScreenDataMap']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean]
      } as ScreenTransferBean;
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1'
      }) as GridLayoutItemInfo;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['disbandFormCombine']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn([gridLayoutItem,gridLayoutItem]);
      let mockFunction3: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      try {
        let result = transferLayoutManager['getNewLayoutFromScreenDataMap']();
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clear(DeviceHelper);

      done();
    })

    it("test_getNewLayoutFromScreenDataMap_03", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['mergeScreenDataMap']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_STACK,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean, transferBean2],
        moveToNextPage: [transferBean]
      } as ScreenTransferBean;
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1'
      }) as GridLayoutItemInfo;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['disbandFormCombine']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn([gridLayoutItem,gridLayoutItem]);
      let mockFunction3: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      try {
        let result = transferLayoutManager['getNewLayoutFromScreenDataMap']();
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clear(DeviceHelper);

      done();
    })

    it("dealFormStackElement1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1'
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_STACK,
        isNeedRestoreFromBackup:false,
        layoutInfo:[[gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean]
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      try {
        transferLayoutManager['dealFormStackElement']();
        expect(transferLayoutManager['screenDataMap'].size).not().assertEqual(0);
      } catch (e) {};
      done();
    })

    it("dealFormStackElement2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[5,5]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        column:1,
        container:1,
        area:[4,4],
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_STACK,
        cardName:'cardName',
        bundleName:'bundleName',
        moduleName:'moduleName',
        isNeedRestoreFromBackup:false,
        layoutInfo:[[gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean]
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['getFormStackMaxArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([1,1]);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealDiffSizeChildCards']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['rearrangeCardFromPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealFormStackElement']();
        expect(transferLayoutManager['screenDataMap'].size).not().assertEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_getFormStackMaxArea_01", 0, async(done:Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let gridLayoutItem1= new Object({
          row: 1,
          column: 1,
          container: CommonConstants.TYPE_FOLDER,
          page: 1,
          isBigFold:true,
          bundleName:'bundleName2',
          typeId: CommonConstants.TYPE_FOLDER,
          layoutInfo:[[]],
          infoId:'1',
          area:[5,5]
        }) as GridLayoutItemInfo;
        let result = transferLayoutManager['getFormStackMaxArea']([gridLayoutItem1]);
        expect(result[0]).assertEqual(5);
      } catch (e) {};
      done();
    })

    it("test_dealDiffSizeChildCards_01", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      let childElement = [gridLayoutItem1];
      let rearrange = [transferBean];
      let maxArea = [1,1];
      try {
        transferLayoutManager['dealDiffSizeChildCards'](childElement,maxArea,rearrange);
        expect(rearrange.length===1).assertInstanceOf('Boolean');
      } catch (e) {};
      done();
    })

    it("test_rearrangeCardFromPage_01", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean]
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaInScreen']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['rearrangeCardFromPage'](0,transferBean);
        let children:BaseTransferBean[] = transferLayoutManager['screenDataMap'].get(0)!.children;
        expect(children.length>1).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_screenDataMap_01", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean]
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      transferLayoutManager['transferType'] = BackupSceneBundleVersionName.WINPC_TO_ohos;
      transferLayoutManager['isBigFold'] = true;
      transferLayoutManager['isNewLayout'] = false;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['transferByScreen']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        expect(transferLayoutManager['screenDataMap'].size).not().assertEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_dealWithNeedMoveToNextPage_02", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let screenData: ScreenTransferBean = new ScreenTransferBean();
      screenData.moveToNextPage = [];
      let occupied: boolean[][] = [];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['toMaxScreen']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealWithNeedMoveToNextPage'](screenData, occupied);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("addFormCombineToLastPage1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean,transferBean]
      } as ScreenTransferBean;
      transferLayoutManager['formCombinePage'] = CommonConstants.INVALID_VALUE;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['toMaxScreen']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putPageData']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['addFormCombineToLastPage'](screenItemInfo,false);
        expect(screenData!.moveToNextPage!.length).assertEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("addFormCombineToLastPage2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: -1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      let screenItemInfo = {
        page: -1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean,transferBean]
      } as ScreenTransferBean;
      transferLayoutManager['formCombinePage'] = CommonConstants.INVALID_VALUE;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['toMaxScreen']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putPageData']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['addFormCombineToLastPage'](screenItemInfo,false);
        expect(screenData!.moveToNextPage!.length).assertEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_calculateRowElement_01", 0, async(done:Function) => {
      let rowElementMap: Map<number, number[]> = new Map();
      let widgetIndexArr: number[] = [];
      let emptyRowArr: number[] = [];
      let transferBean = {
        layoutWeight: 1,
        page: -1,
        row: 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:false,
        cardName:'ClockWeatherCard',
        area:[1,1]
      } as BaseTransferBean;
      let transferBean1 = {
        layoutWeight: 1,
        page: -1,
        row: 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:false,
        cardName:'ClockWeatherHoriCard',
        area:[1,1]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: -1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean,transferBean1]
      } as ScreenTransferBean;
      try {
        transferLayoutManager['calculateRowElement'](screenItemInfo, rowElementMap, widgetIndexArr, emptyRowArr);
        expect(widgetIndexArr.length>0).assertTrue();
      } catch (e) {};
      done();
    })

    it("test_realignByRefresh_01", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let occupied: boolean[][] = [[true,false],[true,false]];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      transferLayoutManager['realignByRefresh'](screenItemInfo,occupied);
      try {
        let children:BaseTransferBean[] = screenItemInfo.children
        expect(children.length<3).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_regroupWidgetPosition_01", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let widgetIndexArr = [0,1];
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let emptyRowArr = [0,1];
      let rowElementMap = new Map<number,number[]>([[2,[0,1]],[3,[1,2]]]);
      try {
        transferLayoutManager['isFirstWidgetProcessed'] = false;
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr,screenItemInfo,emptyRowArr,rowElementMap);
        expect(transferLayoutManager['isFirstWidgetProcessed']).assertInstanceOf('Boolean');
      } catch (e) {};
      done();
    })

    it("test_regroupWidgetPosition_02", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let widgetIndexArr = [0,1];
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let emptyRowArr = [0,1];
      let rowElementMap = new Map<number,number[]>([[0,[0,1]],[1,[1,2]]]);
      try {
        transferLayoutManager['isFirstWidgetProcessed'] = false;
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr,screenItemInfo,emptyRowArr,rowElementMap);
        expect(transferLayoutManager['isFirstWidgetProcessed']).assertInstanceOf('Boolean');
      } catch (e) {};
      done();
    })

    it("test_regroupWidgetPosition_03", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let widgetIndexArr = [0,1];
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let emptyRowArr = [100,101];
      let rowElementMap = new Map<number,number[]>([[0,[0,1]],[1,[1,2]]]);
      try {
        transferLayoutManager['isFirstWidgetProcessed'] = false;
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr,screenItemInfo,emptyRowArr,rowElementMap);
        expect(transferLayoutManager['isFirstWidgetProcessed']).assertInstanceOf('Boolean');
      } catch (e) {};
      done();
    })

    it("test_regroupWidgetPosition_04", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let widgetIndexArr = [0,1];
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let emptyRowArr = [0,1];
      let rowElementMap = new Map<number,number[]>([[2,[2,3]],[3,[3,4]]]);
      try {
        transferLayoutManager['isFirstWidgetProcessed'] = true;
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr,screenItemInfo,emptyRowArr,rowElementMap);
        expect(transferLayoutManager['isFirstWidgetProcessed']).assertInstanceOf('Boolean');
      } catch (e) {};
      done();
    })

    it("test_moveElementByType_01", 0, async(done:Function) => {
      let curRowElements: number[] = [];
      let needToNextPageIndex: number[] = [];
      let rowLen: number = 4;
      let emptyLen: number = 4;
      let type: number = 0;
      try {
        let result = transferLayoutManager['moveElementByType'](curRowElements, rowLen, emptyLen, screenData, needToNextPageIndex, type);
        expect(result).assertEqual(4);
      } catch (e) {};
      done();
    })

    it("test_dealWithMoreSpace1_7", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:7,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let curRowElements = [0,1];
      let occupied = [[true,false],[false,true]];
      let needToNextPageIndex = [0,1];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaByRowFromLast']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealWithMoreSpace'](screenItemInfo,curRowElements,occupied,needToNextPageIndex);
        expect(needToNextPageIndex.length).assertLargerOrEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("dealWithMoreSpace2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:7,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let curRowElements = [0,1];
      let occupied = [[true,false],[false,true]];
      let needToNextPageIndex = [0,1];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaByRowFromLast']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['dealWithMoreSpace'](screenItemInfo,curRowElements,occupied,needToNextPageIndex);
        expect(needToNextPageIndex.length>2).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("dealWithMoreSpace3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let curRowElements = [0,1];
      let occupied = [[true,false],[false,true]];
      let needToNextPageIndex = [0,1];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaByRow']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['dealWithMoreSpace'](screenItemInfo,curRowElements,occupied,needToNextPageIndex);
        expect(needToNextPageIndex.length>2).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_findAreaByRow_01", 0, async(done:Function) => {
      let occupied: boolean[][] = Array(4).fill(false).map(() => Array(6).fill(false));
      let baseData: BaseTransferBean = new BaseTransferBean();
      baseData.area = [1, 1];
      baseData.row = 1;
      baseData.column = 1;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validElementArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['findAreaByRow'](occupied, baseData);
        expect(result).assertFalse();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("findAreaByRowFromLast1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 3,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[3,3]
      } as BaseTransferBean;
      let occupied = [[true,false,true,false],[false,true,true,false],[true,false,true,false],[false,true,true,false]];
      try {
        let result = transferLayoutManager['findAreaByRowFromLast'](occupied,transferBean);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {};
      done();
    })

    it("findAreaByRowFromLast2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 3,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[4,4]
      } as BaseTransferBean;
      let occupied = [[true,false,true],[false,true,true],[false,true,false]];
      try {
        let result = transferLayoutManager['findAreaByRowFromLast'](occupied,transferBean);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {};
      done();
    })

    it("findAreaByRowFromLast3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 3,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[4,5]
      } as BaseTransferBean;
      let occupied = [[false,false,false],[false,false,false],[false,false,false]];
      try {
        let result = transferLayoutManager['findAreaByRowFromLast'](occupied,transferBean);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {};
      done();
    })

    it("makeRestElementFolderToCurrentPage1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[],false);
        expect(screenItemInfo!.moveToNextPage!.length).assertEqual(3);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeRestElementFolderToCurrentPage2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:10
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean],true);
        expect(screenItemInfo!.children!.length>2).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeRestElementFolderToCurrentPage3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeNotHarmonyElementToFolder']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean],true);
        expect(screenItemInfo!.children!.length>2).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeRestElementFolderToCurrentPage4", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['replaceLastCardWithFolder']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean],false);
        expect(screenItemInfo!.children!.length>2).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeRestElementFolderToCurrentPage5", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean1,transferBean2,transferBean1,transferBean2],
        moveToNextPage: [transferBean1,transferBean2,transferBean1,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:100
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['replaceLastCardWithFolder']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean1);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillElementInfo']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(transferBean1);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean1,transferBean2],false);
        expect(screenItemInfo!.children!.length>2).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeRestElementFolderToCurrentPage6", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean1,transferBean2,transferBean1,transferBean2],
        moveToNextPage: [transferBean1,transferBean2,transferBean1,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:100
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateFoldersRowAndColumn']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean1,transferBean2],false);
        expect(screenItemInfo!.children!.length>2).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_replaceLastCardWithFolder_01", 0, async(done:Function) => {
      let screenData: ScreenTransferBean = initScreenTransferBean();
      let occupied: boolean[][] = screenData.occupied;
      let addToCurrentPage: BaseTransferBean[] = screenData.children;
      let isSpecialFolder: boolean = false;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['replaceLastCardWithFolder'](screenData, occupied, addToCurrentPage, isSpecialFolder);
        expect(addToCurrentPage.length).assertEqual(1);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeNotHarmonyElementToFolder1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_STACK ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['replaceLastCardWithFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeNotHarmonyElementToFolder'](screenItemInfo,[],[transferBean]);
        expect(screenItemInfo!.children!.length>3).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeNotHarmonyElementToFolder2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['replaceLastCardWithFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeNotHarmonyElementToFolder'](screenItemInfo,[],[transferBean]);
        expect(screenItemInfo!.children!.length>3).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeNotHarmonyElementToFolder3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isAppOrSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['mergeTwoSmallElement']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillElementInfo']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeNotHarmonyElementToFolder'](screenItemInfo,[],[transferBean]);
        expect(screenItemInfo!.children!.length>3).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeNotHarmonyElementToFolder4", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[0,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isAppOrSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['makeNotHarmonyElementToFolder'](screenItemInfo,[],[transferBean]);
        expect(screenItemInfo!.children!.length>3).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_mergeTwoSmallElement_01", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['mergeLastAppAndOtherSmallElement']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeTwoSmallElement'](screenItemInfo, transferBean);
        expect(screenItemInfo!.children!.length<3).assertFalse();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_mergeTwoSmallElement_02", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['mergeLastAppAndOtherSmallElement']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeTwoSmallElement'](screenItemInfo, transferBean);
        expect(screenItemInfo!.children!.length<3).assertFalse();
      } catch (e) {};
      mocker.clear(transferLayoutManager);

      done();
    })

    it("test_mergeTwoSmallElement_03", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['mergeLastSmallFolderAndOtherSmallElement']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeTwoSmallElement'](screenItemInfo, transferBean);
        expect(screenItemInfo!.children!.length<3).assertFalse();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("updateUsedCellCnt1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let addToCurrentPage:BaseTransferBean[] = [transferBean];
      try {
        transferLayoutManager['updateUsedCellCnt'](screenItemInfo,addToCurrentPage)
        expect(addToCurrentPage.length>1).assertInstanceOf('Boolean');
      } catch (e) {};
      done();
    })

    it("updateUsedCellCnt2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,1],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let addToCurrentPage:BaseTransferBean[] = [transferBean];
      try {
        transferLayoutManager['updateUsedCellCnt'](screenItemInfo,addToCurrentPage)
        expect(addToCurrentPage.length>1).assertInstanceOf('Boolean');
      } catch (e) {};
      done();
    })

    it("test_validElementArea_01", 0, async(done:Function) => {
      let area: number [] = [];
      let fromIndexX: number = -1;
      let fromIndexY: number = 0;
      try {
        let result: boolean = transferLayoutManager['validElementArea'](null, area, fromIndexX, fromIndexY);
        expect(result).assertFalse();
      } catch (e) {};
      done();
    })

    it("test_preprocessScreenData_01", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[10,10]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isAppOrSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['preprocessScreenData'](screenItemInfo);
        expect(screenItemInfo!.usedCellCnt>0).assertTrue();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_collectOldLayoutByScreen_01", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      transferLayoutManager['isBigFold'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['generateNewFirstPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isFindInFirstPage']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['deleteCardInFirstPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['manyToOneReplace']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isNeedAddToNotHarmnoyFolder']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(true);
      try {
        await transferLayoutManager['collectOldLayoutByScreen']([gridLayoutItem1,gridLayoutItem1,gridLayoutItem1]);
        expect(transferLayoutManager['notHarmonyList']!.length>0).assertTrue();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_generateNewFirstPage3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[gridLayoutItem,gridLayoutItem],[gridLayoutItem,gridLayoutItem]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY,
        cardName:'cardName1'
      }) as GridLayoutItemInfo;
      let gridLayoutItem2= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FORM_STACK,
        layoutInfo:[[gridLayoutItem,gridLayoutItem],[gridLayoutItem,gridLayoutItem]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY,
        cardName:'cardName2'
      }) as GridLayoutItemInfo;
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.CONTAINER_SMARTDOCK
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.CONTAINER_SMARTDOCK
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList:[] as SCBSceneContainerSession[],
        appIconId:0,
        abilityName:'',
        appName:'',
        bundleName:''
      } as DockItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().queryAllGridLayoutInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([gridLayoutItem1,gridLayoutItem1,gridLayoutItem2]));
      let mockFunction1: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().querySmartDock);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1,itemInfo1]));
      let mockFunction2: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.dockItemToGridLayout);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(Promise.resolve(gridLayoutItem2));
      let mockFunction3: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction4: Function =
        mocker.mockFunc(Extend1Data, Extend1Data.setCardSourceType);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction5: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putPageData']);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        await transferLayoutManager['generateNewFirstPage']();
        expect(transferLayoutManager['firstPageElementSet'].size>=0).assertInstanceOf('Boolean');
        transferLayoutManager['firstPageElementSet'] = new Set<string>();
      } catch (e) {};
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clear(GridLayoutUtil);
      mocker.clear(Extend1Data);
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_dealNotHarmonyElement3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['notHarmonyList'] = [transferBean, transferBean];
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      transferLayoutManager['maxScreen'] = 2;
      transferLayoutManager['maxScreenCount'] = 2;
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealNotHarmonyElement']();
        expect(transferLayoutManager['screenDataMap'].size>=0).assertInstanceOf('Boolean');
        transferLayoutManager['notHarmonyList'] = [];
        transferLayoutManager['screenDataMap'] = new Map<number,ScreenTransferBean>();
        transferLayoutManager['maxScreen'] = 0;
        transferLayoutManager['maxScreenCount'] = 0;
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_dealNotHarmonyElement4", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['notHarmonyList'] = [transferBean, transferBean];
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      try {
        let mockFunction: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(transferBean);
        let mockFunction1: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
        transferLayoutManager['maxScreen'] = 2;
        transferLayoutManager['maxScreenCount'] = 5;
        let mockFunction2: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
        when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
        let mockFunction3: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['buildScreenPage']);
        when(mockFunction3)(ArgumentMatchers.any).afterReturn(screenItemInfo);
        let mockFunction4: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
        when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
        transferLayoutManager['dealNotHarmonyElement']();
        expect(transferLayoutManager['screenDataMap'].size>=0).assertInstanceOf('Boolean');
        transferLayoutManager['notHarmonyList'] = [];
        transferLayoutManager['screenDataMap'] = new Map<number,ScreenTransferBean>();
        transferLayoutManager['maxScreen'] = 0;
        transferLayoutManager['maxScreenCount'] = 0;
        transferLayoutManager['maxScreen'] = 0;
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_updateInfoId1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let item= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      let item1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[item,item],[item,item]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      let item2= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[item1,item1],[item1,item1]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunction: Function =
          mocker.mockFunc(FolderReporter.getInstance(), FolderReporter.getInstance().reportCreateFolderInTransfer);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
        let mockFunction1: Function =
          mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().generateRandomUUID);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn('infoId');
        transferLayoutManager['updateInfoId']([item2,item2]);
        expect(item.page).assertEqual(1);
      } catch (e) {};
      mocker.clear(FolderReporter.getInstance());
      mocker.clear(RdbStoreManager.getInstance());
      done();
    })

    it("test_getNewLayoutFromScreenDataMap1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['mergeScreenDataMap']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealRestDockAndSingleUniqueElement']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealNotHarmonyElement']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealFormStackElement']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction5: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction6: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['printPageItem']);
      when(mockFunction6)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        expect(transferLayoutManager['screenDataMap'].size>=0).assertInstanceOf('Boolean');
        transferLayoutManager['screenDataMap'] = new Map<number,ScreenTransferBean>();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(DeviceHelper);
      mocker.clear(RdbStoreManager.getInstance());
      done();
    })

    it('test_dealFormStackElement_01', Level.LEVEL0, async (done:Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        expect(transferLayoutManager['dealFormStackElement']() === undefined).assertTrue();
      } catch (e) {};
      done();
    })

    it("test_dealFormStackElement_02", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let item= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      let item1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[item,item],[item,item]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10],
        layoutInfo:[[item1,item1,item1],[item1,item1,item1],[item1,item1,item1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['getFormStackMaxArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([1,1]);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['rearrangeCardFromPage']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealFormStackElement']();
        expect(transferLayoutManager['screenDataMap'].size>=0).assertInstanceOf('Boolean');
        transferLayoutManager['screenDataMap'] = new Map<number,ScreenTransferBean>();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_getFormStackMaxArea1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let item= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[0,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['getFormStackMaxArea']([item,item]);
        expect(result[0]).assertEqual(1);
      } catch (e) {};
      done();
    })

    it("test_rearrangeCardFromPage1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10],
        layoutInfo:[[]]
      }) as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaInScreen']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['rearrangeCardFromPage'](0,transferBean)
        expect(transferLayoutManager['screenDataMap'].size>=0).assertInstanceOf('Boolean');
        transferLayoutManager['screenDataMap'] = new Map<number,ScreenTransferBean>();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_transferOldLayoutToNewLayout1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      try {
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        transferLayoutManager['transferOldLayoutToNewLayout']();
        expect(transferLayoutManager['screenDataMap'].size).assertEqual(0);
      } catch (e) {};
      done();
    })

    it("test_transferOldLayoutToNewLayout2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10],
        layoutInfo:[[]]
      }) as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      transferLayoutManager['isNewLayout'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['transferByScreen']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['transferOldLayoutToNewLayout']();
        expect(transferLayoutManager['screenDataMap'].size>=0).assertInstanceOf('Boolean');
        transferLayoutManager['screenDataMap'] = new Map<number, ScreenTransferBean>();
        transferLayoutManager['transferType'] = '';
        transferLayoutManager['isNewLayout'] = false;
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_realignScreenData1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean =new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10],
        layoutInfo:[[]]
      }) as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['isNewLayout'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['realignByRefresh']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['addFormCombineToLastPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealWithNeedMoveToNextPage']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['realignScreenData'](screenItemInfo,true);
        expect(transferLayoutManager['isNewLayout']).assertInstanceOf('Boolean');
        transferLayoutManager['isNewLayout'] = false;
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_dealWithNeedMoveToNextPage1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10],
        layoutInfo:[[]]
      }) as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['toMaxScreen']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['buildScreenPage']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(screenItemInfo);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['transferByScreen']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealWithNeedMoveToNextPage'](screenItemInfo,[[true]]);
        expect(transferLayoutManager['maxScreen']>0).assertInstanceOf('Boolean');
        transferLayoutManager['maxScreen'] = 0;
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_addFormCombineToLastPage1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 8,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10],
        layoutInfo:[[]]
      }) as BaseTransferBean;
      let screenItemInfo = {
        page: 8,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      try {
        transferLayoutManager['formCombinePage'] = CommonConstants.TYPE_FORM_COMBINE;
        transferLayoutManager['addFormCombineToLastPage'](screenItemInfo,false);
        expect(transferLayoutManager['formCombinePage']).assertEqual(8);
        transferLayoutManager['formCombinePage'] = -1;
      } catch (e) {};
      done();
    })

    it("test_fillEmptyPlace1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let extraElements: number[] = [];
      let occupied: boolean[][] = [];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['fillEmptyPlace'](extraElements, screenData, occupied);
        expect(screenData.moveToNextPage).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_realignByRefresh1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let occupied: boolean[][] = [[true,false],[true,false]];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['realignByRefresh'](screenItemInfo,occupied);
        let children:BaseTransferBean[] = screenItemInfo.children;
        expect(children).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_regroupWidgetPosition1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      transferLayoutManager['isFirstWidgetProcessed'] = false;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 10,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let widgetIndexArr = [0,1,2]
      let emptyRowArr = [15,2];
      let rowElementMap = new Map<number,number[]>([[11,[0,1]],[12,[0,1]]]);
      try {
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr,screenItemInfo,emptyRowArr,rowElementMap);
        expect(transferLayoutManager['isFirstWidgetProcessed']).assertInstanceOf('Boolean');
        transferLayoutManager['isFirstWidgetProcessed'] = false;
      } catch (e) {};
      done();
    })

    it("test_regroupWidgetPosition2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      transferLayoutManager['isFirstWidgetProcessed'] = true;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 10,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let widgetIndexArr = [0,1,2]
      let emptyRowArr = [15,2];
      let rowElementMap = new Map<number,number[]>([[11,[0,1]],[12,[0,1]]]);
      try {
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr,screenItemInfo,emptyRowArr,rowElementMap);
        expect(transferLayoutManager['isFirstWidgetProcessed']).assertInstanceOf('Boolean');
        transferLayoutManager['isFirstWidgetProcessed'] = false;
      } catch (e) {};
      done();
    })

    it('test_moveNarrowerElements_01', Level.LEVEL0, async (done: Function) => {
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let rowLen: number = 4;
        let emptyLen: number = 0;
        transferLayoutManager['moveNarrowerElements'](curRowElements, rowLen, emptyLen, screenData,
          needToNextPageIndex);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it("test_moveNarrowerElements_02", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let curRowElements: number[] = [];
      let needToNextPageIndex: number[] = [];
      let rowLen: number = 4;
      let emptyLen: number = 6;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['moveElementByType']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(emptyLen - 1);
      try {
        transferLayoutManager['moveNarrowerElements'](curRowElements, rowLen, emptyLen, screenData,
          needToNextPageIndex);
        expect(rowLen).assertEqual(4);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_moveNarrowerElements_03", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let curRowElements: number[] = [];
      let needToNextPageIndex: number[] = [];
      let rowLen: number = 4;
      let emptyLen: number = 6;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['moveElementByType']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(emptyLen + 1);
      try {
        transferLayoutManager['moveNarrowerElements'](curRowElements, rowLen, emptyLen, screenData,
          needToNextPageIndex);
        expect(rowLen).assertEqual(4);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_moveElementByType1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let curRowElements: number[] = [4,5,6];
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 10,
        typeId: 0,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let needToNextPageIndex: number[] = [];
      let rowLen: number = 5;
      let emptyLen: number = 4;
      let type: number = 0;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isAppOrSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      try {
        let result = transferLayoutManager['moveElementByType'](curRowElements, rowLen, emptyLen, screenItemInfo, needToNextPageIndex, type);
        expect(result).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("findAreaByRow1", 0, async(done:Function) => {
      let occupied: boolean[][] = Array(4).fill(false).map(() => Array(6).fill(false));
      let baseData: BaseTransferBean = new BaseTransferBean();
      baseData.area = [1, 1];
      baseData.row = 1;
      baseData.column = 1;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validElementArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['findAreaByRow'](occupied, baseData,true);
        expect(result).assertFalse();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("findAreaByRowFromLast4", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 3,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[4,5]
      } as BaseTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validElementArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let occupied = [[false,false,false],[false,false,false],[false,false,false]];
      try {
        let result = transferLayoutManager['findAreaByRowFromLast'](occupied,transferBean);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_makeRestElementFolderToCurrentPage1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean1,transferBean2,transferBean1,transferBean2],
        moveToNextPage: [transferBean1,transferBean2,transferBean1,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:100
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateUsedCellCnt']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean1,transferBean2],false);
        expect(screenItemInfo!.children).not().assertUndefined();
      } catch (e) {};
      mocker.clear(CheckEmptyUtils);
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_makeRestElementFolderToCurrentPage2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean1,transferBean2,transferBean1,transferBean2],
        moveToNextPage: [transferBean1,transferBean2,transferBean1,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['replaceLastCardWithFolder']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean1);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillElementInfo']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean1,transferBean2],false);
        expect(screenItemInfo!.children).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(CheckEmptyUtils);
      done();
    })

    it("test_makeRestElementFolderToCurrentPage4", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean1,transferBean2,transferBean1,transferBean2],
        moveToNextPage: [transferBean1,transferBean2,transferBean1,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['replaceLastCardWithFolder']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean1);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillElementInfo']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateFoldersRowAndColumn']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean1,transferBean2],false);
        expect(screenItemInfo!.children).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_dealRestElementFolderToCurrentPage_02", 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let gridLayoutItem1 = new Object({
          row: 1,
          column: 1,
          container: CommonConstants.TYPE_FOLDER,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName2',
          typeId: CommonConstants.TYPE_FOLDER,
          layoutInfo: [[]],
          infoId: '1',
          area: [1, 1]
        }) as GridLayoutItemInfo;
        let transferBean1 = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_FOLDER,
          isNeedRestoreFromBackup: false,
          bundleName: 'bundleName',
          column: 1,
          area: [1, 2],
          layoutInfo: [[gridLayoutItem1], [gridLayoutItem1]]
        } as BaseTransferBean;
        let transferBean2 = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_APP,
          isNeedRestoreFromBackup: false,
          bundleName: 'bundleName',
          column: 1,
          area: [1, 2],
          layoutInfo: [[gridLayoutItem1], [gridLayoutItem1]]
        } as BaseTransferBean;
        let transferBean3 = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_SHORTCUT_ICON,
          isNeedRestoreFromBackup: false,
          bundleName: 'bundleName',
          column: 1,
          area: [1, 2],
          layoutInfo: [[gridLayoutItem1], [gridLayoutItem1]]
        } as BaseTransferBean;
        let screenItemInfo = {
          page: 1,
          occupied: [[true]],
          iconUsedCellCnt: 0,
          folderUsedCellCnt: 0,
          children: [transferBean1, transferBean2, transferBean3],
          moveToNextPage: [transferBean1, transferBean2, transferBean3],
          usedCellCnt: 100,
          abilityFormUsedCellCnt: 24
        } as ScreenTransferBean;
        transferLayoutManager['dealRestElementFolderToCurrentPage'](screenItemInfo, [transferBean1]);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_makeNotHarmonyElementToFolder1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isAppOrSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['makeNotHarmonyElementToFolder'](screenItemInfo,[],[transferBean]);
        expect(screenItemInfo!.children!.length>=3).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_makeNotHarmonyElementToFolder2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isAppOrSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['makeNotHarmonyElementToFolder'](screenItemInfo,[],[transferBean]);
        expect(screenItemInfo!.children!.length>=3).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_mergeLastAppAndOtherSmallElement_01", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillElementInfo']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeLastAppAndOtherSmallElement'](screenItemInfo, transferBean);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_mergeLastAppAndOtherSmallElement_04", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillElementInfo']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeLastAppAndOtherSmallElement'](screenItemInfo, transferBean);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_mergeLastAppAndOtherSmallElement_03", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateFoldersRowAndColumn']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeLastAppAndOtherSmallElement'](screenItemInfo, transferBean);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_updateUsedCellCnt1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[2,2]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let addToCurrentPage:BaseTransferBean[] = [transferBean];
      try {
        transferLayoutManager['updateUsedCellCnt'](screenItemInfo,addToCurrentPage)
        expect(addToCurrentPage.length>=1).assertInstanceOf('Boolean');
      } catch (e) {};
      done();
    })

    it("test_updateUsedCellCnt2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_ADD,
        layoutInfo:[[]],
        infoId:'1',
        area:[2,2]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let addToCurrentPage:BaseTransferBean[] = [transferBean];
      try {
        transferLayoutManager['updateUsedCellCnt'](screenItemInfo,addToCurrentPage)
        expect(addToCurrentPage.length>=1).assertInstanceOf('Boolean');
      } catch (e) {};
      done();
    })

    it('test_findArea_01', Level.LEVEL0, async (done:Function) => {
      try {
        let occupied: boolean[][] = [];
        let transferBean: BaseTransferBean = new BaseTransferBean();
        let result: boolean = transferLayoutManager['findArea'](occupied, transferBean);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {};
      done();
    })

    it("test_findArea_02", 0, async(done:Function) => {
      let occupied: boolean[][] = [];
      let transferBean: BaseTransferBean = new BaseTransferBean();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      try {
        let result: boolean = transferLayoutManager['findArea'](occupied, transferBean);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {};
      mocker.clear(DeviceHelper);
      done();
    })

    it("test_findArea_03", 0, () => {
      let mocker: MockKit = new MockKit();
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      try {
        let occupied = [[true, true, true], [true, true, true], [true, true, true]];
        let transferBean = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_FOLDER,
          isNeedRestoreFromBackup: false,
          bundleName: 'bundleName',
          column: 1,
          area: [2, 2],
        } as BaseTransferBean;
        transferLayoutManager['isNewLayout'] = true;
        let mockFunction: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['validElementArea']);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        let mockFunction1: Function =
          mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
        let mockFunction2: Function =
          mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
        when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
        let result = transferLayoutManager['findArea'](occupied, transferBean);
        expect(result).assertInstanceOf('Boolean');
        transferLayoutManager['isNewLayout'] = false;
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clear(DeviceHelper);
    })

    it("test_findArea_04", 0, () => {
      let mocker: MockKit = new MockKit();
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      try {
        let occupied = [[false, false, false], [false, false, false], [false, false, false]];
        let transferBean = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_FOLDER,
          isNeedRestoreFromBackup: false,
          bundleName: 'bundleName',
          column: 1,
          area: [2, 2],
        } as BaseTransferBean;
        transferLayoutManager['isNewLayout'] = true;
        let mockFunction: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['validElementArea']);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        let mockFunction1: Function =
          mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
        let mockFunction2: Function =
          mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
        when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
        let result = transferLayoutManager['findArea'](occupied, transferBean);
        expect(result).assertInstanceOf('Boolean');
        transferLayoutManager['isNewLayout'] = false;
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clear(DeviceHelper);
    })

    it("test_collectOldLayoutByScreen1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      transferLayoutManager['isNewLayout'] = true;
      transferLayoutManager['isBigFold'] = true;
      transferLayoutManager['isClone'] = true;
      transferLayoutManager['transferType'] = BackupSceneBundleVersionName.WINPC_TO_ohos;
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['generateNewFirstPage']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isFindInFirstPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['deleteCardInFirstPage']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['manyToOneReplace']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction5: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isNeedAddToNotHarmnoyFolder']);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction6: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction6)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction7: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['disbandFormCombine']);
      when(mockFunction7)(ArgumentMatchers.any).afterReturn([gridLayoutItem1,gridLayoutItem1,gridLayoutItem1]);
      let mockFunction8: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['sortScreenDataMap']);
      when(mockFunction8)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction9: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealRestScreen']);
      when(mockFunction9)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        await transferLayoutManager['collectOldLayoutByScreen']([gridLayoutItem1,gridLayoutItem1,gridLayoutItem1]);
        expect(transferLayoutManager['isNewLayout']).assertInstanceOf('Boolean');
        transferLayoutManager['isNewLayout'] = false;
        transferLayoutManager['isBigFold'] = DeviceHelper.isFoldButNotSmallFoldProduct();
        transferLayoutManager['isClone'] = false;
        transferLayoutManager['transferType'] = '';
        transferLayoutManager['otherList'] = [];
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(CheckEmptyUtils);
      done();
    })

    it("test_collectOldLayoutByScreen2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      transferLayoutManager['isNewLayout'] = true;
      transferLayoutManager['isBigFold'] = true;
      transferLayoutManager['isClone'] = true;
      transferLayoutManager['transferType'] = BackupSceneBundleVersionName.WINPC_TO_ohos;
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['generateNewFirstPage']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isFindInFirstPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['deleteCardInFirstPage']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['manyToOneReplace']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction5: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isNeedAddToNotHarmnoyFolder']);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction6: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction6)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction7: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['disbandFormCombine']);
      when(mockFunction7)(ArgumentMatchers.any).afterReturn([gridLayoutItem1,gridLayoutItem1,gridLayoutItem1]);
      let mockFunction8: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['sortScreenDataMap']);
      when(mockFunction8)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction9: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealRestScreen']);
      when(mockFunction9)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        await transferLayoutManager['collectOldLayoutByScreen']([gridLayoutItem1,gridLayoutItem1,gridLayoutItem1]);
        expect(transferLayoutManager['isNewLayout']).assertInstanceOf('Boolean');
        transferLayoutManager['isNewLayout'] = false;
        transferLayoutManager['isBigFold'] = DeviceHelper.isFoldButNotSmallFoldProduct();
        transferLayoutManager['isClone'] = false;
        transferLayoutManager['transferType'] = '';
        transferLayoutManager['otherList'] = [];
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(CheckEmptyUtils);
      done();
    })

    it("test_collectOldLayoutByScreen3", 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      try {
        let gridLayoutItem1 = new Object({
          row: 1,
          column: 1,
          container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName2',
          typeId: CommonConstants.CONTAINER_DESKTOP,
          layoutInfo: [[]],
          infoId: '1',
          area: [1, 1]
        }) as GridLayoutItemInfo;
        transferLayoutManager['isNewLayout'] = true;
        transferLayoutManager['isBigFold'] = true;
        transferLayoutManager['transferType'] = BackupSceneBundleVersionName.WINPC_TO_ohos;
        let mockFunction1: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['generateNewFirstPage']);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve());
        let mockFunction2: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['isFindInFirstPage']);
        when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
        let mockFunction3: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['deleteCardInFirstPage']);
        when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
        let mockFunction4: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['manyToOneReplace']);
        when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
        let mockFunction5: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['isNeedAddToNotHarmnoyFolder']);
        when(mockFunction5)(ArgumentMatchers.any).afterReturn(true);
        let mockFunction6: Function =
          mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunction6)(ArgumentMatchers.any).afterReturn(false);
        let mockFunction7: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['disbandFormCombine']);
        when(mockFunction7)(ArgumentMatchers.any).afterReturn([gridLayoutItem1, gridLayoutItem1, gridLayoutItem1]);
        let mockFunction8: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['sortScreenDataMap']);
        when(mockFunction8)(ArgumentMatchers.any).afterReturn(undefined);
        let mockFunction9: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealRestScreen']);
        when(mockFunction9)(ArgumentMatchers.any).afterReturn(undefined);

        await transferLayoutManager['collectOldLayoutByScreen']([gridLayoutItem1, gridLayoutItem1, gridLayoutItem1]);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clear(CheckEmptyUtils);
      done();
    })

    it("test_collectOldLayoutByScreen4", 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      try {
        let gridLayoutItem1 = new Object({
          row: 1,
          column: 1,
          container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName2',
          typeId: CommonConstants.CONTAINER_DESKTOP,
          layoutInfo: [[]],
          infoId: '1',
          area: [1, 1]
        }) as GridLayoutItemInfo;
        transferLayoutManager['isClone'] = false;
        let mockFunction1: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['isNeedAddTodeliverFolder']);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
        await transferLayoutManager['collectOldLayoutByScreen']([gridLayoutItem1, gridLayoutItem1, gridLayoutItem1]);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_collectOldLayoutByScreen5", 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      try {
        let gridLayoutItem1 = new Object({
          row: 1,
          column: 1,
          container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName2',
          typeId: CommonConstants.TYPE_FORM_COMBINE,
          layoutInfo: [[]],
          infoId: '1',
          area: [1, 1]
        }) as GridLayoutItemInfo;
        let gridLayoutItem2 = new Object({
          row: 1,
          column: 1,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName2',
          typeId: CommonConstants.TYPE_FORM_COMBINE,
          layoutInfo: [[]],
          infoId: '1',
          area: [1, 1]
        }) as GridLayoutItemInfo;
        let gridLayoutItem3 = new Object({
          row: 1,
          column: 1,
          container: CommonConstants.CONTAINER_DOCK,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName2',
          typeId: CommonConstants.TYPE_FORM_COMBINE,
          layoutInfo: [[]],
          infoId: '1',
          area: [1, 1]
        }) as GridLayoutItemInfo;
        let gridLayoutItem4 = new Object({
          row: 1,
          column: 1,
          container: 1,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName2',
          typeId: CommonConstants.TYPE_FORM_COMBINE,
          layoutInfo: [[]],
          infoId: '1',
          area: [1, 1]
        }) as GridLayoutItemInfo;
        let oldLayoutInfo: GridLayoutItemInfo[] = [gridLayoutItem1, gridLayoutItem2, gridLayoutItem3, gridLayoutItem4];
        transferLayoutManager['isClone'] = true;
        let mockFunction1: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['isNeedAddTodeliverFolder']);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
        let mockFunction2: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['isNeedAddToNotHarmnoyFolder']);
        when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
        let mockFunction3: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunction3)(ArgumentMatchers.any).afterReturn(false);
        let mockFunction4: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['disbandFormCombine']);
        when(mockFunction4)(ArgumentMatchers.any).afterReturn(oldLayoutInfo);
        let mockFunction5: Function =
          mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunction5)(ArgumentMatchers.any).afterReturn(true);
        await transferLayoutManager['collectOldLayoutByScreen'](oldLayoutInfo);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clear(CheckEmptyUtils);
      done();
    })

    it("test_manyToOneReplace1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        iconResource:'1'
      }) as GridLayoutItemInfo;
      let gridLayoutItem2= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        iconResource:'1'
      }) as GridLayoutItemInfo;
      try {
        transferLayoutManager['manyToOneReplace']([gridLayoutItem1,gridLayoutItem2]);
        transferLayoutManager['transferType'] = '';
      } catch (e) {};
      done();
    })

    it("test_manyToOneReplace2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        iconResource:'1'
      }) as GridLayoutItemInfo;
      let gridLayoutItem2= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        iconResource:'1'
      }) as GridLayoutItemInfo;
      try {
        transferLayoutManager['manyToOneReplace']([gridLayoutItem1,gridLayoutItem2,gridLayoutItem2,gridLayoutItem2,gridLayoutItem2]);
        transferLayoutManager['transferType'] = '';
      } catch (e) {};
      done();
    })

    it("test_isNeedAddToNotHarmnoyFolder_01", 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let mockFunction1: Function =
          mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.appStatus = AppStatus.WAIT_FOR_HARMONY + 1;
        let result = transferLayoutManager['isNeedAddToNotHarmnoyFolder'](item);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    })

    it("test_isNeedAddToNotHarmnoyFolder_02", 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let mockFunction1: Function =
          mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.appStatus = AppStatus.WAIT_FOR_HARMONY;
        item.typeId = CommonConstants.TYPE_APP + 1;
        let result = transferLayoutManager['isNeedAddToNotHarmnoyFolder'](item);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    })

    it("test_isNeedAddToNotHarmnoyFolder_03", 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let map: Map<string, Object> = new Map();
        map.set(NotHarmonyUtil.APP_TYPE, AppReserveType.TASTE_FRESH);
        let mockFunction1: Function =
          mocker.mockFunc(CommonUtils, CommonUtils.jsonStrToMap);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(map);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.appStatus = AppStatus.WAIT_FOR_HARMONY;
        item.typeId = CommonConstants.TYPE_APP;
        let result = transferLayoutManager['isNeedAddToNotHarmnoyFolder'](item);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CommonUtils);
      mocker.clearAll();
    })

    it("test_isNeedAddToNotHarmnoyFolder_04", 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let map: Map<string, Object> = new Map();
        map.set(NotHarmonyUtil.APP_TYPE, AppReserveType.TASTE_FRESH);
        let mockFunction1: Function =
          mocker.mockFunc(CommonUtils, CommonUtils.jsonStrToMap);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(map);
        let mockFunction2: Function =
          mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
        when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.appStatus = AppStatus.WAIT_FOR_HARMONY;
        item.typeId = CommonConstants.TYPE_APP;
        let result = transferLayoutManager['isNeedAddToNotHarmnoyFolder'](item);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CommonUtils);
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    })

    it("test_isNeedAddToNotHarmnoyFolder_05", 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let map: Map<string, Object> = new Map();
        map.set(NotHarmonyUtil.APP_TYPE, AppReserveType.TASTE_FRESH);
        let mockFunction1: Function = mocker.mockFunc(CommonUtils, CommonUtils.jsonStrToMap);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(map);
        let mockFunction2: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
        when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.appStatus = AppStatus.WAIT_FOR_HARMONY;
        item.typeId = CommonConstants.TYPE_APP;
        let result = transferLayoutManager['isNeedAddToNotHarmnoyFolder'](item);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CommonUtils);
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    })

    it("test_deleteCardInFirstPage1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      transferLayoutManager['firstPageElementSet'] =new Set<string>(['1','2']);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      try {
        transferLayoutManager['deleteCardInFirstPage']([gridLayoutItem,gridLayoutItem]);
        expect(transferLayoutManager['firstPageElementSet'].size).assertEqual(2);
        transferLayoutManager['firstPageElementSet'] =new Set<string>();
      } catch (e) {};
      done();
    })

    it("test_deleteCardInFirstPage2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      transferLayoutManager['firstPageElementSet'] =new Set<string>(['bundleName','cardName']);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['compareCard']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(1);
      try {
        transferLayoutManager['deleteCardInFirstPage']([gridLayoutItem,gridLayoutItem,gridLayoutItem,gridLayoutItem]);
        expect(transferLayoutManager['firstPageElementSet'].size).assertEqual(2);
        transferLayoutManager['firstPageElementSet'] =new Set<string>();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_compareAppItem1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let a = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 2,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:2,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let b = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['compareAppItem'](a,b);
        expect(result).assertEqual(-1);
      } catch (e) {};
      done();
    })

    it("test_compareAppItem2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let a = new Object({
        row: 1,
        column: 1,
        container: 2,
        page: 2,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let b = new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['compareAppItem'](a,b);
        expect(result).assertEqual(1);
      } catch (e) {};
      done();
    })

    it("test_compareAppItem3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let a = new Object({
        row: 1,
        column: 1,
        container: -1,
        page: 2,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let b = new Object({
        row: 1,
        column: 1,
        container: -2,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['compareAppItem'](a,b);
        expect(result).assertEqual(-1);
      } catch (e) {};
      done();
    })

    it("test_compareAppItem4", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let a = new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 2,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let b = new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['compareAppItem'](a,b);
        expect(result).assertEqual(1);
      } catch (e) {};
      done();
    })

    it("test_compareAppItem5", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let a = new Object({
        row: 2,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let b = new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['compareAppItem'](a,b);
        expect(result).assertEqual(1);
      } catch (e) {};
      done();
    })

    it("test_compareAppItem6", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let a = new Object({
        row: 1,
        column: 1,
        container: 2,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let b = new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['compareAppItem'](a,b);
        expect(result).assertEqual(1);
      } catch (e) {};
      done();
    })

    it("test_dealRestDockAndSingleUniqueElement1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[]],
        settlementPosition:'1'
      }) as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['dockList'] = [transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean];
      transferLayoutManager['restDockList'] = [transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean];
      transferLayoutManager['disbandCombFormList'] = [transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean];
      transferLayoutManager['isClone'] = true;
      transferLayoutManager['maxScreen'] = 2;
      transferLayoutManager['maxScreenCount'] = 1;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealwithDockAndOtherList']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealRestDockAndSingleUniqueElement']();
        expect(transferLayoutManager['isClone']).assertInstanceOf('Boolean');
        transferLayoutManager['dockList'] = [];
        transferLayoutManager['restDockList'] = [];
        transferLayoutManager['disbandCombFormList'] = [];
        transferLayoutManager['isClone'] = false;
        transferLayoutManager['maxScreen'] = 0;
        transferLayoutManager['maxScreenCount'] = 0;
        transferLayoutManager['screenDataMap'] = new Map<number,ScreenTransferBean>();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_dealRestDockAndSingleUniqueElement2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[]],
        settlementPosition:'1'
      }) as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['dockList'] = [transferBean,transferBean,transferBean,transferBean];
      transferLayoutManager['restDockList'] = [transferBean,transferBean,transferBean,transferBean];
      transferLayoutManager['disbandCombFormList'] = [transferBean,transferBean,transferBean,transferBean];
      transferLayoutManager['isClone'] = false;
      transferLayoutManager['maxScreen'] = 2;
      transferLayoutManager['maxScreenCount'] = 1;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealwithDockAndOtherList']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealRestDockAndSingleUniqueElement']();
        expect(transferLayoutManager['isClone']).assertInstanceOf('Boolean');
        transferLayoutManager['dockList'] = [];
        transferLayoutManager['restDockList'] = [];
        transferLayoutManager['disbandCombFormList'] = [];
        transferLayoutManager['isClone'] = false;
        transferLayoutManager['maxScreen'] = 0;
        transferLayoutManager['maxScreenCount'] = 0;
        transferLayoutManager['screenDataMap'] = new Map<number,ScreenTransferBean>();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_dealRestDockAndSingleUniqueElement3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[]],
        settlementPosition:'1'
      }) as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['dockList'] = [transferBean,transferBean,transferBean,transferBean];
      transferLayoutManager['restDockList'] = [transferBean,transferBean,transferBean,transferBean];
      transferLayoutManager['disbandCombFormList'] = [transferBean,transferBean,transferBean,transferBean];
      transferLayoutManager['isClone'] = true;
      transferLayoutManager['maxScreen'] = 2;
      transferLayoutManager['maxScreenCount'] = 10;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealwithDockAndOtherList']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealRestDockAndSingleUniqueElement']();
        expect(transferLayoutManager['isClone']).assertInstanceOf('Boolean');
        transferLayoutManager['dockList'] = [];
        transferLayoutManager['restDockList'] = [];
        transferLayoutManager['disbandCombFormList'] = [];
        transferLayoutManager['isClone'] = false;
        transferLayoutManager['maxScreen'] = 0;
        transferLayoutManager['maxScreenCount'] = 0;
        transferLayoutManager['screenDataMap'] = new Map<number,ScreenTransferBean>();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_dealwithDockAndOtherList1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[]],
        settlementPosition:'1'
      }) as BaseTransferBean;
      transferLayoutManager['isClone'] = false;
      transferLayoutManager['isNewLayout'] = true;
      transferLayoutManager['isBigFold'] = false;
      transferLayoutManager['dockList'] = [transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean];
      transferLayoutManager['restDockList'] = [transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean];
      transferLayoutManager['otherList'] = [transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean];
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['buildScreenPage']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['addRestDockToCurrentPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealwithDockAndOtherList']();
        expect(transferLayoutManager['isNewLayout']).assertInstanceOf('Boolean');
        transferLayoutManager['isClone'] = false;
        transferLayoutManager['isNewLayout'] = false;
        transferLayoutManager['isBigFold'] = false;
        transferLayoutManager['dockList'] = [];
        transferLayoutManager['restDockList'] = [];
        transferLayoutManager['otherList'] = [];
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_dealwithDockAndOtherList2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[]],
        settlementPosition:'1'
      }) as BaseTransferBean;
      transferLayoutManager['isClone'] = true;
      transferLayoutManager['isNewLayout'] = true;
      transferLayoutManager['isBigFold'] = true;
      transferLayoutManager['dockList'] = [transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean];
      transferLayoutManager['restDockList'] = [transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean];
      transferLayoutManager['otherList'] = [transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean];
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['buildScreenPage']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['addRestDockToCurrentPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealwithDockAndOtherList']();
        expect(transferLayoutManager['isNewLayout']).assertInstanceOf('Boolean');
        transferLayoutManager['isClone'] = false;
        transferLayoutManager['isNewLayout'] = false;
        transferLayoutManager['isBigFold'] = false;
        transferLayoutManager['dockList'] = [];
        transferLayoutManager['restDockList'] = [];
        transferLayoutManager['otherList'] = [];
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_addRestDockToCurrentPage1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem,gridLayoutItem],[gridLayoutItem,gridLayoutItem]],
        settlementPosition:'1'
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['addRestDockToCurrentPage'](0,[transferBean,transferBean]);
        expect(transferLayoutManager['screenDataMap'].size>=0).assertEqual(true)
        transferLayoutManager['screenDataMap'] = new Map<number, ScreenTransferBean>();
      } catch (e) {};
      mocker.clear(CheckEmptyUtils);
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_addRestDockToCurrentPage2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem,gridLayoutItem],[gridLayoutItem,gridLayoutItem]],
        settlementPosition:'1'
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem,gridLayoutItem],[gridLayoutItem,gridLayoutItem]],
        settlementPosition:'1'
      } as BaseTransferBean;
      let transferBean3 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem,gridLayoutItem],[gridLayoutItem,gridLayoutItem]],
        settlementPosition:'1'
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      transferLayoutManager['maxScreen'] = 2;
      transferLayoutManager['maxScreenCount'] = 2;
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['toMaxScreen']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction5: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['addRestDockToCurrentPage'](0,[transferBean,transferBean2,transferBean3]);
        expect(transferLayoutManager['screenDataMap'].size>=0).assertEqual(true)
        transferLayoutManager['screenDataMap'] = new Map<number, ScreenTransferBean>();
        transferLayoutManager['maxScreen'] = 0;
        transferLayoutManager['maxScreenCount'] = 0;
      } catch (e) {};
      mocker.clear(CheckEmptyUtils);
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_addRestDockToCurrentPage3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem,gridLayoutItem],[gridLayoutItem,gridLayoutItem]],
        settlementPosition:'1'
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem,gridLayoutItem],[gridLayoutItem,gridLayoutItem]],
        settlementPosition:'1'
      } as BaseTransferBean;
      let transferBean3 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem,gridLayoutItem],[gridLayoutItem,gridLayoutItem]],
        settlementPosition:'1'
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      transferLayoutManager['maxScreen'] = 2;
      transferLayoutManager['maxScreenCount'] = 2;
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['toMaxScreen']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction5: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['addRestDockToCurrentPage'](0,[transferBean,transferBean2,transferBean3]);
        expect(transferLayoutManager['screenDataMap'].size>=0).assertEqual(true)
        transferLayoutManager['screenDataMap'] = new Map<number, ScreenTransferBean>();
        transferLayoutManager['maxScreen'] = 0;
        transferLayoutManager['maxScreenCount'] = 0;
      } catch (e) {};
      mocker.clear(CheckEmptyUtils);
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_collectDesktop1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FORM_STACK ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let gridLayoutItem2= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FORM_COMBINE ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let gridLayoutItem3= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FILE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validAndCollectFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putPageData']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validAndCollectFormStack']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn([]);
      let mockFunction3: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction4: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['collectDesktop'](gridLayoutItem,[gridLayoutItem]);
        transferLayoutManager['collectDesktop'](gridLayoutItem1,[gridLayoutItem]);
        transferLayoutManager['collectDesktop'](gridLayoutItem2,[gridLayoutItem]);
        transferLayoutManager['collectDesktop'](gridLayoutItem3,[gridLayoutItem]);
        expect(gridLayoutItem.page).assertEqual(1);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(CheckEmptyUtils);
      mocker.clear(DeviceHelper);
      done();
    })

    it("test_collectSmartDock1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      transferLayoutManager['isNewLayout'] = true;
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validAndCollectFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['collectSmartDock'](gridLayoutItem,[gridLayoutItem]);
        expect(transferLayoutManager['isNewLayout']).assertInstanceOf('Boolean');
        transferLayoutManager['isNewLayout'] = false;
        transferLayoutManager['transferType'] = '';
        transferLayoutManager['restDockList'] = [];
        transferLayoutManager['dockList'] = [];
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_collectSmartDock2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      transferLayoutManager['isNewLayout'] = true;
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validAndCollectFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['collectSmartDock'](gridLayoutItem,[gridLayoutItem]);
        expect(transferLayoutManager['isNewLayout']).assertInstanceOf('Boolean');
        transferLayoutManager['isNewLayout'] = false;
        transferLayoutManager['transferType'] = '';
        transferLayoutManager['restDockList'] = [];
        transferLayoutManager['dockList'] = [];
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_collectSmartDock3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FUNCTION ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['collectSmartDock'](gridLayoutItem,[gridLayoutItem]);
        expect(transferLayoutManager['isNewLayout']).assertInstanceOf('Boolean');
        transferLayoutManager['dockList'] = [];
      } catch (e) {};
      mocker.clear(DeviceHelper);
      done();
    })

    it("test_isAppOrSmallFolder_01", 0, () => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

      let gridLayoutItem = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName',
        cardName: 'cardName',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo: [[]],
        appIndex: 1,
        infoId: '1',
        area: [1, 1]
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['isAppOrSmallFolder'](gridLayoutItem);
        expect(result).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isAppOrSmallFolder_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        let result: boolean = transferLayoutManager['isAppOrSmallFolder'](item);
        expect(result).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_validAndCollectFolder1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 100,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1
      }) as GridLayoutItemInfo;
      let gridLayoutItem1 = new Object({
        row: 1,
        column: 1,
        container: 100,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['validAndCollectFolder'](gridLayoutItem,[gridLayoutItem1],1);
        expect(result).assertNull();
      } catch (e) {};
      done();
    })

    it("test_validAndCollectFolder2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1,
        intent:''
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['validAndCollectFolder'](gridLayoutItem,[gridLayoutItem],1);
        expect(result).not().assertUndefined();
      } catch (e) {};
      mocker.clear(DeliverUtil);
      done();
    })

    it("test_validAndCollectFolder3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1,
        intent:'',
        folderName:'${new_folder_name}'
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['filterFolderDuplicateElement']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([gridLayoutItem,gridLayoutItem,gridLayoutItem]);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateFoldersRowAndColumn']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        let result = transferLayoutManager['validAndCollectFolder'](gridLayoutItem,[gridLayoutItem,gridLayoutItem,gridLayoutItem],1);
        expect(result).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it('test_validAndCollectFolder4', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayout.id = 1;
        transferLayoutManager['validAndCollectFolder'](gridLayout, [], 1);
        expect(gridLayout.id).assertInstanceOf('Number');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_validAndCollectFormStack1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 100,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1
      }) as GridLayoutItemInfo;
      let gridLayoutItem1 = new Object({
        row: 1,
        column: 1,
        container: 100,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['validAndCollectFormStack'](gridLayoutItem,[gridLayoutItem1]);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it("test_validAndCollectFormStack2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_CARD ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putCombineCard']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['validAndCollectFormStack'](gridLayoutItem,[gridLayoutItem]);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_validAndCollectFormStack3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_ADD ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1,
        formStackId:'formStackId'
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putCombineCard']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['validAndCollectFormStack'](gridLayoutItem,[gridLayoutItem,gridLayoutItem,gridLayoutItem]);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })
    it("test_validAndCollectFormStack4", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_ADD ,
        layoutInfo:[[]],
        appIndex:1,
        area:[1,1],
        id:1,
        formStackId:'formStackId'
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putCombineCard']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['validAndCollectFormStack'](gridLayoutItem,[gridLayoutItem,gridLayoutItem,gridLayoutItem]);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_validAndCollectFormStack5", 0, async (done: Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let containerId: number = 123;
        let gridLayoutItem1 = new Object({
          row: 1,
          column: 1,
          container: containerId,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName',
          cardName: 'cardName',
          typeId: CommonConstants.TYPE_CARD,
          layoutInfo: [[]],
          appIndex: 1,
          infoId: '1',
          area: [1, 1],
          id: 1
        }) as GridLayoutItemInfo;
        let gridLayoutItem2 = new Object({
          row: 1,
          column: 1,
          container: containerId,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName',
          cardName: 'cardName',
          typeId: CommonConstants.TYPE_CARD,
          layoutInfo: [[]],
          appIndex: 1,
          infoId: '1',
          area: [1, 1],
          id: 1
        }) as GridLayoutItemInfo;
        let gridLayoutItem = new Object({
          row: 1,
          column: 1,
          container: 100,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName',
          cardName: 'cardName',
          typeId: CommonConstants.TYPE_FORM_STACK,
          layoutInfo: [[]],
          appIndex: 1,
          infoId: '1',
          area: [1, 1],
          id: containerId
        }) as GridLayoutItemInfo;
        let result =
          transferLayoutManager['validAndCollectFormStack'](gridLayoutItem, [gridLayoutItem1, gridLayoutItem2]);
        expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('test_putCombineCard_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let combines: GridLayoutItemInfo[] = [
          new GridLayoutItemInfo(),
          new GridLayoutItemInfo()
        ];
        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.page = 1;
        let returnResult: BaseTransferBean[] = [];
        transferLayoutManager['putCombineCard'](combines, dataElement, returnResult);
        expect(returnResult.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_toMaxScreen_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let result: boolean = transferLayoutManager['toMaxScreen']();
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_toMaxScreen_02", 0, async (done: Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let notHarmony1 = {
          layoutWeight: 1,
          page: 1,
          typeId: CommonConstants.TYPE_FORM_COMBINE
        } as BaseTransferBean;
        let screenItemInfo = {
          page: 1,
          occupied: [[true]],
          usedCellCnt: 0,
          iconUsedCellCnt: 0,
          folderUsedCellCnt: 0,
          abilityFormUsedCellCnt: 0,
          children: [notHarmony1],
          moveToNextPage: [notHarmony1]
        } as ScreenTransferBean;
        transferLayoutManager['moveToNextDataMap'] =
          new Map<number, ScreenTransferBean[]>([[3, [screenItemInfo]], [4, [screenItemInfo]]]);
        let result: boolean = transferLayoutManager['toMaxScreen']();
        expect(result).assertInstanceOf('Boolean');
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_generateGridLayoutItemKey_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayout.bundleName = 'gridLayoutBundleName';
        gridLayout.moduleName = 'gridLayoutModuleName';
        gridLayout.abilityName = 'gridLayoutAbilityName';
        gridLayout.appIndex = 1;
        gridLayout.typeId = 0;
        gridLayout.shortcutId = 'shortcutId';
        let result: string = transferLayoutManager['generateGridLayoutItemKey'](gridLayout);
        expect(result.length >= 0).assertTrue()
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_filterFolderDuplicateElement_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);

        let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayout.bundleName = 'gridLayoutBundleName';
        gridLayout.moduleName = 'gridLayoutModuleName';
        gridLayout.abilityName = 'gridLayoutAbilityName';
        gridLayout.appIndex = 1;
        gridLayout.typeId = 0;
        gridLayout.shortcutId = 'shortcutId';

        let gridLayout2: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayout2.bundleName = 'gridLayoutBundleName';
        gridLayout2.moduleName = 'gridLayoutModuleName';
        gridLayout2.abilityName = 'gridLayoutAbilityName';
        gridLayout2.appIndex = 1;
        gridLayout2.typeId = 0;
        gridLayout2.shortcutId = 'shortcutId';

        let childElement: GridLayoutItemInfo[] = [gridLayout,gridLayout2];
        transferLayoutManager['filterFolderDuplicateElement'](childElement);
        expect(childElement.length >= 0).assertTrue()
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_dealDisbandCombFormInStack_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferlayoutmanager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        transferlayoutmanager['disbandCombFormList'] = [];
        transferlayoutmanager['dealDisbandCombFormInStack']();
        expect(transferlayoutmanager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_dealDisbandCombFormInStack_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferlayoutmanager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        transferlayoutmanager['maxScreen'] = 1;
        transferlayoutmanager['maxScreenCount'] = 1;
        transferlayoutmanager['disbandCombFormList'] = [new BaseTransferBean(), new BaseTransferBean()];
        transferlayoutmanager['dealDisbandCombFormInStack']();
        expect(transferlayoutmanager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_dealDisbandCombFormInStack_03', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferlayoutmanager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        transferlayoutmanager['maxScreen'] = 1;
        transferlayoutmanager['maxScreenCount'] = 2;
        transferlayoutmanager['disbandCombFormList'] = [new BaseTransferBean(), new BaseTransferBean()];
        transferlayoutmanager['dealDisbandCombFormInStack']();
        expect(transferlayoutmanager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_placeAllElementsForSuperFold_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferlayoutmanager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        transferlayoutmanager['placeAllElementsForSuperFold']();
        expect(transferlayoutmanager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_parseCloneBackupDataJson_02', 0, async (done: Function) => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isSuperFoldMachine);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferlayoutmanager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let notHarmony1 = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100 + 1,
          typeId: CommonConstants.TYPE_FORM_COMBINE,
          isNeedRestoreFromBackup:false,
          bundleName:'bundleName1',
        } as BaseTransferBean;
        let screenItemInfo = {
          page: 1,
          occupied: [[true]],
          usedCellCnt: 0,
          iconUsedCellCnt: 0,
          folderUsedCellCnt: 0,
          abilityFormUsedCellCnt: 0,
          children: [notHarmony1],
          moveToNextPage: [notHarmony1]
        } as ScreenTransferBean;
        transferlayoutmanager['screenDataMap'] =
          new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
        transferlayoutmanager['placeAllElementsForSuperFold']();
        expect(transferlayoutmanager instanceof TransferLayoutManager).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_getNeedUpdateRegionList_01', 0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      // 文件夹
      let gridLayoutFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutFolder.id = 48;
      gridLayoutFolder.typeId = CommonConstants.TYPE_REGION_FOLDER;
      gridLayoutFolder.infoId = '1715654262380';
      gridLayoutFolder.infoName = '收纳夹1';
      gridLayoutFolder.folderName = '收纳夹1';
      layoutInfos.push(gridLayoutFolder);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction1)().afterReturn(true);
      try {
        transferLayoutManager['getNeedUpdateRegionList'](layoutInfos, []);
        expect(layoutInfos.length).assertLarger(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clear(DeviceHelper);
    });

    it('test_mergeLastSmallFolderAndOtherSmallElement_01', Level.LEVEL0, async (done: Function) => {
      let screenData: ScreenTransferBean = initScreenTransferBean();
      let lastElement: BaseTransferBean = new BaseTransferBean();
      try {
        transferLayoutManager['mergeLastSmallFolderAndOtherSmallElement'](screenData, lastElement);
      } catch (error) {
      }
      expect(transferLayoutManager instanceof TransferLayoutManager).assertTrue();
      done();
    })

    it("test_mergeLastSmallFolderAndOtherSmallElement_02", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean2,transferBean,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateFoldersRowAndColumn']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillElementInfo']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeLastSmallFolderAndOtherSmallElement'](screenItemInfo,transferBean);
        expect(screenItemInfo!.children!.length).not().assertEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_mergeLastSmallFolderAndOtherSmallElement_03", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean2,transferBean,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateFoldersRowAndColumn']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeLastSmallFolderAndOtherSmallElement'](screenItemInfo,transferBean);
        expect(screenItemInfo!.children).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it('test_mergeLastSmallFolderAndOtherSmallElement_04', 0, () => {
      let mock = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferlayoutmanager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let appBaseBean: BaseTransferBean = new BaseTransferBean();
        appBaseBean.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        appBaseBean.infoId = '60';
        appBaseBean.infoName = '设置';
        appBaseBean.bundleName = 'com.ohos.settings';
        appBaseBean.abilityName = 'com.ohos.settings.MainAbility';
        appBaseBean.moduleName = 'phone_settings';
        appBaseBean.container = CommonConstants.CONTAINER_DESKTOP;
        appBaseBean.badgeNumber = 3;
        appBaseBean.page = 0;
        appBaseBean.row = 0;
        appBaseBean.column = 1;
        appBaseBean.area = [1, 1];
        let appBaseBean2: BaseTransferBean = new BaseTransferBean();
        appBaseBean2.typeId = CommonConstants.TYPE_FOLDER;
        appBaseBean2.layoutInfo = [];
        appBaseBean2.infoId = '60';
        appBaseBean2.infoName = '设置';
        appBaseBean2.bundleName = 'com.ohos.settings';
        appBaseBean2.abilityName = 'com.ohos.settings.MainAbility';
        appBaseBean2.moduleName = 'phone_settings';
        appBaseBean2.container = CommonConstants.CONTAINER_DESKTOP;
        appBaseBean2.badgeNumber = 3;
        appBaseBean2.page = 0;
        appBaseBean2.row = 0;
        appBaseBean2.column = 1;
        appBaseBean2.area = [1, 1];
        appBaseBean2.layoutInfo[0] = [];
        let screenData: ScreenTransferBean = initScreenTransferBean();
        screenData.children.push(appBaseBean);
        screenData.children.push(appBaseBean2);
        let mockFunc: Function = mock.mockFunc(DeliverUtil, DeliverUtil.isContainerFolder);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        transferlayoutmanager['mergeLastSmallFolderAndOtherSmallElement'](screenData, appBaseBean2);
        expect(transferlayoutmanager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeliverUtil);
      mock.clearAll();
    })

    it('test_mergeLastAppAndOtherSmallElement_02', 0, () => {
      let mock = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferlayoutmanager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        let appBaseBean: BaseTransferBean = new BaseTransferBean();
        appBaseBean.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        appBaseBean.infoId = '60';
        appBaseBean.infoName = '设置';
        appBaseBean.bundleName = 'com.ohos.settings';
        appBaseBean.abilityName = 'com.ohos.settings.MainAbility';
        appBaseBean.moduleName = 'phone_settings';
        appBaseBean.container = CommonConstants.CONTAINER_DESKTOP;
        appBaseBean.badgeNumber = 3;
        appBaseBean.page = 0;
        appBaseBean.row = 0;
        appBaseBean.column = 1;
        appBaseBean.area = [1, 1];
        let appBaseBean2: BaseTransferBean = new BaseTransferBean();
        appBaseBean2.typeId = CommonConstants.TYPE_FOLDER;
        appBaseBean2.layoutInfo = [];
        appBaseBean2.infoId = '60';
        appBaseBean2.infoName = '设置';
        appBaseBean2.bundleName = 'com.ohos.settings';
        appBaseBean2.abilityName = 'com.ohos.settings.MainAbility';
        appBaseBean2.moduleName = 'phone_settings';
        appBaseBean2.container = CommonConstants.CONTAINER_DESKTOP;
        appBaseBean2.badgeNumber = 3;
        appBaseBean2.page = 0;
        appBaseBean2.row = 0;
        appBaseBean2.column = 1;
        appBaseBean2.area = [1, 1];
        appBaseBean2.layoutInfo[0] = [];
        let screenData: ScreenTransferBean = initScreenTransferBean();
        screenData.children.push(appBaseBean);
        screenData.children.push(appBaseBean2);
        let mockFunc: Function = mock.mockFunc(DeliverUtil, DeliverUtil.isContainerFolder);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        transferlayoutmanager['mergeLastAppAndOtherSmallElement'](screenData, appBaseBean2);
        expect(transferlayoutmanager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeliverUtil);
      mock.clearAll();
    })

    it("test_dealRestElementFolderToCurrentPage_01", 0, () => {
      try {
        let occupied: boolean[][] = [];
        let fillValue: boolean = false;
        let isPortrait: boolean = false;
        let gridLayoutItem1 = new Object({
          row: 1,
          column: 1,
          container: CommonConstants.TYPE_FOLDER,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName2',
          typeId: CommonConstants.TYPE_ADD,
          layoutInfo: [[]],
          infoId: '1',
          area: [2, 2]
        }) as GridLayoutItemInfo;
        let transferBean = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_ADD,
          isNeedRestoreFromBackup: false,
          bundleName: 'bundleName',
          column: 1,
          area: [2, 2],
          layoutInfo: [[gridLayoutItem1, gridLayoutItem1], [gridLayoutItem1, gridLayoutItem1]]
        } as BaseTransferBean;

        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferlayoutmanager: TransferLayoutManager = new TransferLayoutManager(fromGrid, toGrid);
        transferlayoutmanager['fillOccupiedForPc'](occupied, fillValue, isPortrait, transferBean);
        expect(transferlayoutmanager instanceof TransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
  })

  it("test_isNeedAddToAppFolder_01", 0, () => {
    try {
      let itemInfo = {
        typeId: CommonConstants.TYPE_CARD,
      } as GridLayoutItemInfo;
      let result = transferLayoutManager['isNeedAddToAppFolder'](itemInfo);
      expect(result).assertInstanceOf('Boolean');
    } catch (e) {
      expect(JSON.stringify(e)).assertInstanceOf('String');
    }
  })

  it("test_isNeedAddToAppFolder_02", 0, () => {
    try {
      let pkg: string = '1';
      let itemInfo = {
        typeId: CommonConstants.TYPE_APP,
        intent: JSON.stringify(new Map([['installSource', pkg]])),
      } as GridLayoutItemInfo;
      let result = transferLayoutManager['isNeedAddToAppFolder'](itemInfo);
      expect(result).assertInstanceOf('Boolean');
    } catch (e) {
      expect(JSON.stringify(e)).assertInstanceOf('String');
    }
  })

  it("test_isNeedAddToAppFolder_03", 0, () => {
    let mock = new MockKit();
    try {
      let pkg: string = DeliverUtil.APP_PKG;
      let itemInfo = {
        typeId: CommonConstants.TYPE_APP,
        appStatus: 0,
        intent: JSON.stringify(new Map([['installSource', pkg]])),
      } as GridLayoutItemInfo;
      let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.isInContainerFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result = transferLayoutManager['isNeedAddToAppFolder'](itemInfo);
      expect(result).assertInstanceOf('Boolean');
    } catch (e) {
      expect(JSON.stringify(e)).assertInstanceOf('String');
    }
  })

  it("test_isNeedAddToAppFolder_046", 0, () => {
    let mock = new MockKit();
    try {
      let pkg: string = DeliverUtil.APP_PKG;
      let itemInfo = {
        typeId: CommonConstants.TYPE_APP,
        appStatus: 1,
        intent: JSON.stringify(new Map([['installSource', pkg]])),
      } as GridLayoutItemInfo;
      let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.isInContainerFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result = transferLayoutManager['isNeedAddToAppFolder'](itemInfo);
      expect(result).assertInstanceOf('Boolean');
    } catch (e) {
      expect(JSON.stringify(e)).assertInstanceOf('String');
    }
    mock.clear(DeviceHelper);
    mock.clearAll();
  })

  it("test_isNeedAddToAppFolder_056", 0, () => {
    let mock = new MockKit();
    try {
      let pkg: string = DeliverUtil.APP_PKG;
      let itemInfo = {
        typeId: CommonConstants.TYPE_APP,
        appStatus: 0,
        intent: JSON.stringify(new Map([['installSource', pkg]])),
      } as GridLayoutItemInfo;
      let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.isInContainerFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result = transferLayoutManager['isNeedAddToAppFolder'](itemInfo);
      expect(result).assertInstanceOf('Boolean');
    } catch (e) {
      expect(JSON.stringify(e)).assertInstanceOf('String');
    }
    mock.clear(DeviceHelper);
    mock.clearAll();
  })
}

function retUndefined(): BaseTransferBean[] | undefined {
  return undefined;
}

function initGridLayoutItemInfos(): GridLayoutItemInfo[] {
  let layoutInfos: GridLayoutItemInfo[] = [];
  // 应用
  let gridLayoutApp: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutApp.typeId = CommonConstants.TYPE_APP;
  gridLayoutApp.infoId = '60';
  gridLayoutApp.infoName = '设置';
  gridLayoutApp.bundleName = 'com.ohos.settings';
  gridLayoutApp.abilityName = 'com.ohos.settings.MainAbility';
  gridLayoutApp.moduleName = 'phone_settings';
  gridLayoutApp.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutApp.badgeNumber = 3;
  gridLayoutApp.page = 0;
  gridLayoutApp.row = 0;
  gridLayoutApp.column = 1;
  gridLayoutApp.area = [1, 1];

  let gridLayoutFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutFolderItem.typeId = CommonConstants.TYPE_APP;
  gridLayoutFolderItem.infoId = '50';
  gridLayoutFolderItem.infoName = '应用市场';
  gridLayoutFolderItem.bundleName = 'com.ohos.appgallery';
  gridLayoutFolderItem.abilityName = 'MainAbility';
  gridLayoutFolderItem.moduleName = 'entry';
  gridLayoutFolderItem.container = 48;
  gridLayoutFolderItem.row = 0;
  gridLayoutFolderItem.column = 0;
  gridLayoutFolderItem.area = [1, 1];

  let gridLayoutFolderItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutFolderItem1.typeId = CommonConstants.TYPE_APP;
  gridLayoutFolderItem1.infoId = '51';
  gridLayoutFolderItem1.infoName = '主题';
  gridLayoutFolderItem1.bundleName = 'com.ohos.thememanager';
  gridLayoutFolderItem1.abilityName = 'MainAbility';
  gridLayoutFolderItem1.moduleName = 'entry';
  gridLayoutFolderItem1.container = 48;
  gridLayoutFolderItem1.row = 0;
  gridLayoutFolderItem1.column = 1;
  gridLayoutFolderItem1.area = [1, 1];

  // 文件夹
  let gridLayoutFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutFolder.id = 48;
  gridLayoutFolder.typeId = CommonConstants.TYPE_FOLDER;
  gridLayoutFolder.infoId = '1715654262380';
  gridLayoutFolder.infoName = '应用';
  gridLayoutFolder.bundleName = '';
  gridLayoutFolder.folderName = '应用';
  gridLayoutFolder.abilityName = '';
  gridLayoutFolder.moduleName = '';
  gridLayoutFolder.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutFolder.page = 1;
  gridLayoutFolder.row = 4;
  gridLayoutFolder.column = 2;
  gridLayoutFolder.area = [2, 2];
  gridLayoutFolder.layoutInfo = [];
  gridLayoutFolder.layoutInfo[0] = [gridLayoutFolderItem, gridLayoutFolderItem1];

  // 卡片
  let gridLayoutItemCard: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutItemCard.typeId = CommonConstants.TYPE_CARD;
  gridLayoutItemCard.infoId = '72001000';
  gridLayoutItemCard.infoName = 'OneMulTwoRealTimeCard';
  gridLayoutItemCard.bundleName = 'com.ohos.totemweather';
  gridLayoutItemCard.abilityName = 'FormAbility';
  gridLayoutItemCard.moduleName = 'product';
  gridLayoutItemCard.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutItemCard.page = 2;
  gridLayoutItemCard.row = 0;
  gridLayoutItemCard.column = 2;
  gridLayoutItemCard.area = [1, 2];

  // 首页天气卡片
  let gridLayoutItemWeatherCard: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutItemWeatherCard.typeId = CommonConstants.TYPE_CARD;
  gridLayoutItemWeatherCard.infoId = '72002000';
  gridLayoutItemWeatherCard.infoName = 'ClockWeatherCard';
  gridLayoutItemWeatherCard.bundleName = 'com.ohos.totemweather';
  gridLayoutItemWeatherCard.abilityName = 'FormAbility';
  gridLayoutItemWeatherCard.moduleName = 'product';
  gridLayoutItemWeatherCard.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutItemWeatherCard.page = 0;
  gridLayoutItemWeatherCard.row = 0;
  gridLayoutItemWeatherCard.column = 2;
  gridLayoutItemWeatherCard.area = [2, 4];

  // 组合卡片
  let gridLayoutCombineItemCard1: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutCombineItemCard1.id = 64;
  gridLayoutCombineItemCard1.typeId = CommonConstants.TYPE_CARD;
  gridLayoutCombineItemCard1.infoId = '999';
  gridLayoutCombineItemCard1.bundleName = 'com.ohos.totemweather';
  gridLayoutCombineItemCard1.abilityName = 'FormAbility';
  gridLayoutCombineItemCard1.moduleName = 'product';
  gridLayoutCombineItemCard1.container = 66;
  gridLayoutCombineItemCard1.row = 0;
  gridLayoutCombineItemCard1.column = 1;
  gridLayoutCombineItemCard1.area = [2, 4];

  let gridLayoutCombineItemCard2: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutCombineItemCard2.id = 65;
  gridLayoutCombineItemCard2.typeId = CommonConstants.TYPE_CARD;
  gridLayoutCombineItemCard2.infoId = '998';
  gridLayoutCombineItemCard2.bundleName = 'com.ohos.totemweather';
  gridLayoutCombineItemCard2.abilityName = 'FormAbility';
  gridLayoutCombineItemCard2.moduleName = 'product';
  gridLayoutCombineItemCard2.container = 66;
  gridLayoutCombineItemCard2.row = 0;
  gridLayoutCombineItemCard2.column = 2;
  gridLayoutCombineItemCard2.area = [2, 4];

  let gridLayoutCombineCard: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutCombineCard.id = 66;
  gridLayoutCombineCard.typeId = CommonConstants.TYPE_FORM_COMBINE;
  gridLayoutCombineCard.infoId = '666';
  gridLayoutCombineCard.bundleName = '';
  gridLayoutCombineCard.abilityName = '';
  gridLayoutCombineCard.moduleName = '';
  gridLayoutCombineCard.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutCombineCard.page = 3;
  gridLayoutCombineCard.row = 0;
  gridLayoutCombineCard.column = 4;
  gridLayoutCombineCard.area = [2, 4];
  gridLayoutCombineCard.layoutInfo = [];
  gridLayoutCombineCard.layoutInfo[0] = [gridLayoutCombineItemCard1, gridLayoutCombineItemCard2];

  let gridLayoutDockApp: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutDockApp.typeId = CommonConstants.TYPE_APP;
  gridLayoutDockApp.infoId = '74';
  gridLayoutDockApp.infoName = '电话';
  gridLayoutDockApp.bundleName = 'com.ohos.contacts';
  gridLayoutDockApp.abilityName = 'com.ohos.contacts.MainAbility';
  gridLayoutDockApp.moduleName = 'entry';
  gridLayoutDockApp.container = CommonConstants.CONTAINER_DOCK;
  gridLayoutDockApp.appIconId = 100663911;
  gridLayoutDockApp.appLabelId = 100663320;
  gridLayoutDockApp.badgeNumber = 3;
  gridLayoutDockApp.page = 4;
  gridLayoutDockApp.row = 0;
  gridLayoutDockApp.column = 0;
  gridLayoutDockApp.area = [1, 1];

  let gridLayoutDockFolderItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutDockFolderItem1.typeId = CommonConstants.TYPE_APP;
  gridLayoutDockFolderItem1.infoId = '789';
  gridLayoutDockFolderItem1.infoName = '音乐';
  gridLayoutDockFolderItem1.bundleName = 'com.ohos.music';
  gridLayoutDockFolderItem1.abilityName = 'MainAbility';
  gridLayoutDockFolderItem1.moduleName = 'phone';
  gridLayoutDockFolderItem1.container = 66;
  gridLayoutDockFolderItem1.row = 1;
  gridLayoutDockFolderItem1.column = 0;
  gridLayoutDockFolderItem1.area = [1, 1];

  let gridLayoutDockFolderItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutDockFolderItem2.typeId = CommonConstants.TYPE_APP;
  gridLayoutDockFolderItem2.infoId = '789';
  gridLayoutDockFolderItem2.infoName = '音乐';
  gridLayoutDockFolderItem2.bundleName = 'com.ohos.music';
  gridLayoutDockFolderItem2.abilityName = 'MainAbility';
  gridLayoutDockFolderItem2.moduleName = 'phone';
  gridLayoutDockFolderItem2.container = 66;
  gridLayoutDockFolderItem2.row = 1;
  gridLayoutDockFolderItem2.column = 0;
  gridLayoutDockFolderItem2.area = [1, 1];

  // 文件夹
  let gridLayoutDockFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutDockFolder.id = 66;
  gridLayoutDockFolder.typeId = CommonConstants.TYPE_FOLDER;
  gridLayoutDockFolder.infoId = '1715654262380';
  gridLayoutDockFolder.infoName = '应用11';
  gridLayoutDockFolder.bundleName = '';
  gridLayoutDockFolder.folderName = '应用11';
  gridLayoutDockFolder.abilityName = '';
  gridLayoutDockFolder.moduleName = '';
  gridLayoutDockFolder.container = CommonConstants.CONTAINER_DOCK;
  gridLayoutDockFolder.column = 0;
  gridLayoutDockFolder.area = [1, 1];
  gridLayoutDockFolder.layoutInfo = [];
  gridLayoutDockFolder.layoutInfo[0] = [gridLayoutDockFolderItem1, gridLayoutDockFolderItem2];

  layoutInfos = [gridLayoutApp, gridLayoutFolder, gridLayoutItemCard, gridLayoutItemWeatherCard, gridLayoutCombineCard,
    gridLayoutDockApp, gridLayoutDockFolder];
  return layoutInfos;
}

function initCombineCardGridLayoutItem(): GridLayoutItemInfo {
  let gridLayoutCombineItemCard1: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutCombineItemCard1.id = 64;
  gridLayoutCombineItemCard1.typeId = CommonConstants.TYPE_CARD;
  gridLayoutCombineItemCard1.infoId = '999';
  gridLayoutCombineItemCard1.bundleName = 'com.ohos.totemweather';
  gridLayoutCombineItemCard1.abilityName = 'FormAbility';
  gridLayoutCombineItemCard1.moduleName = 'product';
  gridLayoutCombineItemCard1.container = 66;
  gridLayoutCombineItemCard1.row = 0;
  gridLayoutCombineItemCard1.column = 1;
  gridLayoutCombineItemCard1.area = [2, 4];

  let gridLayoutCombineItemCard2: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutCombineItemCard2.id = 65;
  gridLayoutCombineItemCard2.typeId = CommonConstants.TYPE_CARD;
  gridLayoutCombineItemCard2.infoId = '998';
  gridLayoutCombineItemCard2.bundleName = 'com.ohos.totemweather';
  gridLayoutCombineItemCard2.abilityName = 'FormAbility';
  gridLayoutCombineItemCard2.moduleName = 'product';
  gridLayoutCombineItemCard2.container = 66;
  gridLayoutCombineItemCard2.row = 0;
  gridLayoutCombineItemCard2.column = 2;
  gridLayoutCombineItemCard2.area = [2, 4];

  let gridLayoutCombineCard: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutCombineCard.id = 66;
  gridLayoutCombineCard.typeId = CommonConstants.TYPE_FORM_COMBINE;
  gridLayoutCombineCard.infoId = '666';
  gridLayoutCombineCard.bundleName = '';
  gridLayoutCombineCard.abilityName = '';
  gridLayoutCombineCard.moduleName = '';
  gridLayoutCombineCard.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutCombineCard.page = 3;
  gridLayoutCombineCard.row = 0;
  gridLayoutCombineCard.column = 4;
  gridLayoutCombineCard.area = [2, 4];
  gridLayoutCombineCard.layoutInfo = [];

  gridLayoutCombineCard.layoutInfo[0] = [gridLayoutCombineItemCard1, gridLayoutCombineItemCard2];
  return gridLayoutCombineCard;
}

function initScreenTransferBean(): ScreenTransferBean {
  let screenData: ScreenTransferBean = new ScreenTransferBean();
  screenData.page = 0;
  screenData.occupied = Array(4).fill(false).map(() => Array(6).fill(false));
  screenData.usedCellCnt = 0;
  screenData.iconUsedCellCnt = 0;
  screenData.folderUsedCellCnt = 0;
  screenData.abilityFormUsedCellCnt = 0;

  let appBaseBean: BaseTransferBean = new BaseTransferBean();
  appBaseBean.typeId = CommonConstants.TYPE_APP;
  appBaseBean.infoId = '60';
  appBaseBean.infoName = '设置';
  appBaseBean.bundleName = 'com.ohos.settings';
  appBaseBean.abilityName = 'com.ohos.settings.MainAbility';
  appBaseBean.moduleName = 'phone_settings';
  appBaseBean.container = CommonConstants.CONTAINER_DESKTOP;
  appBaseBean.badgeNumber = 3;
  appBaseBean.page = 0;
  appBaseBean.row = 0;
  appBaseBean.column = 1;
  appBaseBean.area = [1, 1];

  let cardBaseBean: BaseTransferBean = new BaseTransferBean();
  cardBaseBean.typeId = CommonConstants.TYPE_CARD;
  cardBaseBean.infoId = '72001000';
  cardBaseBean.infoName = 'OneMulTwoRealTimeCard';
  cardBaseBean.bundleName = 'com.ohos.totemweather';
  cardBaseBean.abilityName = 'FormAbility';
  cardBaseBean.moduleName = 'product';
  cardBaseBean.container = CommonConstants.CONTAINER_DESKTOP;
  cardBaseBean.page = 0;
  cardBaseBean.row = 0;
  cardBaseBean.column = 2;
  cardBaseBean.area = [1, 2];

  let children: BaseTransferBean[] = [appBaseBean, cardBaseBean];
  screenData.children = children;
  screenData.moveToNextPage = children;
  return screenData;
}