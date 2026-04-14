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
import { CardItemInfo } from '@ohos/launchercommon';
import { FormStackItemInfo } from '../../../../../main/ets/common/FormStackItemInfo';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';
import { FormStackExpandItem } from '../../../../../main/ets/viewmodel/FormStackExpandItem';
import { FormStackTestUtil } from '../common/FormStackTestUtil';
import { image } from '@kit.ImageKit';
import { FormStackExpandConfig } from '../../../../../main/ets/common/FormStackExpandConfig';
import { FormStackManager } from '../../../../../main/ets/common/FormStackManager';

export function FormStackExpandViewDataTest() {
  describe('FormStackExpandViewDataTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initData', 0, () => {
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let itemInfo: FormStackItemInfo = FormStackTestUtil.createFormStackItemInfo('123');
      let itemList: CardItemInfo[] = itemInfo.layoutInfo[0];

      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(FormStackUtil, FormStackUtil.snapImage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn({});

      expect(viewData.initData(itemList)).assertTrue();
      expect(viewData.mItemInfoList.length).assertEqual(itemList.length);

      mockKit.clear(FormStackUtil);
      mockKit.clearAll();
    });

    it('isTopItemOfFormStack', 0, () => {
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let itemList: FormStackExpandItem[] = viewData.mItemInfoList;

      expect(viewData.isTopItemOfFormStack(itemList[0].idStr)).assertFalse();
      expect(viewData.isTopItemOfFormStack(itemList[itemList.length - 1].idStr)).assertTrue();
    });

    it('isTopItemOfFormStack', 0, () => {
      let viewData: FormStackExpandViewData = new FormStackExpandViewData();
      viewData.initData([]);

      let mockKit: MockKit = new MockKit();
      let mockFunc: Function = mockKit.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      viewData.initFormStackHotArea();
      expect(viewData.mHotAreaVisible).assertFalse();
      mockKit.clear(FormStackUtil);
      mockKit.clearAll();
    });

    let viewData: FormStackExpandViewData = new FormStackExpandViewData();
    let formStackExpandItem: FormStackExpandItem = new FormStackExpandItem();
    let formStackExpandItem1: FormStackExpandItem = new FormStackExpandItem();
    let formStackExpandItem2: FormStackExpandItem = new FormStackExpandItem();
    let itemList: FormStackExpandItem[] = [formStackExpandItem, formStackExpandItem1, formStackExpandItem2];
    let cardItemInfo: CardItemInfo = new CardItemInfo();
    cardItemInfo.bundleName = 'a';
    let cardItemInfo1: CardItemInfo = new CardItemInfo();
    let cardItemInfo2: CardItemInfo = new CardItemInfo();
    let itemList1: CardItemInfo[] = [cardItemInfo, cardItemInfo1, cardItemInfo2];
    let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();

    it('isTopItemOfFormStack_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      viewData.isTopItemOfFormStack('a');
      expect(viewData).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('isTopItemOfFormStack_test02', 0, () => {
      formStackExpandItem.isVisible = false;
      formStackExpandItem1.isVisible = true;
      formStackExpandItem1.idStr = 'a';
      formStackExpandItem2.isVisible = true;
      formStackExpandItem2.idStr = 'b';
      viewData.mItemInfoList = itemList;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      viewData.isTopItemOfFormStack('a');
      expect(viewData).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('calculateHotAreaHeight_test01', 0, () => {
      config.mMaxShowCount = 5;
      config.mChildCount = 15;
      viewData.mHotAreaVisible = true;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
      viewData.calculateHotAreaHeight(10);
      expect(viewData).not().assertUndefined();
      mocker.clear(FormStackExpandConfig);
    });

    it('calculateHotAreaHeight_test02', 0, () => {
      config.mMaxShowCount = 5;
      config.mChildCount = 15;
      viewData.mHotAreaVisible = true;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
      viewData.calculateHotAreaHeight(15);
      expect(viewData).not().assertUndefined();
      mocker.clear(FormStackExpandConfig);
    });

    it('calculateHotAreaHeight_test03', 0, () => {
      formStackExpandItem.translateY = 100;
      viewData.mItemInfoList = itemList;
      config.mMaxShowCount = 5;
      config.mChildCount = 15;
      viewData.mHotAreaVisible = true;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
      viewData.calculateHotAreaHeight(4);
      expect(viewData).not().assertUndefined();
      mocker.clear(FormStackExpandConfig);
    });

    it('calculateHotAreaHeight_test04', 0, () => {
      formStackExpandItem.translateY = 48;
      viewData.mItemInfoList = itemList;
      config.mMaxShowCount = 5;
      config.mChildCount = 15;
      viewData.mHotAreaVisible = true;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
      viewData.calculateHotAreaHeight(4);
      expect(viewData).not().assertUndefined();
      mocker.clear(FormStackExpandConfig);
    });

    it('initImgData_test01', 0, async (done: Function) => {
      let imageMap1: image.PixelMap = await createImage(2, 3);
      let mocker: MockKit = new MockKit();
      let mockFunc =
        mocker.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getCacheDragCardImage);
      let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidImage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(imageMap1);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      (viewData as object)['initImgData'](formStackExpandItem, cardItemInfo);
      expect(viewData).not().assertUndefined();
      mocker.clear(FormStackManager.getInstance());
      mocker.clear(FormStackUtil);
      done();
    });

    it('initImgData_test02', 0, async (done: Function) => {
      let imageMap1: image.PixelMap = await createImage(2, 3);
      let mocker: MockKit = new MockKit();
      let mockFunc =
        mocker.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getCacheDragCardImage);
      let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidImage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(imageMap1);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      (viewData as object)['initImgData'](formStackExpandItem, cardItemInfo);
      expect(viewData).not().assertUndefined();
      mocker.clear(FormStackManager.getInstance());
      mocker.clear(FormStackUtil);
      done();
    });

    it('initImgData_test03', 0, async (done: Function) => {
      cardItemInfo.cardId = 'a';
      let imageMap1: image.PixelMap = await createImage(2, 3);
      let mocker: MockKit = new MockKit();
      let mockFunc =
        mocker.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getCacheDragCardImage);
      let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidImage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(imageMap1);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      (viewData as object)['initImgData'](formStackExpandItem, cardItemInfo);
      expect(viewData).not().assertUndefined();
      mocker.clear(FormStackManager.getInstance());
      mocker.clear(FormStackUtil);
      done();
    });

    it('initFormStackExpandList_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidCard);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (viewData as object)['isTopItemOfFormStack'](itemList1);
      expect(viewData).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('initData', 0, () => {
      const event: FormStackSnapViewEvent = new FormStackSnapViewEvent();
      event.initData(new FormStackSnapViewData(), new FormStackSnapCommonData());
      expect(event.mViewData == undefined).assertFalse();
    });

    it('resetData', 0, () => {
      const event: FormStackSnapViewEvent = new FormStackSnapViewEvent();
      event.initData(new FormStackSnapViewData(), new FormStackSnapCommonData());
      event.resetData();
      expect(event.mViewData).assertEqual(undefined);
      expect(event.mCommonData).assertEqual(undefined);
    });

    it('onRecvSnapShowMsg', 0, () => {
      const event: FormStackSnapViewEvent = new FormStackSnapViewEvent();
      event.onRecvSnapShowMsg(false, new FormStackSnapCommonData());

      const viewData = new FormStackSnapViewData();
      event.initData(viewData, new FormStackSnapCommonData());
      event.onRecvSnapShowMsg(true, undefined);
      expect(viewData.mIsShow).assertFalse();

      event.onRecvSnapShowMsg(false, new FormStackSnapCommonData());
      expect(viewData.mIsShow).assertFalse();

      const mocker = new MockKit();
      const mockFun = mocker.mockFunc(ResourceManager.getInstance(),
        ResourceManager.getInstance().getCachedCardSnapshot);

      when(mockFun)().afterReturn(undefined);
      event.onRecvSnapShowMsg(false, new FormStackSnapCommonData());
      expect(viewData.mIsShow).assertFalse();

      when(mockFun)().afterReturn({} as image.PixelMap);
      event.onRecvSnapShowMsg(true, new FormStackSnapCommonData());

      mocker.clear(ResourceManager.getInstance());
      mocker.clearAll();

      setTimeout(() => {
        expect(viewData.mIsShow).assertFalse();
      }, 2050);
    });

    it('onRecvCoverImgCreateMsg', 0, () => {
      const event: FormStackSnapViewEvent = new FormStackSnapViewEvent();
      event.onRecvCoverImgCreateMsg('');
      event.onRecvCoverImgCreateMsg('123');
    });

    it('resetCommonData_test01', 0, () => {
      const event: FormStackSnapViewEvent = new FormStackSnapViewEvent();
      event.mCommonData = undefined;
      (event as object)['resetCommonData']();
      expect(event).not().assertUndefined();
    });

    it('getItemBackgroundColor', 0, () => {
      const viewData: HorizontalMenuViewData = new HorizontalMenuViewData();
      expect(viewData.getItemBackgroundColor()).assertEqual(StyleConstants.DEFAULT_TRANSPARENT_COLOR);
    });

    it('updateShortcutName_test01', 0, () => {
      let viewData: HorizontalMenuViewData = new HorizontalMenuViewData();
      viewData.mHoverState = true;
      viewData.getItemBackgroundColor();
      expect(viewData).not().assertUndefined();

      viewData.mHoverState = false;
      viewData.mPressState = true;
      viewData.getItemBackgroundColor();
      expect(viewData).not().assertUndefined();

      viewData.mHoverState = false;
      viewData.mPressState = false;
      viewData.getItemBackgroundColor();
      expect(viewData).not().assertUndefined();
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

    it('onDragMove', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onDragMove: (id: string) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);

      event.onDragMove();
      expect(isCalled).assertTrue();

      isCalled = false;
      event.mViewData = undefined;
      event.onDragMove();
      expect(isCalled).assertFalse();
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

    it('onDragMove', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onDragMove: (id: string) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);

      event.onDragMove();
      expect(isCalled).assertTrue();

      isCalled = false;
      event.mViewData = undefined;
      event.onDragMove();
      expect(isCalled).assertFalse();
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

    it('onDragMove_001', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onDragMove: (id: string) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);
      (event as object)['mEventInterface'] = null;
      event.onDragMove();
      expect(isCalled).assertFalse();
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

    it('onDragDrop_001', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onDragDrop: (id: string) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);

      event.onDragDrop();
      expect(isCalled).assertTrue();
    });

    it('onDragDrop_002', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({
        onDragDrop: (id: string) => {
          isCalled = true;
        },
      } as FormStackExpandEventInterface);

      isCalled = false;
      event.mViewData = undefined;
      event.onDragDrop();
      expect(isCalled).assertFalse();
    });

    it('onDragDrop_003', 0, () => {
      let isCalled: boolean = false;
      let event: FormStackExpandItemEvent = FormStackTestUtil.createFormStackExpandItemEvent({} as FormStackExpandEventInterface);
      event.onDragDrop();
      expect(isCalled).assertFalse();
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
          return  new FormStackExpandModel();
        },
      } as FormStackExpandEventInterface);
      let item = new FormStackExpandItem()
      let result: Object = (event as object)['getDragSnapshot'](item);
      expect(result == null).assertTrue();

      event.mViewData = undefined;
      result = (event as object)['getDragSnapshot'](item);
      expect(result == null).assertTrue();
    });

    it('longitudinalSlideMove', 0, () => {
      let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();
      // 构建ViewData等信息，用于初始化slideAnimate
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();

      // 初始化layoutAnimate
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.initData(viewData, layoutModel);

      // slideAnimate未初始化，覆盖longitudinalSlideMove分支
      let ret: boolean = slideAnimate.longitudinalSlideMove(5);
      expect(ret).assertFalse();

      // 初始化slideAnimate
      slideAnimate.initData(viewData, layoutAnimate, layoutModel);
      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(false);
      // 模拟触发layout布局
      layoutAnimate.layoutFormStackExpand();

      // 模拟滑动事件,覆盖calculateMoveDistance分支
      ret = slideAnimate.longitudinalSlideMove(0);
      expect(ret).assertTrue();

      // 模拟滑动事件
      ret = slideAnimate.longitudinalSlideMove(5);
      expect(ret).assertTrue();

      // 模拟滑动事件,覆盖calculateMoveDistance和isCardMoveNeedIgnore中分支
      ret = slideAnimate.longitudinalSlideMove(5, true, 1, EditCardCollapseType.BOTTOM_COLLAPSE);
      expect(ret).assertTrue();
      ret = slideAnimate.longitudinalSlideMove(5, true, 1, EditCardCollapseType.TOP_COLLAPSE);
      expect(ret).assertTrue();

      // ViewData校验
      viewData.mItemInfoList.forEach((item) => {
        expect(item.opacity).assertEqual(1);
      });
    });

    it('updateChildAnimAttr', 0, () => {
      // 要设置10张卡片，然后滑动到底部，把curSlide调到最大
      let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();
      // 构建ViewData等信息，用于初始化slideAnimate
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(10);
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();

      // 初始化Animate
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.initData(viewData, layoutModel);

      slideAnimate.initData(viewData, layoutAnimate, layoutModel);
      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(false);
      // 模拟触发layout布局
      layoutAnimate.layoutFormStackExpand();

      let len = viewData.mItemInfoList.length;
      let showSizePerPage: number = FormStackUtil.toFixNumber(layoutModel.mShowSizePerPage);
      const maxSlideValue: number = (len - layoutModel.mShowMaxCount) * showSizePerPage;

      // 模拟滑动事件,覆盖if分支
      let ret: boolean = slideAnimate.longitudinalSlideMove(maxSlideValue);
      expect(ret).assertTrue();

      // 模拟滑动事件
      ret = slideAnimate.longitudinalSlideMove(5);
      expect(ret).assertTrue();

      ret = slideAnimate.longitudinalSlideMove(5, true, 0, EditCardCollapseType.NONE);
      expect(ret).assertTrue();
    });

    it('heelSlideAnimate', 0, () => {
      let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();
      // 模拟滑动事件,slideAnimate未初始化
      let ret: boolean = slideAnimate.heelSlideAnimate(5, false, 0);
      expect(ret).assertFalse();

      // 构建ViewData等信息，用于初始化slideAnimate
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();

      // 初始化Animate
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.initData(viewData, layoutModel);

      slideAnimate.initData(viewData, layoutAnimate, layoutModel);

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(false);

      // 模拟触发layout布局
      layoutAnimate.layoutFormStackExpand();

      // 模拟滑动事件
      ret = slideAnimate.heelSlideAnimate(5, false, 0);
      expect(ret).assertTrue();
      // ViewData校验
      viewData.mItemInfoList.forEach((item) => {
        expect(item.opacity).assertEqual(1);
      });

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(true);
      // 模拟滑动事件
      ret = slideAnimate.heelSlideAnimate(5, false, 0);
      expect(ret).assertTrue();
    });

    it('longitudinalSlideEnd', 0, () => {
      let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();
      // 模拟滑动事件,slideAnimate未初始化
      slideAnimate.longitudinalSlideEnd(5, 0);

      // 构建ViewData等信息，用于初始化slideAnimate
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();

      // 初始化Animate
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.initData(viewData, layoutModel);

      slideAnimate.initData(viewData, layoutAnimate, layoutModel);

      // 模拟触发layout布局
      layoutAnimate.layoutFormStackExpand();

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(false);
      // 模拟滑动事件
      slideAnimate.longitudinalSlideEnd(5, 0);
      viewData.mItemInfoList.forEach((item) => {
        expect(item.isVisible).assertTrue();
      });

      let len = viewData.mItemInfoList.length;
      let showSizePerPage: number = FormStackUtil.toFixNumber(layoutModel.mShowSizePerPage);
      const maxSlideValue: number = (len - layoutModel.mShowMaxCount) * showSizePerPage;
      // 先滑动到end，然后再滑动一下，覆盖getFinalSlidingDistance函数中else if分支
      slideAnimate.longitudinalSlideEnd(maxSlideValue + 1, 0);
      slideAnimate.longitudinalSlideEnd(5, 0);

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(true);
      // 模拟滑动事件
      slideAnimate.longitudinalSlideEnd(5, 0);
      viewData.mItemInfoList.forEach((item) => {
        expect(item.isVisible).assertTrue();
      });
    });

    it('longitudinalSlideMoveAnimate', 0, () => {
      let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();

      // 构建ViewData等信息，用于初始化slideAnimate
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      // 初始化Animate
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.initData(viewData, layoutModel);

      slideAnimate.initData(viewData, layoutAnimate, layoutModel);

      // 模拟触发layout布局
      layoutAnimate.layoutFormStackExpand();

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(false);
      // 模拟滑动事件
      slideAnimate.longitudinalSlideMoveAnimate(5);
      viewData.mItemInfoList.forEach((item) => {
        expect(item.isVisible).assertTrue();
      });

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(true);
      // 模拟滑动事件
      slideAnimate.longitudinalSlideMoveAnimate(5, 0, EditCardCollapseType.NONE);
      viewData.mItemInfoList.forEach((item) => {
        expect(item.isVisible).assertTrue();
      });
    });

    it('execSlideMoveBySwapping', 0, () => {
      let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();

      // 构建ViewData等信息，用于初始化slideAnimate
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
      let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
      // 初始化Animate
      let layoutAnimate: FormStackExpandLayoutAnimate = new FormStackExpandLayoutAnimate();
      layoutAnimate.initData(viewData, layoutModel);

      slideAnimate.initData(viewData, layoutAnimate, layoutModel);

      // 模拟触发layout布局
      layoutAnimate.layoutFormStackExpand();

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(false);
      // 模拟滑动事件
      slideAnimate.execSlideMoveBySwapping(5, 0);
      expect(viewData.mItemInfoList.length).assertLarger(0);

      // 动画开关, animateTo打桩
      when(mockIsNeedExpandAnimate)().afterReturn(true);
      // 模拟滑动事件
      slideAnimate.execSlideMoveBySwapping(5, 0);
      expect(viewData.mItemInfoList.length).assertLarger(0);
    });

    let slideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();
    let formStackExpandItem: FormStackExpandItem = new FormStackExpandItem();
    let itemList: FormStackExpandItem[] = [formStackExpandItem, formStackExpandItem, formStackExpandItem];
    let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData();
    let layoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();

    it('slideMoveBySwapping_test01', 0, () => {
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test02', 0, () => {
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = undefined;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test03', 0, () => {
      layoutModel.mChildEndTranslateYList = [1, 2];
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test04', 0, () => {
      layoutModel.mChildEndTranslateYList = [1, 2, 3];
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test05', 0, () => {
      layoutModel.mChildEndTranslateYList = [1, 2, 3];
      layoutModel.mShowSizePerPage = 0;
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test06', 0, () => {
      layoutModel.mChildEndTranslateYList = [1, 2, 3];
      layoutModel.mShowSizePerPage = 1;
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test07', 0, () => {
      layoutModel.mChildEndTranslateYList = [1, 2, 3];
      layoutModel.mShowSizePerPage = 1;
      layoutModel.mPreShowSize = 0;
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('slideMoveBySwapping_test08', 0, () => {
      layoutModel.mChildEndTranslateYList = [1, 2, 3];
      layoutModel.mShowSizePerPage = 1;
      layoutModel.mPreShowSize = 1;
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (slideAnimate as object)['slideMoveBySwapping'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('initLongitudinalSlideEndAnimate_test01', 0, () => {
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = undefined;
      (slideAnimate as object)['initLongitudinalSlideEndAnimate'](1, 1);
      expect(slideAnimate).not().assertUndefined();
    });

    it('initLongitudinalSlideEndAnimate_test02', 0, () => {
      viewData.mItemInfoList = itemList;
      (slideAnimate as object)['mViewData'] = viewData;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((slideAnimate as object), (slideAnimate as object)['getFinalSlidingDistance']);
      let mockFunc1 = mocker.mockFunc((slideAnimate as object), (slideAnimate as object)['longitudinalSlideMove']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      (slideAnimate as object)['initLongitudinalSlideEndAnimate'](1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear((slideAnimate as object));
    });

    it('getFinalSlidingDistance_test01', 0, () => {
      layoutModel.mChildInitTranslateYList = [1, 2];
      (slideAnimate as object)['getFinalSlidingDistance'](layoutModel, itemList, 1, 1);
      expect(slideAnimate).not().assertUndefined();
    });

    it('getFinalSlidingDistance_test02', 0, () => {
      layoutModel.mChildInitTranslateYList = [1, 2, 3];
      layoutModel.mShowMaxCount = 1;
      (slideAnimate as object)['mCurrentSlideValue'] = 5;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.toFixNumber);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      (slideAnimate as object)['getFinalSlidingDistance'](layoutModel, itemList, 1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('getFinalSlidingDistance_test03', 0, () => {
      layoutModel.mChildInitTranslateYList = [1, 2, 3];
      layoutModel.mShowMaxCount = 1;
      (slideAnimate as object)['mCurrentSlideValue'] = 3;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.toFixNumber);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      (slideAnimate as object)['getFinalSlidingDistance'](layoutModel, itemList, 1, 1);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('updateChildAnimAttr_test01', 0, () => {
      (slideAnimate as object)['mLayoutModel'] = undefined;
      (slideAnimate as object)['updateChildAnimAttr']();
      expect(slideAnimate).not().assertUndefined();
    });

    it('updateChildAnimAttrBySwapping_test01', 0, () => {
      (slideAnimate as object)['mLayoutModel'] = undefined;
      (slideAnimate as object)['updateChildAnimAttrBySwapping']();
      expect(slideAnimate).not().assertUndefined();
    });

    it('getHandsOffDistance_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (slideAnimate as object)['getHandsOffDistance'](itemList, 1, 2, 3);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('getHandsOffDistance_test02', 0, () => {
      layoutModel.mShowMaxCount = 1;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.toFixNumber);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(2);
      (slideAnimate as object)['getHandsOffDistance'](itemList, 100, 2, 0);
      expect(slideAnimate).not().assertUndefined();

      (slideAnimate as object)['getHandsOffDistance'](itemList, 100, -1, 0);
      expect(slideAnimate).not().assertUndefined();

      (slideAnimate as object)['getHandsOffDistance'](itemList, 1, -1, 0);
      expect(slideAnimate).not().assertUndefined();

      (slideAnimate as object)['getHandsOffDistance'](itemList, 1, -1, 1200);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('getHandsOffDistance_test03', 0, () => {
      layoutModel.mShowMaxCount = 1;
      (slideAnimate as object)['mLayoutModel'] = layoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
      let mockFunc1 = mocker.mockFunc(FormStackUtil, FormStackUtil.toFixNumber);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(20);
      (slideAnimate as object)['getHandsOffDistance'](itemList, 100, 2, 0);
      expect(slideAnimate).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });
  });
}

async function createImage(width: number, height: number): Promise<image.PixelMap> {
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: width, width: height } };
  return image.createPixelMap(color, opts);
}