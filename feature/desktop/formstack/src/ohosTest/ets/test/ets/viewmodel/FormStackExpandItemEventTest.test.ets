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
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  ArgumentMatchers,
  when,
} from '@ohos/hypium';
import { dragSnapshotHelper } from '@ohos/componenthelper';
import { scbEventExclusiveManager } from '@ohos/windowscene';
import { FormStackExpandEventInterface } from '../../../../../main/ets/common/FormStackExpandEventInterface';
import { FormStackExpandItemEvent } from '../../../../../main/ets/viewmodel/FormStackExpandItemEvent';
import { FormStackManager } from '../../../../../main/ets/common/FormStackManager';
import { FormStackTestUtil } from '../common/FormStackTestUtil';
import { FormStackExpandConfig } from '../../../../../main/ets/common/FormStackExpandConfig';

export function FormStackExpandItemEventTest() {
  describe('FormStackExpandItemEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('onDeleteImgClick', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onDelete: (string) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);

      event.onDeleteImgClick();
      expect(event.mViewData?.mVisible).assertFalse();
      expect(isCalled).assertTrue();
    });

    it('onClick', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onClick: (id: string) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);

      event.onClick('');
      expect(isCalled).assertTrue();

      isCalled = false;
      event.mViewData = undefined;
      event.onClick('');
      expect(isCalled).assertFalse();

      event = FormStackTestUtil.createFormStackExpandItemEvent({} as FormStackExpandEventInterface);
      event.onClick('');
      expect(isCalled).assertFalse();

      let mockKit = new MockKit();
      let mockFuncIsInExpandAnimation: Function = mockKit.mockFunc(FormStackManager.getInstance(),
        FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      when(mockFuncIsInExpandAnimation)(ArgumentMatchers.any).afterReturn(true);
      event.onClick('');
      expect(isCalled).assertFalse();

      mockKit.clear(FormStackManager.getInstance());
      mockKit.clearAll();
    });

    it('onDragStart', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onDragStart: (id: string) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);

      event.onDragStart({} as DragEvent);
      expect(isCalled).assertTrue();
      expect(event.mViewData?.mItemInfo?.isVisible).assertEqual(false);

      isCalled = false;
      event.mViewData = undefined;
      event.onDragStart({} as DragEvent);
      expect(isCalled).assertFalse();

      event = FormStackTestUtil.createFormStackExpandItemEvent({} as FormStackExpandEventInterface);
      event.onDragStart({} as DragEvent);
      expect(isCalled).assertFalse();
    });

    it('onDragEnd', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onDragEnd: (id: string) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);

      event.onDragEnd({} as DragEvent);
      expect(isCalled).assertTrue();

      isCalled = false;
      event.mViewData = undefined;
      event.onDragEnd({} as DragEvent);
      expect(isCalled).assertFalse();

      event = FormStackTestUtil.createFormStackExpandItemEvent({} as FormStackExpandEventInterface);
      event.onDragEnd({} as DragEvent);
      expect(isCalled).assertFalse();
    });

    it('onPanGestureStart', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onPanGestureStart: (id: string) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);

      event.onPanGestureStart({} as GestureEvent);
      expect(isCalled).assertTrue();
      expect(event.mViewData?.mItemInfo?.delImgVisible).assertTrue();

      isCalled = false;
      if (event.mViewData?.mItemInfo?.isDraggable) {
        event.mViewData.mItemInfo.isDraggable = false;
        event.onPanGestureStart({ offsetX: -5, offsetY: 0, } as GestureEvent);
        expect(isCalled).assertFalse();
      }

      event = FormStackTestUtil.createFormStackExpandItemEvent({} as FormStackExpandEventInterface);
      event.onPanGestureStart({} as GestureEvent);
      expect(isCalled).assertFalse();

      let mockKit = new MockKit();
      let mockFuncIsInExpandAnimation: Function = mockKit.mockFunc(FormStackManager.getInstance(),
        FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      when(mockFuncIsInExpandAnimation)(ArgumentMatchers.any).afterReturn(true);
      event.onPanGestureStart({} as GestureEvent);
      expect(isCalled).assertFalse();

      isCalled = false;
      event.mViewData = undefined;
      event.onPanGestureStart({} as GestureEvent);
      expect(isCalled).assertFalse();

      mockKit.clear(FormStackManager.getInstance());
      mockKit.clearAll();
    });

    it('onPanGestureMove', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onPanGestureMove: (id: string, offsetY: number) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);

      event.onPanGestureMove({ offsetX: -1, offsetY: 0, } as GestureEvent);
      event.onPanGestureMove({ offsetX: 0, offsetY: 0 } as GestureEvent);
      expect(isCalled).assertFalse();

      let mockKit = new MockKit();
      let mockFuncIsInExpandAnimation: Function = mockKit.mockFunc(FormStackManager.getInstance(),
        FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      when(mockFuncIsInExpandAnimation)(ArgumentMatchers.any).afterReturn(true);
      event.onPanGestureMove({ offsetX: 5, offsetY: 5, } as GestureEvent);
      expect(isCalled).assertFalse();

      mockKit.clear(FormStackManager.getInstance());
      mockKit.clearAll();
    });

    it('onPanGestureEnd', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onPanGestureEnd: (id: string, offsetY: number, velocityY: number) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);

      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      FormStackTestUtil.initDefaultConfig(config);

      let mockKit = new MockKit();
      let mockFuncConfig: Function = mockKit.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFuncConfig)(ArgumentMatchers.any).afterReturn(config);

      if (event.mViewData?.mItemInfo?.translateX) {
        event.mViewData.mItemInfo.translateX = 150;
        event.onPanGestureEnd({} as GestureEvent);
        expect(isCalled).assertTrue();

        isCalled = false;
        event.mViewData.mItemInfo.translateX = 1;
        event.onPanGestureEnd({} as GestureEvent);
        expect(isCalled).assertTrue();

        isCalled = false;
        event.mViewData.mItemInfo.translateX = 0;
        event.onPanGestureEnd({} as GestureEvent);
        expect(isCalled).assertTrue();
      }

      let mockFuncIsInExpandAnimation: Function = mockKit.mockFunc(FormStackManager.getInstance(),
        FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      when(mockFuncIsInExpandAnimation)(ArgumentMatchers.any).afterReturn(true);
      isCalled = false;
      event.onPanGestureEnd({} as GestureEvent);
      expect(isCalled).assertFalse();

      if (event.mViewData?.mItemInfo) {
        event.mViewData.mItemInfo = undefined;
        event.onPanGestureEnd({} as GestureEvent);
        expect(isCalled).assertFalse();
      }

      mockKit.clear(FormStackExpandConfig);
      mockKit.clear(FormStackManager.getInstance());
      mockKit.clearAll();
    });

    it('onTouch', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onTouch: (id: string, zoomOut: boolean) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);

      event.onTouch();
      expect(isCalled).assertFalse();

      let mockKit = new MockKit();
      let mockFunkSnap: Function = mockKit.mockFunc(dragSnapshotHelper, dragSnapshotHelper.snapshotFromId);
      when(mockFunkSnap)(ArgumentMatchers.any).afterReturnNothing();

      event.onTouch({ type: TouchType.Up, } as TouchEvent);
      expect(event.mViewData?.mItemInfo?.scaleX).assertEqual(1);
      expect(isCalled).assertTrue();

      isCalled = false;
      event.onTouch({ type: TouchType.Down, } as TouchEvent);
      expect(event.mViewData?.mItemInfo?.scaleX).assertEqual(1);
      expect(isCalled).assertTrue();

      isCalled = false;
      event.onTouch({ type: TouchType.Cancel, } as TouchEvent);
      expect(isCalled).assertFalse();


      let mockFuncIsInExpandAnimation: Function = mockKit.mockFunc(FormStackManager.getInstance(),
        FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      when(mockFuncIsInExpandAnimation)(ArgumentMatchers.any).afterReturn(true);
      event.onTouch();
      expect(isCalled).assertFalse();

      event.mViewData = undefined;
      event.onTouch({ type: TouchType.Up, } as TouchEvent);
      expect(isCalled).assertFalse();

      mockKit.clear(dragSnapshotHelper);
      mockKit.clear(FormStackManager.getInstance());
      mockKit.clearAll();
    });

    it('onLongPressGesture', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onLongPressGesture: (id: string, zoomOut: boolean) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);

      event.onLongPressGesture();
      expect(isCalled).assertTrue();

      let mockKit = new MockKit();
      let mockFuncIsInExpandAnimation: Function = mockKit.mockFunc(FormStackManager.getInstance(),
        FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      when(mockFuncIsInExpandAnimation)(ArgumentMatchers.any).afterReturn(true);

      isCalled = false;
      event.onLongPressGesture();
      expect(isCalled).assertFalse();

      event.mViewData = undefined;
      event.onLongPressGesture();
      expect(isCalled).assertFalse();

      mockKit.clear(FormStackManager.getInstance());
      mockKit.clearAll();
    });

    it('resetData', 0, () => {
      let event: FormStackExpandItemEvent = new FormStackExpandItemEvent();
      event.resetData();
    });

    it('getFormStackItemList', 0, () => {
      let event: FormStackExpandItemEvent = new FormStackExpandItemEvent();
      event.getFormStackItemList();
    });

    it('onTouch', 0, () => {
      let itemEvent: FormStackExpandItemEvent = new FormStackExpandItemEvent();
      let event: TouchEvent = { type: 0 } as TouchEvent;

      let mockKit = new MockKit();
      let mockFun: Function = mockKit.mockFunc(scbEventExclusiveManager,
        scbEventExclusiveManager.isExclusive);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);

      itemEvent.onTouch(event);

      mockKit.clear(scbEventExclusiveManager);
      mockKit.clearAll();
    });

    it('onClick_002', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onClick: (id: string) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);
      let mockKit = new MockKit();
      let mockFuncIsInExpandAnimation: Function = mockKit.mockFunc(FormStackManager.getInstance(),
        FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      when(mockFuncIsInExpandAnimation)(ArgumentMatchers.any).afterReturn(true);
      event.onClick('');
      expect(isCalled).assertFalse();
      mockKit.ignoreMock(FormStackManager.getInstance(), FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      mockKit.clear(FormStackManager.getInstance());
      mockKit.clearAll();
    });

    it('onDragEnd_003', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onDragEnd: (id: string) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);
      if (event.mViewData?.mItemInfo?.trashHeadAngle) {
        event.mViewData.mItemInfo.trashHeadAngle = 1;
      }
      if (event.mViewData?.mItemInfo?.trashBodyAngle) {
        event.mViewData.mItemInfo.trashBodyAngle = 1;
      }
      if (event.mViewData?.mItemInfo?.translateX) {
        event.mViewData.mItemInfo.translateX = 1;
      }
      event.onDragEnd({} as DragEvent);
      expect(isCalled).assertTrue();
    });

    it('onPanGestureMove_005', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onPanGestureMove: (id: string, offsetY: number) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);
      let result = event.onPanGestureMove({ offsetX: 5, offsetY: 6, } as GestureEvent);
      expect(result == null).assertTrue();

      result = event.onPanGestureMove({ } as GestureEvent);
      expect(result == null).assertTrue();

      (event as object)['mIsLongitudinalSliding'] = true;
      result = event.onPanGestureMove({ offsetX: 5, offsetY: 5, } as GestureEvent);
      expect(result == null).assertTrue();

      (event as object)['mIsLateralSliding'] = true;
      result = event.onPanGestureMove({ offsetX: 5, offsetY: 5, } as GestureEvent);
      expect(result == null).assertTrue();
    });

    it('onPanGestureEnd_006', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onPanGestureEnd: (id: string, offsetY: number, velocityY: number) => {
          isCalled = true;
        },
        restoreLateralSlideCardPos: (distance: number) => {
          isCalled = true;
        }
      } as FormStackExpandEventInterface);
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      FormStackTestUtil.initDefaultConfig(config);
      let mockKit = new MockKit();
      let mockFuncConfig: Function = mockKit.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFuncConfig)(ArgumentMatchers.any).afterReturn(config);

      let mockFuncIsInExpandAnimation: Function = mockKit.mockFunc(FormStackManager.getInstance(),
        FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      when(mockFuncIsInExpandAnimation)(ArgumentMatchers.any).afterReturn(false);
      (event as object)['mIsDisableLateralMove'] = true;
      let result = event.onPanGestureEnd({} as GestureEvent);
      expect(result == null).assertTrue();

      (event as object)['mIsDisableLateralMove'] = false;
      (event as object)['mIsLateralSliding'] = true;
      if (event.mViewData?.mItemInfo?.translateX) {
        event.mViewData.mItemInfo.translateX = 10;
        let result = event.onPanGestureEnd({} as GestureEvent);
        expect(result == null).assertTrue();

        event.mViewData.mItemInfo.translateX = -10;
        result = event.onPanGestureEnd({} as GestureEvent);
        expect(result == null).assertTrue();

        event.mViewData.mItemInfo.translateX = -40;
        result = event.onPanGestureEnd({} as GestureEvent);
        expect(result == null).assertTrue();
      }

      (event as object)['mIsLateralSliding'] = false;
      result = event.onPanGestureEnd({} as GestureEvent);
      expect(result == null).assertTrue();

      (event as object)['mEventInterface'].onPanGestureEnd = null;
      result = event.onPanGestureEnd({} as GestureEvent);
      expect(result == null).assertTrue();
      mockKit.ignoreMock(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      mockKit.ignoreMock(FormStackManager.getInstance(), FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      mockKit.clear(FormStackExpandConfig);
      mockKit.clear(FormStackManager.getInstance());
      mockKit.clearAll();
    });
  });
}