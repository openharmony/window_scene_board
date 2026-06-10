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
import { FormStackExpandModel } from '../../../../../main/ets/common/FormStackExpandModel';
import { FormStackExpandItem } from '../../../../../main/ets/viewmodel/FormStackExpandItem';
import { CardItemInfo } from '@ohos/launchercommon';

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
      mockKit.clearAll();
    });

    it('onTouch_007', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({ } as FormStackExpandEventInterface);
      let result = event.onTouch({ type: TouchType.Down, } as TouchEvent);
      expect(result == null).assertTrue();

      let mockKit = new MockKit();
      let mockFuncIsInExpandAnimation: Function = mockKit.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      when(mockFuncIsInExpandAnimation)(ArgumentMatchers.any).afterReturn(true);
      event = FormStackTestUtil.createFormStackExpandItemEvent({
        onTouch: (id: string, zoomOut: boolean) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);
      result = event.onTouch({ type: TouchType.Down, } as TouchEvent);
      expect(result == null).assertTrue();

      when(mockFuncIsInExpandAnimation)(ArgumentMatchers.any).afterReturn(false);
      result = event.onTouch({ type: TouchType.Down, } as TouchEvent);
      expect(result == null).assertTrue();

      mockKit.ignoreMock(FormStackManager.getInstance(), FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      mockKit.clearAll();
    });

    it('onLongPressGesture_008', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({ } as FormStackExpandEventInterface);
      event.onLongPressGesture();
      expect(isCalled).assertFalse();
    });

    it('getFormStackItemList_009', 0, () => {
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        getFormStackLength: () => {
          return 0;
        },
      } as FormStackExpandEventInterface);
      let result = event.getFormStackItemList();
      expect(result).assertEqual(0);
    });

    it('panLateralMove_010', 0, () => {
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({ } as FormStackExpandEventInterface);
      if (event.mViewData?.mItemInfo?.translateX) {
        event.mViewData.mItemInfo.translateX = 10;
      }
      let result: Object = (event as object)['panLateralMove'](1);
      expect(result == null).assertTrue();

      (event as object)['mIsDisableLateralMove'] = true;
      result = (event as object)['panLateralMove'](1);
      expect(result == null).assertTrue();

      event.mViewData = undefined;
      result = (event as object)['panLateralMove'](1);
      expect(result == null).assertTrue();
    });

    it('panLongitudinalMove_011', 0, () => {
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({ } as FormStackExpandEventInterface);
      let result: Object = (event as object)['panLongitudinalMove'](1);
      expect(result == null).assertTrue();

      event = FormStackTestUtil.createFormStackExpandItemEvent({
        onDelete: (id: string) => {

        },
      } as FormStackExpandEventInterface);
      result = (event as object)['panLongitudinalMove'](1);
      expect(result == null).assertTrue();

      event.mViewData = undefined;
      result = (event as object)['panLongitudinalMove'](1);
      expect(result == null).assertTrue();
    });

    it('onDeleteItem_012', 0, () => {
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({ } as FormStackExpandEventInterface);
      let result: Object = (event as object)['onDeleteItem']();
      expect(result == null).assertTrue();

      event.mViewData = undefined;
      result = (event as object)['onDeleteItem']();
      expect(result == null).assertTrue();
    });

    it('reportDeleteItem_013', 0, () => {
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({ } as FormStackExpandEventInterface);
      event.mViewData = undefined;
      let result: Object = (event as object)['onDeleteItem']();
      expect(result == null).assertTrue();
    });

    it('notifyDeleteEvent_014', 0, () => {
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({ } as FormStackExpandEventInterface);
      let result: Object = (event as object)['notifyDeleteEvent'](0, FormStackTestUtil.createCardItemInfo('123456'), new FormStackExpandModel());
      expect(result == null).assertTrue();

      result = (event as object)['notifyDeleteEvent'](2, FormStackTestUtil.createCardItemInfo('123456'), new FormStackExpandModel());
      expect(result == null).assertTrue();

      result = (event as object)['notifyDeleteEvent'](1, FormStackTestUtil.createCardItemInfo('123456'), new FormStackExpandModel());
      expect(result == null).assertTrue();
    });

    it('isItemDisable_015', 0, () => {
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        getExclusiveActionItemId: () => {
          return 'test';
        },
      } as FormStackExpandEventInterface);
      let mockKit = new MockKit();
      let mockFuncIsInExpandAnimation: Function = mockKit.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      when(mockFuncIsInExpandAnimation)(ArgumentMatchers.any).afterReturn(false);
      let result: boolean = (event as object)['isItemDisable']();
      expect(result).assertTrue();
      mockKit.ignoreMock(FormStackManager.getInstance(), FormStackManager.getInstance().getBreakFormStackExpandAnimation);
      mockKit.clearAll();
    });

    it('rotateTrashDelImg_016', 0, () => {
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onTrashAngleMoveChange: (id: string, ratio: number) => {

        }
      } as FormStackExpandEventInterface);
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      FormStackTestUtil.initDefaultConfig(config);
      let mockKit = new MockKit();
      let mockFuncConfig: Function = mockKit.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFuncConfig)(ArgumentMatchers.any).afterReturn(config);

      if (event.mViewData?.mItemInfo?.translateX) {
        event.mViewData.mItemInfo.translateX = 120;
        let result: Object = (event as object)['rotateTrashDelImg']();
        expect(result == null).assertTrue();

        event.mViewData.mDeleteImageMoveLongestDistance = 50;
        event.mViewData.mItemInfo.translateX = 30;
        result = (event as object)['rotateTrashDelImg']();
        expect(result == null).assertTrue();

        event.mViewData.mItemInfo.translateX = 100;
        result = (event as object)['rotateTrashDelImg']();
        expect(result == null).assertTrue();
      }

      event.mViewData = undefined;
      let result: Object = (event as object)['rotateTrashDelImg']();
      expect(result == null).assertTrue();

      mockKit.ignoreMock(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      mockKit.clearAll();
    });

    it('restoreTrashAngle_017', 0, () => {
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onTrashAngleRestored: (id: string, eventFunc: () => void) => {

        }
      } as FormStackExpandEventInterface);
      let result: Object = (event as object)['restoreTrashAngle']();
      expect(result == null).assertTrue();

      if (event.mViewData?.mItemInfo?.trashBodyAngle ) {
        event.mViewData.mItemInfo.trashBodyAngle  = 10;
        let result: Object = (event as object)['restoreTrashAngle']();
        expect(result == null).assertTrue();
      }

      event = FormStackTestUtil.createFormStackExpandItemEvent({ } as FormStackExpandEventInterface);
      result = (event as object)['restoreTrashAngle']();
      expect(result == null).assertTrue();

      event.mViewData = undefined;
      result = (event as object)['restoreTrashAngle']();
      expect(result == null).assertTrue();
    });

    it('makeOtherCardLinkage_018', 0, () => {
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onCardMoveLinkage: (zIndex: number, ratio: number) => {

        }
      } as FormStackExpandEventInterface);
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      FormStackTestUtil.initDefaultConfig(config);
      let mockKit = new MockKit();
      let mockFuncConfig: Function = mockKit.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFuncConfig)(ArgumentMatchers.any).afterReturn(config);

      if (event.mViewData?.mItemInfo?.translateX) {
        event.mViewData.mItemInfo.translateX = 120;
        let result: Object = (event as object)['makeOtherCardLinkage']();
        expect(result == null).assertTrue();

        event.mViewData.mItemInfo.translateX = 60;
        result = (event as object)['makeOtherCardLinkage']();
        expect(result == null).assertTrue();
      }

      event = FormStackTestUtil.createFormStackExpandItemEvent({ } as FormStackExpandEventInterface);
      let result: Object = (event as object)['makeOtherCardLinkage']();
      expect(result == null).assertTrue();

      event.mViewData = undefined;
      result = (event as object)['makeOtherCardLinkage']();
      expect(result == null).assertTrue();

      mockKit.ignoreMock(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      mockKit.clearAll();
    });

    it('makeCardLateralEndAction_019', 0, () => {
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onCardEndLinkage: (zIndex: number, ratio: number, result: number) => {

        },
        restoreLateralSlideCardPos: (distance: number) => {

        },
      } as FormStackExpandEventInterface);
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      FormStackTestUtil.initDefaultConfig(config);
      let mockKit = new MockKit();
      let mockFuncConfig: Function = mockKit.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFuncConfig)(ArgumentMatchers.any).afterReturn(config);

      let result: Object = (event as object)['makeCardLateralEndAction'](10, 10, 1);
      expect(result == null).assertTrue();

      event = FormStackTestUtil.createFormStackExpandItemEvent({
        onCardEndLinkage: (zIndex: number, ratio: number, result: number) => {

        },
      } as FormStackExpandEventInterface);
      result = (event as object)['makeCardLateralEndAction'](10, 10, 0);
      expect(result == null).assertTrue();

      event = FormStackTestUtil.createFormStackExpandItemEvent({ } as FormStackExpandEventInterface);
      result = (event as object)['makeCardLateralEndAction'](10, 10, 0);
      expect(result == null).assertTrue();

      event.mViewData = undefined;
      result = (event as object)['makeCardLateralEndAction']();
      expect(result == null).assertTrue();

      mockKit.ignoreMock(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      mockKit.clearAll();
    });

    it('lateralDampingMove_020', 0, () => {
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({ } as FormStackExpandEventInterface);
      let result: Object = (event as object)['lateralDampingMove'](new FormStackExpandItem(), 10, true);
      expect(result == null).assertTrue();

      if (event.mViewData?.mDeleteImageMoveLongestDistance){
        event.mViewData.mDeleteImageMoveLongestDistance = 100;
        result = (event as object)['lateralDampingMove'](new FormStackExpandItem(), 10, false);
        expect(result == null).assertTrue();
      }

      result = (event as object)['lateralDampingMove'](new FormStackExpandItem(), 200, false);
      expect(result == null).assertTrue();

      (event as object)['mLastLaterMoveDistance'] = 10;
      result = (event as object)['lateralDampingMove'](new FormStackExpandItem(), 200, false);
      expect(result == null).assertTrue();
    });

    it('getDragSnapshot_021', 0, () => {
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        getFormStackExpandModel: () => {
          const model = new FormStackExpandModel();
          model.setCardInfo(FormStackTestUtil.TEST_ITEM_ID1, new CardItemInfo);
          return model;
        },
      } as FormStackExpandEventInterface);
      let item = new FormStackExpandItem()
      let result: Object = (event as object)['getDragSnapshot'](item);
      expect(result == null).assertTrue();

      event.mViewData = undefined;
      result = (event as object)['getDragSnapshot'](item);
      expect(result == null).assertTrue();
    });

  });
}