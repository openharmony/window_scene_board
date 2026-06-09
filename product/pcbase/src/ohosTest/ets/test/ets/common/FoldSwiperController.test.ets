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
import { DeviceHelper, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { ActionType, FourFingersSwipe } from '@kit.InputKit';
import { SCBFoldState, SwipeGestureDirection, FourFingerSwipeEvent } from '@ohos/pcmode';
import { FoldSwiperController } from '../../../../../../../pcbase/src/main/ets/common/FoldSwiperController';

export default function FoldSwiperControllerTest() {
  describe('FoldSwiperControllerTest', () => {
    let mocker: MockKit;
    let foldSwiperController: FoldSwiperController;
    let switchPagesEvent: GestureEvent = {
      repeat: false,
      fingerList: [],
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
        area:{
          width: 5,
          height: 10,
          position: {
            x: 20, y: 20
          },
          globalPosition: {
            x: 50, y: 50
          },
        }
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    }
    enum SwiperPageState {
      // 完全展开态
      FULL_EXPAND = 0,
      // 折叠态
      HALF_FOLDED,
      // 折叠且B显示
      PAGE_SHOW_UPPER,
      // 折叠且C显示
      PAGE_SHOW_LOWER
    }
    beforeAll(() => {
    })
    beforeEach(() => {
      mocker = new MockKit();
    })
    afterEach(() => {
    })
    afterAll(() => {
      mocker.clearAll();
    })

    it('canSwipeChangeOneTest', 0, () => {
      (foldSwiperController as object)['isLock'] = true;
      foldSwiperController.canSwipeChange();
      expect(foldSwiperController instanceof FoldSwiperController).assertFalse();
    })

    it('canSwipeChangeTwoTest', 0, () => {
      let mockFuncIsViewShowing: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      (foldSwiperController as object)['isLock'] = false;
      when(mockFuncIsViewShowing)().afterReturn(true);
      foldSwiperController.canSwipeChange();
      expect(foldSwiperController instanceof FoldSwiperController).assertFalse();
    })

    it('canSwipeChangeThreeTest', 0, () => {
      (foldSwiperController as object)['mPageState'] = SwiperPageState.FULL_EXPAND;
      foldSwiperController.canSwipeChange();
      expect(foldSwiperController instanceof FoldSwiperController).assertFalse();
    })

    it('switchPagesTest', 0, () => {
      let mockFuncCanSwipeChange: Function = mocker.mockFunc(foldSwiperController, foldSwiperController.canSwipeChange);
      when(mockFuncCanSwipeChange)().afterReturn(true);
      let mockFuncUpdateMoveState: Function = mocker.mockFunc(foldSwiperController, foldSwiperController.updateMoveState);
      when(mockFuncUpdateMoveState)().afterReturnNothing();
      let fingerList: FingerInfo[] = [{
        id: 2,
        globalX: 20,
        globalY: 20,
        localX: 50,
        localY: 50,
        displayX: 60.34,
        displayY: 60.34,
      }]
      switchPagesEvent.fingerList = fingerList
      foldSwiperController.switchPages(ActionType.END, switchPagesEvent);
    })

    it('switchPagesTwoTest', 0, () => {
      let mockFuncCanSwipeChange: Function = mocker.mockFunc(foldSwiperController, foldSwiperController.canSwipeChange);
      when(mockFuncCanSwipeChange)().afterReturn(true);
      foldSwiperController.switchPages(ActionType.UPDATE, switchPagesEvent);
    })

    it('switchPagesThreeTest', 0, () => {
      let mockFuncCanSwipeChange: Function = mocker.mockFunc(foldSwiperController, foldSwiperController.canSwipeChange);
      when(mockFuncCanSwipeChange)().afterReturn(true);
      foldSwiperController.switchPages(ActionType.UPDATE);
    })

    it('updateMoveStateOneTest', 0, () => {
      let gesture: FourFingersSwipe =  {
        x: 20,
        y: 20,
        type: ActionType.BEGIN
      };
      foldSwiperController.updateMoveState(gesture);
      expect((foldSwiperController as object)['startFingerTouch']).assertTrue();
    })

    it('updateMoveStateTwoTest', 0, () => {
      (foldSwiperController as object)['startFingerTouch'] = true;
      (foldSwiperController as object)['mPageState'] = SwiperPageState.PAGE_SHOW_UPPER;
      let mockFunc: Function = mocker.mockFunc((foldSwiperController as object)['moveState'],
        (foldSwiperController as object)['moveState'].getFinalDirection);
      when(mockFunc)().afterReturn(SwipeGestureDirection.DOWN);
      let gesture: FourFingersSwipe =  {
        x: 20,
        y: 20,
        type: ActionType.UPDATE
      };
      foldSwiperController.updateMoveState(gesture);
    })

    it('updateMoveStateThreeTest', 0, () => {
      (foldSwiperController as object)['startFingerTouch'] = true;
      (foldSwiperController as object)['mPageState'] = SwiperPageState.PAGE_SHOW_UPPER;
      let mockFunc: Function = mocker.mockFunc((foldSwiperController as object)['moveState'],
        (foldSwiperController as object)['moveState'].getFinalVerticalLength);
      when(mockFunc)().afterReturn(60);
      let gesture: FourFingersSwipe =  {
        x: 20,
        y: 20,
        type: ActionType.END
      };
      foldSwiperController.updateMoveState(gesture);
    })

    it('updateMoveStateFourTest', 0, () => {
      (foldSwiperController as object)['startFingerTouch'] = false;
      (foldSwiperController as object)['mPageState'] = SwiperPageState.PAGE_SHOW_UPPER;
      let mockFunc: Function = mocker.mockFunc((foldSwiperController as object)['moveState'],
        (foldSwiperController as object)['moveState'].getFinalVerticalLength);
      when(mockFunc)().afterReturn(60);
      let gesture: FourFingersSwipe =  {
        x: 20,
        y: 20,
        type: ActionType.END
      };
      foldSwiperController.updateMoveState(gesture);
    })

    it('updateFoldStateTest', 0, () => {
      foldSwiperController.updateFoldState(SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD);
      foldSwiperController.updateFoldState(SCBFoldState.HALF_FOLDED);
      expect(foldSwiperController instanceof FoldSwiperController).assertTrue();
    })

    it('switchDesktopTest', 0, () => {
      let mockFuncCanSwipeChange: Function = mocker.mockFunc(foldSwiperController, foldSwiperController.canSwipeChange);
      when(mockFuncCanSwipeChange)().afterReturn(true);
      foldSwiperController.switchDesktop(false);
      expect(foldSwiperController instanceof FoldSwiperController).assertTrue();
    })

    it('switchDesktopTwoTest', 0, () => {
      let mockFuncCanSwipeChange: Function = mocker.mockFunc(foldSwiperController, foldSwiperController.canSwipeChange);
      when(mockFuncCanSwipeChange)().afterReturn(false);
      (foldSwiperController as object)['mPrePageState'] = SwiperPageState.PAGE_SHOW_LOWER;
      foldSwiperController.switchDesktop(false);
      expect(foldSwiperController instanceof FoldSwiperController).assertTrue();
    })

    it('switchDesktopTwoTest', 0, () => {
      let mockFuncCanSwipeChange: Function = mocker.mockFunc(foldSwiperController, foldSwiperController.canSwipeChange);
      when(mockFuncCanSwipeChange)().afterReturn(false);
      (foldSwiperController as object)['mPrePageState'] = SwiperPageState.PAGE_SHOW_LOWER;
      foldSwiperController.switchDesktop(true);
      expect(foldSwiperController instanceof FoldSwiperController).assertTrue();
    })

  })
}