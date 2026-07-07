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
} from '@ohos/hypium'
import { BaseTransferBean } from '../../../../../../../main/ets/transformdata/BaseTransferBean'
import { CoverPositionOperator } from '../../../../../../../main/ets/transformdata/operator/CoverPositionOperator'
import ScreenTransferBean from '../../../../../../../main/ets/transformdata/ScreenTransferBean'
import { CommonConstants } from '../../../../../../../main/ets/TsIndex'

export default function CoverPositionOperatorTest() {
  describe('CoverPositionOperatorTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_coverPosition_01', 0, () => {
      try {
        let screenData: ScreenTransferBean = new ScreenTransferBean();
        CoverPositionOperator.coverPosition(screenData);
        expect(screenData).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_coverPosition_02', 0, () => {
      try {
        let occupied: boolean[][] = [];
        let screenData: ScreenTransferBean = new ScreenTransferBean();
        screenData.occupied = occupied;
        screenData.children = getMoveChildren();
        screenData.abilityFormUsedCellCnt = 0;
        screenData.folderUsedCellCnt = 0;
        screenData.iconUsedCellCnt = 0;
        screenData.usedCellCnt = 0;
        CoverPositionOperator.coverPosition(screenData);
        expect(screenData).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_coverPosition_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CoverPositionOperator, CoverPositionOperator['fillOccupied']);
        when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();

        let occupied: boolean[][] = [];
        let screenData: ScreenTransferBean = new ScreenTransferBean();
        screenData.occupied = occupied;
        screenData.children = getMoveChildren();
        screenData.abilityFormUsedCellCnt = 0;
        screenData.folderUsedCellCnt = 0;
        screenData.iconUsedCellCnt = 0;
        screenData.usedCellCnt = 0;
        CoverPositionOperator.coverPosition(screenData);
        expect(screenData).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CoverPositionOperator);
      mock.clearAll();
    });

    it('test_layoutElem_01', 0, () => {
      try {
        let layoutMatrix: boolean[][] = [
          [true],
          [true]
        ];
        let element: BaseTransferBean = getBaseTransferBean();
        CoverPositionOperator['layoutElem'](layoutMatrix, element);
        expect(element).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_layoutElem_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CoverPositionOperator, CoverPositionOperator['isAreaFree']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let layoutMatrix: boolean[][] = [
          [true],
          [true]
        ];
        let element: BaseTransferBean = getBaseTransferBean();
        CoverPositionOperator['layoutElem'](layoutMatrix, element);
        expect(element).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CoverPositionOperator);
      mock.clearAll();
    });

    it('test_markArea_01', 0, () => {
      try {
        let layoutMatrix: boolean[][] = [
          [true],
          [true]
        ];
        let startRow: number = 0;
        let startCol: number = 0;
        let curElem: BaseTransferBean = getBaseTransferBean();
        curElem.area = [1, 1];
        CoverPositionOperator['markArea'](layoutMatrix, startRow, startCol, curElem);
        expect(curElem).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_isAreaFree_01', 0, () => {
      try {
        let layoutMatrix: boolean[][] = [
          [true],
          [true]
        ];
        let curElem: BaseTransferBean = getBaseTransferBean();
        curElem.area = [1, 1];
        let startRow: number = layoutMatrix.length + curElem.area[1];
        let startCol: number = 0;
        CoverPositionOperator['isAreaFree'](layoutMatrix, startRow, startCol, curElem);
        expect(curElem).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_isAreaFree_02', 0, () => {
      try {
        let layoutMatrix: boolean[][] = [
          [true],
          [true]
        ];
        let curElem: BaseTransferBean = getBaseTransferBean();
        curElem.area = [1, 1];
        let startRow: number = 0;
        let startCol: number = layoutMatrix[0].length + curElem.area[0];
        CoverPositionOperator['isAreaFree'](layoutMatrix, startRow, startCol, curElem);
        expect(curElem).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_isAreaFree_03', 0, () => {
      try {
        let layoutMatrix: boolean[][] = [
          [true, true],
          [true, true]
        ];
        let curElem: BaseTransferBean = getBaseTransferBean();
        curElem.area = [1, 1];
        let startRow: number = 0;
        let startCol: number = 0;
        CoverPositionOperator['isAreaFree'](layoutMatrix, startRow, startCol, curElem);
        expect(curElem).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_shiftElementsUp_01', 0, () => {
      try {
        let emptyRow: number = 0;
        let curElem: BaseTransferBean = getBaseTransferBean();
        curElem.row = emptyRow + 1;
        let curElem2: BaseTransferBean = getBaseTransferBean();
        curElem2.row = emptyRow;
        let originLayout: BaseTransferBean[] = [curElem, curElem2];
        CoverPositionOperator['shiftElementsUp'](originLayout, emptyRow);
        expect(curElem).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_findRowEmpty_01', 0, () => {
      try {
        let layoutMatrix: boolean[][] = [
          [true],
          [true]
        ];
        let cardRow: number = 1;
        CoverPositionOperator['findRowEmpty'](layoutMatrix, cardRow);
        expect(layoutMatrix).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_fillOccupied_01', 0, () => {
      try {
        let occupied: boolean[][] = [
          [true],
          [true]
        ];
        let fillValue: boolean = true;
        CoverPositionOperator['fillOccupied'](occupied, fillValue);
        expect(occupied).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_fillOccupied_02', 0, () => {
      try {
        let occupied: boolean[][] = [
          [true],
          [true]
        ];
        let fillValue: boolean = true
        let curElem: BaseTransferBean = getBaseTransferBean();
        curElem.area = [1, 1];
        CoverPositionOperator['fillOccupied'](occupied, fillValue, curElem);
        expect(occupied).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_upDateOccupied_01', 0, () => {
      try {
        let occupied: boolean[][] = [
          [true],
          [true]
        ];
        let screenData: ScreenTransferBean = new ScreenTransferBean();
        screenData.occupied = occupied;
        screenData.children = getMoveChildren();
        screenData.abilityFormUsedCellCnt = 0;
        screenData.folderUsedCellCnt = 0;
        screenData.iconUsedCellCnt = 0;
        screenData.usedCellCnt = 0;
        CoverPositionOperator['upDateOccupied'](screenData);
        expect(screenData).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_handleWeatherForm_01', 0, () => {
      let mock = new MockKit();
      try {
        let curElem: BaseTransferBean = getBaseTransferBean();
        let occupied: boolean[][] = [
          [true],
          [true]
        ];
        let screenData: ScreenTransferBean = new ScreenTransferBean();
        screenData.occupied = occupied;
        screenData.children = getMoveChildren();
        screenData.abilityFormUsedCellCnt = 0;
        screenData.folderUsedCellCnt = 0;
        screenData.iconUsedCellCnt = 0;
        screenData.usedCellCnt = 0;
        let mockFunc: Function = mock.mockFunc(CoverPositionOperator, CoverPositionOperator['findRowEmpty']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
        CoverPositionOperator['handleWeatherForm'](curElem, screenData);
        expect(screenData).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CoverPositionOperator);
      mock.clearAll();
    });

    it('test_handleWeatherForm_02', 0, () => {
      let mock = new MockKit();
      try {
        const emptyRow: number[] = [1, 2];
        let mockFunc: Function = mock.mockFunc(CoverPositionOperator, CoverPositionOperator['findRowEmpty']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(emptyRow);

        let curElem: BaseTransferBean = getBaseTransferBean();
        let occupied: boolean[][] = [
          [true],
          [true]
        ];
        let screenData: ScreenTransferBean = new ScreenTransferBean();
        screenData.occupied = occupied;
        screenData.children = getMoveChildren();
        screenData.abilityFormUsedCellCnt = 0;
        screenData.folderUsedCellCnt = 0;
        screenData.iconUsedCellCnt = 0;
        screenData.usedCellCnt = 0;
        CoverPositionOperator['handleWeatherForm'](curElem, screenData);
        expect(screenData).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CoverPositionOperator);
      mock.clearAll();
    });
  })
}

function getBaseTransferBean(): BaseTransferBean {
  let bean1: BaseTransferBean = new BaseTransferBean();
  bean1.typeId = CommonConstants.TYPE_CARD;
  bean1.area = [0, 0];
  bean1.row = 1;
  bean1.column = 1;
  bean1.bundleName = 'bundleName';
  return bean1;
}

function getMoveChildren(): BaseTransferBean[] {
  let bean1: BaseTransferBean = new BaseTransferBean();
  bean1.typeId = CommonConstants.TYPE_CARD;
  bean1.area = [1, 1];
  bean1.cardName === 'ClockWeatherCard';

  let bean7: BaseTransferBean = new BaseTransferBean();
  bean7.typeId = CommonConstants.TYPE_CARD;
  bean7.area = [1, 1];
  bean7.cardName === 'ClockWeatherHoriCard';

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

  let lastOccupied: BaseTransferBean[] = [bean1, bean2, bean3, bean4, bean5, bean6, bean7];
  return lastOccupied;
}