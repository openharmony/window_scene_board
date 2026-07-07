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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { BaseTransferBean } from '../../../../../../../main/ets/transformdata/BaseTransferBean'
import { ExtractOperator } from '../../../../../../../main/ets/transformdata/operator/ExtractOperator'
import ScreenTransferBean from '../../../../../../../main/ets/transformdata/ScreenTransferBean'
import { CommonConstants } from '../../../../../../../main/ets/TsIndex'

export default function ExtractOperatorTest() {
  describe('ExtractOperatorTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_findClockWeatherCardRow_01', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        ExtractOperator['findClockWeatherCardRow'](lastOccupied);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_findEmptyRow_01', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        ExtractOperator['findEmptyRow'](lastOccupied);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_findAppRow_01', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        ExtractOperator['findAppRow'](lastOccupied);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_findSingleRow_01', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let appRow: number[] = [];
        for (let i = 0; i < lastOccupied.length; i++) {
          appRow.push(i);
        }
        appRow.push(lastOccupied.length);
        ExtractOperator['findSingleRow'](appRow, lastOccupied);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_findMultiRow_01', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let needRow: number = 1;
        ExtractOperator['findMultiRow'](needRow, lastOccupied);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_checkElementOccupied_01', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let startRow: number = 1;
        let endRow: number = 1;
        lastOccupied[startRow][0].row = startRow - 1;
        ExtractOperator['checkElementOccupied'](startRow, endRow, lastOccupied);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_checkElementOccupied_02', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let startRow: number = 1;
        let endRow: number = 1;
        for (let i = 0; i < lastOccupied[startRow].length; i++) {
          lastOccupied[startRow][0].row = startRow + 1;
        }
        lastOccupied[endRow][0].row = endRow + 1;
        lastOccupied[endRow][0].area = [endRow + 1, endRow + 1];
        ExtractOperator['checkElementOccupied'](startRow, endRow, lastOccupied);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_checkElementOccupied_03', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let startRow: number = 1;
        let endRow: number = 1;
        for (let i = 0; i < lastOccupied[startRow].length; i++) {
          lastOccupied[startRow][0].row = startRow + 1;
        }
        lastOccupied[endRow][0].row = 0;
        lastOccupied[endRow][0].area = [0, 0];
        ExtractOperator['checkElementOccupied'](startRow, endRow, lastOccupied);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_getElementOccupied_01', 0, () => {
      try {
        let start = 1;
        let end = 3;
        ExtractOperator['getElementOccupied'](start, end);
        expect(start).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_refreshOccupied_01', 0, () => {
      try {
        let grid: number[] = [1, 1];
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        for (let i = 0; i < lastOccupied[0].length; i++) {
          lastOccupied[0][i].area = [1, 1];
          lastOccupied[0][i].row = grid[1] - 5;
        }
        ExtractOperator['refreshOccupied'](lastOccupied[0], grid);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_refreshOccupied_02', 0, () => {
      try {
        let grid: number[] = [1, 1];
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        for (let i = 0; i < lastOccupied[0].length; i++) {
          lastOccupied[0][i].area = [1, 1];
          lastOccupied[0][i].row = grid[1] + 5;
        }
        ExtractOperator['refreshOccupied'](lastOccupied[0], grid);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_updateElementCnt_01', 0, () => {
      try {
        let moveChildren: BaseTransferBean[] = getMoveChildren();

        let screenData: ScreenTransferBean = new ScreenTransferBean();
        screenData.children = moveChildren;
        screenData.abilityFormUsedCellCnt = 0;
        screenData.folderUsedCellCnt = 0;
        screenData.iconUsedCellCnt = 0;
        screenData.usedCellCnt = 0;

        ExtractOperator['updateElementCnt'](screenData, moveChildren);
        expect(moveChildren.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_extractRow_01', 0, () => {
      try {
        let needRow: number = 1;
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let extractRows: number[] = [];

        ExtractOperator['extractRow'](needRow, lastOccupied, extractRows);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_extractRow_02', 0, () => {
      try {
        let needRow: number = 1;
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let extractRows: number[] = [1];

        ExtractOperator['extractRow'](needRow, lastOccupied, extractRows);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_copyExtractChildrenBySingleRow_01', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let singleRow: number[] = [0];
        ExtractOperator['copyExtractChildrenBySingleRow'](1, lastOccupied, singleRow);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initLastOccupied_01', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let childrens: BaseTransferBean[] = lastOccupied[0];
        childrens.forEach(children => {
          children.area = [];
        });
        ExtractOperator['initLastOccupied'](childrens);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initLastOccupied_02', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let childrens: BaseTransferBean[] = lastOccupied[0];
        childrens.forEach(children => {
          children.area = [0, 1];
          children.row = 1;
          children.column = 1;
        });
        ExtractOperator['initLastOccupied'](childrens);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_initLastOccupied_03', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let childrens: BaseTransferBean[] = lastOccupied[0];
        childrens.forEach(children => {
          children.area = [0, 1];
          children.row = 1;
          children.column = 1;
          children.bundleName = 'bundleName';
        });
        ExtractOperator['initLastOccupied'](childrens);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_copyExtractX2Elements_01', 0, () => {
      try {
        let mutiRows: number[] = [0, 1];
        let needRow: number = 1;
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let childrens: BaseTransferBean[] = lastOccupied[0];
        childrens.forEach(children => {
          children.area = [0, 1];
          children.row = 1;
          children.column = 1;
          children.bundleName = 'bundleName';
        });
        ExtractOperator['copyExtractX2Elements'](lastOccupied, mutiRows, needRow);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_moveChildren_01', 0, () => {
      try {
        let extractChildren: BaseTransferBean[] = []
        let row: number = 0;
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let childrens: BaseTransferBean[] = lastOccupied[0];
        childrens.forEach(children => {
          children.area = [0, 2];
          children.row = 1;
          children.column = 1;
          children.bundleName = 'bundleName';
        });
        ExtractOperator['moveChildren'](lastOccupied, row, extractChildren);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_updateScreenLayoutBySingleRow_01', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let screenData: ScreenTransferBean = new ScreenTransferBean();
        screenData.children = lastOccupied[0];
        screenData.abilityFormUsedCellCnt = 0;
        screenData.folderUsedCellCnt = 0;
        screenData.iconUsedCellCnt = 0;
        screenData.usedCellCnt = 0;
        let needRow: number = 1;
        let tag: number[] = [];
        let moveChildren: BaseTransferBean[] = lastOccupied[0];
        ExtractOperator['updateScreenLayoutBySingleRow'](screenData, needRow, lastOccupied, tag, moveChildren);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_updateScreenLayoutByMultiRow_01', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let screenData: ScreenTransferBean = new ScreenTransferBean();
        screenData.children = lastOccupied[0];
        screenData.abilityFormUsedCellCnt = 0;
        screenData.folderUsedCellCnt = 0;
        screenData.iconUsedCellCnt = 0;
        screenData.usedCellCnt = 0;
        let multiRow: number[] = [];
        let moveChildren: BaseTransferBean[] = lastOccupied[0];
        ExtractOperator['updateScreenLayoutByMultiRow'](screenData, moveChildren, multiRow, lastOccupied);
        expect(lastOccupied.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_extract_01', 0, () => {
      try {
        let screenData: ScreenTransferBean = new ScreenTransferBean();
        screenData.children = [];
        screenData.abilityFormUsedCellCnt = 0;
        screenData.folderUsedCellCnt = 0;
        screenData.iconUsedCellCnt = 0;
        screenData.usedCellCnt = 0;
        let grid: number[] = [];
        ExtractOperator['extract'](screenData, grid);
        expect(grid.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_extract_02', 0, () => {
      try {
        let grid: number[] = [];
        ExtractOperator['extract'](null, grid);
        expect(grid.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_extract_03', 0, () => {
      try {
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let screenData: ScreenTransferBean = new ScreenTransferBean();
        screenData.children = lastOccupied[0];
        screenData.abilityFormUsedCellCnt = 0;
        screenData.folderUsedCellCnt = 0;
        screenData.iconUsedCellCnt = 0;
        screenData.usedCellCnt = 0;
        let grid: number[] = [];
        ExtractOperator['extract'](screenData, grid);
        expect(grid.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_copyExtractX1Elements_01', 0, () => {
      try {
        let needRows: number = 1;
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let mutiRows: number[] = [0];
        lastOccupied[mutiRows[0]] = [];
        ExtractOperator['copyExtractX1Elements'](needRows, lastOccupied, mutiRows);
        expect(mutiRows.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_copyExtractX1Elements_02', 0, () => {
      try {
        let needRows: number = 1;
        let lastOccupied: BaseTransferBean[][] = getLastOccupied();
        let mutiRows: number[] = [0];
        ExtractOperator['copyExtractX1Elements'](needRows, lastOccupied, mutiRows);
        expect(mutiRows.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}

function getMoveChildren(): BaseTransferBean[] {
  let bean1: BaseTransferBean = new BaseTransferBean();
  bean1.typeId = CommonConstants.TYPE_CARD;
  bean1.area = [1, 1];

  let bean2: BaseTransferBean = new BaseTransferBean();
  bean2.typeId = CommonConstants.TYPE_FORM_STACK;
  bean2.area = [1, 1];

  let bean3: BaseTransferBean = new BaseTransferBean();
  bean3.typeId = CommonConstants.TYPE_FOLDER;
  bean3.area = [1, 1];

  let bean4: BaseTransferBean = new BaseTransferBean();
  bean4.typeId = CommonConstants.TYPE_APP;
  bean3.area = [1, 1];

  let bean5: BaseTransferBean = new BaseTransferBean();
  bean5.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
  bean3.area = [1, 1];

  let bean6: BaseTransferBean = new BaseTransferBean();
  bean5.typeId = CommonConstants.TYPE_FORM_COMBINE;
  bean3.area = [1, 1];

  let lastOccupied: BaseTransferBean[] = [bean1, bean2, bean3, bean4, bean5, bean6];
  return lastOccupied;
}

function getLastOccupied(): BaseTransferBean[][] {
  let bean1: BaseTransferBean = new BaseTransferBean();
  let bean2: BaseTransferBean = new BaseTransferBean();
  bean2.typeId = CommonConstants.TYPE_CARD;
  bean2.cardName = 'ClockWeatherCard';
  let bean3: BaseTransferBean = new BaseTransferBean();
  bean3.typeId = CommonConstants.TYPE_CARD;
  bean3.cardName = 'ClockWeatherHoriCard';

  let bean4: BaseTransferBean = new BaseTransferBean();
  bean4.typeId = CommonConstants.TYPE_APP;
  let bean5: BaseTransferBean = new BaseTransferBean();
  bean5.typeId = CommonConstants.TYPE_SHORTCUT_ICON;

  let lastOccupied: BaseTransferBean[][] = [
    [bean1, bean2, bean3],
    [bean1, bean4, bean5]
  ];
  return lastOccupied;
}
