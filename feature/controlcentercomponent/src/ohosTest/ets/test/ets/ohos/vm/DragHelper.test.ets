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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import {
  DragHelper
} from '../../../../../../main/ets/com/ohos/vm/DragHelper';
import { ToggleEditViewData } from '../../../../../../main/ets/com/ohos/vm/ToggleEditViewData';
import { DtHelper } from '../DtHelper';


let eventArea: Area = {
  width: 0,
  height: 0,
  position: { x: 0, y: 0 },
  globalPosition: { x: 0, y: 0 }
};
let eventTarget: EventTarget = {
  area: eventArea
};
let event: GestureEvent = {
  repeat: false,
  fingerList: [],
  offsetX: 9,
  offsetY: 19,
  angle: 0,
  speed: 0,
  scale: 0,
  pinchCenterX: 0,
  pinchCenterY: 0,
  velocityX: 0,
  velocityY: 0,
  velocity: 0,
  target: eventTarget,
  timestamp: 0,
  source: SourceType.Unknown,
  pressure: 0,
  tiltX: 0,
  tiltY: 0,
  sourceTool: SourceTool.Unknown
};

const ITEM_X: number = 80;
const ITEM_Y: number = 100;
const ITEM_MOVE_X_THRESHHOLD = ITEM_X / 2;
const ITEM_MOVE_Y_THRESHHOLD = ITEM_Y / 2;

const ITEM_MOVE_RIGHT = ITEM_MOVE_X_THRESHHOLD + 1;
const ITEM_MOVE_LEFT = -ITEM_MOVE_X_THRESHHOLD - 1;
const ITEM_MOVE_UP = -ITEM_MOVE_Y_THRESHHOLD - 1;
const ITEM_MOVE_DOWN = ITEM_MOVE_Y_THRESHHOLD + 1;

export function DragHelperTest() {
  let previewToggles: string[];
  let viewData: ToggleEditViewData;
  viewData = new ToggleEditViewData();
  previewToggles = ['0', '1', '2', '3'];
  let sDragHelper = new DragHelper(viewData, 80, 100, 4);
  sDragHelper.previewToggles = previewToggles;
  describe('DragHelperTest', (): void => {

    beforeEach((): void => {

    })
    beforeAll(() => {
      DtHelper.mockSysApi();
    })
    afterEach((): void => {

    })
    afterAll((): void => {
      DtHelper.restoreSysApi();
    })

    it('DragHelperTest_isSupportLeft_Test001', 0, (): void => {
      (sDragHelper as object)['isRTL'] = ():boolean => { return true;}
      (sDragHelper as object)['isSupportLeft']();
      expect((sDragHelper as object)['isRTL']()).assertInstanceOf('Boolean');
    })

    it('DragHelperTest_isSupportLeft_Test002', 0, (): void => {
      (sDragHelper as object)['isRTL'] = ():boolean => { return false;}
      (sDragHelper as object)['isSupportLeft']();
      expect((sDragHelper as object)['isRTL']()).assertInstanceOf('Boolean');
    })

    it('DragHelperTest_isSupportRight_Test001', 0, (): void => {
      (sDragHelper as object)['isRTL'] = ():boolean => { return true;}
      (sDragHelper as object)['isSupportRight']();
      expect((sDragHelper as object)['isRTL']()).assertInstanceOf('Boolean');
    })

    it('DragHelperTest_isSupportRight_Test002', 0, (): void => {
      (sDragHelper as object)['isRTL'] = ():boolean => { return false;}
      (sDragHelper as object)['isSupportRight']();
      expect((sDragHelper as object)['isRTL']()).assertInstanceOf('Boolean');
    })

    it('DragHelperTest_isRightmost_Test001', 0, (): void => {
      (sDragHelper as object)['isRightmost'](1);
      expect((sDragHelper as object)['isRTL']()).assertInstanceOf('Boolean');
    })

    it('DragHelperTest_isSupportDownRight_Test001', 0, (): void => {
      (sDragHelper as object)['isRTL'] = ():boolean => { return true;}
      (sDragHelper as object)['isSupportDownRight']();
      expect((sDragHelper as object)['isRTL']()).assertInstanceOf('Boolean');
    })

    it('DragHelperTest_isSupportDownRight_Test002', 0, (): void => {
      (sDragHelper as object)['isRTL'] = ():boolean => { return false;}
      (sDragHelper as object)['isSupportDownRight']();
      expect((sDragHelper as object)['isRTL']()).assertInstanceOf('Boolean');
    })

    it('DragHelperTest_isSupportUpRight_Test001', 0, (): void => {
      (sDragHelper as object)['isRTL'] = ():boolean => { return true;}
      (sDragHelper as object)['isSupportUpRight']();
      expect((sDragHelper as object)['isRTL']()).assertInstanceOf('Boolean');
    })

    it('DragHelperTest_isSupportUpRight_Test002', 0, (): void => {
      (sDragHelper as object)['isRTL'] = ():boolean => { return false;}
      (sDragHelper as object)['isSupportUpRight']();
      expect((sDragHelper as object)['isRTL']()).assertInstanceOf('Boolean');
    })

    it('DragHelperTest_isSupportDownLeft_Test001', 0, (): void => {
      (sDragHelper as object)['isRTL'] = ():boolean => { return true;}
      (sDragHelper as object)['isSupportDownLeft']();
      expect((sDragHelper as object)['isRTL']()).assertInstanceOf('Boolean');
    })

    it('DragHelperTest_isSupportDownLeft_Test002', 0, (): void => {
      (sDragHelper as object)['isRTL'] = ():boolean => { return false;}
      (sDragHelper as object)['isSupportDownLeft']();
      expect((sDragHelper as object)['isRTL']()).assertInstanceOf('Boolean');
    })

    it('DragHelperTest_onLongPressActionForDrag', 0, () => {
      viewData.dragItem = '-1';
      sDragHelper.onLongPressActionForDrag('4');
      expect(viewData.dragItem).assertEqual('4');
    })

    it('DragHelperTest_onLongPressActionEndForDrag', 0, () => {
      viewData.dragItem = '-1';
      viewData.offsetX = -1;
      viewData.offsetY = -1;
      sDragHelper.onLongPressActionEndForDrag();
      expect(viewData.dragItem).assertEqual('');
      expect(viewData.offsetX).assertEqual(0);
      expect(viewData.offsetY).assertEqual(0);
    })

    it('DragHelperTest_onActionStartForDrag', 0, () => {
      viewData.dragItem = '-1';
      (sDragHelper as object)['dragRefOffsetX'] = -1;
      (sDragHelper as object)['dragRefOffsetY'] = -1;
      sDragHelper.onActionStartForDrag('1');
      expect(viewData.dragItem).assertEqual('1');
      expect((sDragHelper as object)['dragRefOffsetX']).assertEqual(0);
      expect((sDragHelper as object)['dragRefOffsetY']).assertEqual(0);
    })

    it('DragHelperTest_onActionUpdateForDrag', 0, () => {
      event.offsetX = 9;
      event.offsetY = 19;
      (sDragHelper as object)['dragRefOffsetX'] = 0;
      (sDragHelper as object)['dragRefOffsetY'] = 0;
      sDragHelper.onActionUpdateForDrag(event);

      expect(viewData.offsetX).assertEqual(9);
      expect(viewData.offsetY).assertEqual(19);
    })

    it('DragHelperTest_onActionEndForDrag', 0, () => {
      viewData.dragItem = '-1';
      (sDragHelper as object)['dragRefOffsetX'] = -1;
      (sDragHelper as object)['dragRefOffsetY'] = -1;
      sDragHelper.onActionEndForDrag();
      expect(viewData.dragItem).assertEqual('');
      expect(viewData.offsetX).assertEqual(0);
      expect(viewData.offsetX).assertEqual(0);
    })

    it('DragHelperTest_onActionUpdateForDrag_MoveDown', 0, () => {
      (sDragHelper as object)['previewToggles'] = ['0', '1', '2', '3',
        '4', '5', '6', '7',
        '8', '9', '10', '11',
        '12'];
      viewData.offsetX = 0;
      viewData.offsetY = 0;

      // 开始移动5
      sDragHelper.onActionStartForDrag('5');
      // 5移动到9
      event.offsetX = 0;
      event.offsetY = ITEM_MOVE_DOWN;
      sDragHelper.onActionUpdateForDrag(event);

      // 偏移量修正
      expect(viewData.offsetY).assertEqual(ITEM_MOVE_DOWN - ITEM_Y);
      expect((sDragHelper as object)['dragRefOffsetY']).assertEqual(ITEM_Y);
      // 位置移动
      expect((sDragHelper as object)['previewToggles']['5']).assertEqual('6');
      expect((sDragHelper as object)['previewToggles']['6']).assertEqual('7');
      expect((sDragHelper as object)['previewToggles']['7']).assertEqual('8');
      expect((sDragHelper as object)['previewToggles']['8']).assertEqual('9');
      expect((sDragHelper as object)['previewToggles']['9']).assertEqual('5');
    })

    it('DragHelperTest_onActionUpdateForDrag_MoveUp', 0, () => {
      (sDragHelper as object)['previewToggles'] = ['0', '1', '2', '3',
        '4', '5', '6', '7',
        '8', '9', '10', '11',
        '12'];
      viewData.offsetX = 0;
      viewData.offsetY = 0;

      // 移动5
      sDragHelper.onActionStartForDrag('5');
      // 5移动到1
      event.offsetX = 0;
      event.offsetY = ITEM_MOVE_UP;
      sDragHelper.onActionUpdateForDrag(event);

      // 偏移量修正
      expect(viewData.offsetY).assertEqual(ITEM_MOVE_UP + ITEM_Y);
      expect((sDragHelper as object)['dragRefOffsetY']).assertEqual(-ITEM_Y);
      // 位置移动
      expect((sDragHelper as object)['previewToggles']['5']).assertEqual('4');
      expect((sDragHelper as object)['previewToggles']['1']).assertEqual('5');

    })

    it('DragHelperTest_onActionUpdateForDrag_MoveLeft', 0, () => {
      (sDragHelper as object)['previewToggles'] = ['0', '1', '2', '3',
        '4', '5', '6', '7',
        '8', '9', '10', '11',
        '12'];
      viewData.offsetX = 0;
      viewData.offsetY = 0;

      // 移动5
      sDragHelper.onActionStartForDrag('5');
      // 5移动到4
      event.offsetY = 0;
      event.offsetX = ITEM_MOVE_LEFT;
      sDragHelper.onActionUpdateForDrag(event);

      // 偏移量修正
      expect((sDragHelper as object)['dragRefOffsetX']).assertEqual(-ITEM_X);
      expect(viewData.offsetX).assertEqual(ITEM_MOVE_LEFT + ITEM_X);
      // 位置移动
      expect((sDragHelper as object)['previewToggles']['5']).assertEqual('4');
      expect((sDragHelper as object)['previewToggles']['4']).assertEqual('5');
    })

    it('DragHelperTest_onActionUpdateForDrag_MoveRight', 0, () => {
      (sDragHelper as object)['previewToggles'] = ['0', '1', '2', '3',
        '4', '5', '6', '7',
        '8', '9', '10', '11',
        '12'];
      viewData.offsetX = 0;
      viewData.offsetY = 0;

      // 移动5
      sDragHelper.onActionStartForDrag('5');
      // 5移动到6
      event.offsetY = 0;
      event.offsetX = ITEM_MOVE_RIGHT;

      sDragHelper.onActionUpdateForDrag(event);

      // 偏移量修正
      expect((sDragHelper as object)['dragRefOffsetX']).assertEqual(ITEM_X);
      expect(viewData.offsetX).assertEqual(ITEM_MOVE_RIGHT - ITEM_X);
      // 位置移动
      expect((sDragHelper as object)['previewToggles']['5']).assertEqual('6');
      expect((sDragHelper as object)['previewToggles']['6']).assertEqual('5');
    })
    //todo
    it('DragHelperTest_onActionUpdateForDrag_MoveDownRight', 0, () => {
      (sDragHelper as object)['previewToggles'] = ['0', '1', '2', '3',
        '4', '5', '6', '7',
        '8', '9', '10', '11',
        '12'];
      viewData.offsetX = 0;
      viewData.offsetY = 0;

      // 移动5
      sDragHelper.onActionStartForDrag('5');
      // 5移动到10
      event.offsetY = ITEM_MOVE_DOWN;
      event.offsetX = ITEM_MOVE_RIGHT;
      sDragHelper.onActionUpdateForDrag(event);

      // 偏移量修正
      expect(viewData.offsetX).assertEqual(ITEM_MOVE_RIGHT - ITEM_X);
      expect((sDragHelper as object)['dragRefOffsetX']).assertEqual(ITEM_X);
      expect(viewData.offsetY).assertEqual(ITEM_MOVE_DOWN - ITEM_Y);
      expect((sDragHelper as object)['dragRefOffsetY']).assertEqual(ITEM_Y);
      // 位置移动
      expect((sDragHelper as object)['previewToggles']['5']).assertEqual('6');
      expect((sDragHelper as object)['previewToggles']['10']).assertEqual('5');
    })

    it('DragHelperTest_onActionUpdateForDrag_MoveUpRight', 0, () => {
      (sDragHelper as object)['previewToggles'] = ['0', '1', '2', '3',
        '4', '5', '6', '7',
        '8', '9', '10', '11',
        '12'];
      viewData.offsetX = 0;
      viewData.offsetY = 0;

      // 移动5
      sDragHelper.onActionStartForDrag('5');
      // 5移动到2
      event.offsetY = ITEM_MOVE_UP;
      event.offsetX = ITEM_MOVE_RIGHT;
      sDragHelper.onActionUpdateForDrag(event);

      // 偏移量修正
      expect(viewData.offsetX).assertEqual(ITEM_MOVE_RIGHT - ITEM_X);
      expect((sDragHelper as object)['dragRefOffsetX']).assertEqual(ITEM_X);
      expect(viewData.offsetY).assertEqual(ITEM_MOVE_UP + ITEM_Y);
      expect((sDragHelper as object)['dragRefOffsetY']).assertEqual(-ITEM_Y);
      // 位置移动
      expect((sDragHelper as object)['previewToggles']['5']).assertEqual('4');
      expect((sDragHelper as object)['previewToggles']['2']).assertEqual('5');
    })

    it('DragHelperTest_onActionUpdateForDrag_MoveDownLeft', 0, () => {
      (sDragHelper as object)['previewToggles'] = ['0', '1', '2', '3',
        '4', '5', '6', '7',
        '8', '9', '10', '11',
        '12'];
      viewData.offsetX = 0;
      viewData.offsetY = 0;

      // 移动5
      sDragHelper.onActionStartForDrag('5');
      // 5移动到8
      event.offsetY = ITEM_MOVE_DOWN;
      event.offsetX = ITEM_MOVE_LEFT;
      sDragHelper.onActionUpdateForDrag(event);

      // 偏移量修正
      expect(viewData.offsetX).assertEqual(ITEM_MOVE_LEFT + ITEM_X);
      expect((sDragHelper as object)['dragRefOffsetX']).assertEqual(-ITEM_X);
      expect(viewData.offsetY).assertEqual(ITEM_MOVE_DOWN - ITEM_Y);
      expect((sDragHelper as object)['dragRefOffsetY']).assertEqual(ITEM_Y);
      // 位置移动
      expect((sDragHelper as object)['previewToggles']['5']).assertEqual('6');
      expect((sDragHelper as object)['previewToggles']['8']).assertEqual('5');
    })

    it('DragHelperTest_onActionUpdateForDrag_MoveUpLeft', 0, () => {
      (sDragHelper as object)['previewToggles'] = ['0', '1', '2', '3',
        '4', '5', '6', '7',
        '8', '9', '10', '11',
        '12'];
      viewData.offsetX = 0;
      viewData.offsetY = 0;

      // 移动5
      sDragHelper.onActionStartForDrag('5');
      // 5移动到0
      event.offsetY = ITEM_MOVE_UP;
      event.offsetX = ITEM_MOVE_LEFT;
      sDragHelper.onActionUpdateForDrag(event);

      // 偏移量修正
      expect(viewData.offsetX).assertEqual(ITEM_MOVE_LEFT + ITEM_X);
      expect((sDragHelper as object)['dragRefOffsetX']).assertEqual(-ITEM_X);
      expect(viewData.offsetY).assertEqual(ITEM_MOVE_UP + ITEM_Y);
      expect((sDragHelper as object)['dragRefOffsetY']).assertEqual(-ITEM_Y);
      // 位置移动
      expect((sDragHelper as object)['previewToggles']['5']).assertEqual('4');
      expect((sDragHelper as object)['previewToggles']['0']).assertEqual('5');
    })

    it('DragHelperTest_onActionUpdateForDrag_MoveUpRightSteps', 0, () => {
      (sDragHelper as object)['previewToggles'] = ['0', '1', '2', '3',
        '4', '5', '6', '7',
        '8', '9', '10', '11',
        '12'];
      viewData.offsetX = 0;
      viewData.offsetY = 0;

      // 移动12
      sDragHelper.onActionStartForDrag('12');
      // 12移动到10
      event.offsetY = ITEM_MOVE_UP;
      event.offsetX = ITEM_X + ITEM_MOVE_RIGHT;
      sDragHelper.onActionUpdateForDrag(event);

      // 偏移量修正
      expect(viewData.offsetX).assertEqual(ITEM_MOVE_RIGHT - ITEM_X);
      expect((sDragHelper as object)['dragRefOffsetX']).assertEqual(2 * ITEM_X);
      expect(viewData.offsetY).assertEqual(ITEM_MOVE_UP + ITEM_Y);
      expect((sDragHelper as object)['dragRefOffsetY']).assertEqual(-ITEM_Y);
      // 位置移动
      expect((sDragHelper as object)['previewToggles']['12']).assertEqual('11');
      expect((sDragHelper as object)['previewToggles']['10']).assertEqual('12');
    })

    it('DragHelperTest_onActionUpdateForDrag_MoveDownLeftSteps', 0, () => {
      (sDragHelper as object)['previewToggles'] = ['0', '1', '2', '3',
        '4', '5', '6', '7',
        '8', '9', '10', '11',
        '12'];
      viewData.offsetX = 0;
      viewData.offsetY = 0;

      // 移动10
      sDragHelper.onActionStartForDrag('10');
      // 10移动到12
      event.offsetY = ITEM_MOVE_DOWN;
      event.offsetX = ITEM_MOVE_LEFT - ITEM_X;
      sDragHelper.onActionUpdateForDrag(event);

      // 偏移量修正
      expect(viewData.offsetX).assertEqual(ITEM_MOVE_LEFT + ITEM_X);
      expect((sDragHelper as object)['dragRefOffsetX']).assertEqual(-2 * ITEM_X);
      expect(viewData.offsetY).assertEqual(ITEM_MOVE_DOWN - ITEM_Y);
      expect((sDragHelper as object)['dragRefOffsetY']).assertEqual(ITEM_Y);
      // 位置移动
      expect((sDragHelper as object)['previewToggles']['10']).assertEqual('11');
      expect((sDragHelper as object)['previewToggles']['12']).assertEqual('10');
    })

    it('DragHelperTest_isSupportUpLeft', 0, (): void => {
      (sDragHelper as object)['isRTL'] = (): boolean => {
        return true;
      };
      (sDragHelper as object)['isSupportUpLeft']();
      (sDragHelper as object)['isSupportDownLeftSteps']();
      (sDragHelper as object)['isSupportUpRightSteps']();
      (sDragHelper as object)['isSupportUpLeftSteps']();
      (sDragHelper as object)['isSupportDownRightSteps']();
      (sDragHelper as object)['moveUpLeftSteps']();
      (sDragHelper as object)['isRTL'] = (): boolean => {
        return false;
      };
      (sDragHelper as object)['isSupportDownRightSteps']();
      expect((sDragHelper as object)['isSupportUpLeftSteps']()).assertFalse();
    })
  })
}