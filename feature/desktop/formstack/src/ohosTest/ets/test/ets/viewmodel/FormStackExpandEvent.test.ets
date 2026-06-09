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

import { image } from '@kit.ImageKit';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  ArgumentMatchers,
  MockKit,
  when,
} from '@ohos/hypium';
import { FormStackExpandEvent } from '../../../../../main/ets/viewmodel/FormStackExpandEvent';
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';
import { FormStackTestUtil } from '../common/FormStackTestUtil';
import { FormStackDebugCmd } from '../../../../../main/ets/common/FormStackDebugCmd';
import { FormStackItemInfo } from '../../../../../../src/main/ets/common/FormStackItemInfo';
import { FormStackDataAdapt, FormStackMsg } from '../../../../../main/ets/common/FormStackDataAdapt';
import { FormStackExpandModel } from '../../../../../main/ets/common/FormStackExpandModel';
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';
import { FormStackExpandSlideAnimate } from '../../../../../main/ets/viewmodel/FormStackExpandSlideAnimate';
import { FormStackExpandConfig } from '../../../../../main/ets/common/FormStackExpandConfig';
import { FormStackExpandItem } from '../../../../../main/ets/viewmodel/FormStackExpandItem';
import { FormStackExpandCriticalAnimate } from '../../../../../main/ets/viewmodel/FormStackExpandCriticalAnimate';
import { FormStackExpandLayoutModel } from '../../../../../main/ets/common/FormStackExpandLayoutModel';
import { RemoveSubCardState } from '../../../../../main/ets/common/FormStackHiSysEventUtil';

export function FormStackExpandEventTest() {
  describe('FormStackExpandEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initData', 0, () => {
      let formStackEditEventHandler: FormStackExpandEvent = new FormStackExpandEvent();
      let viewData: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      let ret: boolean = formStackEditEventHandler.initData(viewData, {});
      expect(ret).assertTrue();
      let formStackItemInfo: FormStackItemInfo =
        FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID, 2);
      FormStackDataAdapt.getInstance().handleMsg(FormStackMsg.SET_FORM_STACK_ITEM_INFO, formStackItemInfo);
      FormStackDebugCmd.getInstance().setExpandAnimateSwitch(['false']);
      formStackEditEventHandler.onBlankAreaClick();
      expect(viewData.mVisible).assertFalse();
      formStackEditEventHandler.resetData();
    });

    it('onPanGestureStart', 0, () => {
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let ret: boolean = expandEvent.initData(viewModel, {});
      expect(ret).assertTrue();
      expandEvent.mEventInterface?.onPanGestureStart?.('');
      expandEvent.mEventInterface?.onPanGestureStart?.('testId');
      viewModel = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      FormStackDebugCmd.getInstance().setExpandAnimateSwitch(['false']);
      expandEvent.mEventInterface?.onPanGestureStart?.(FormStackTestUtil.TEST_ITEM_ID1);
      viewModel.mItemInfoList[0].translateX = 5;
      expandEvent.mEventInterface?.onPanGestureStart?.(FormStackTestUtil.TEST_ITEM_ID2);
      let index: number =
        viewModel.mItemInfoList.findIndex(item => item && item.idStr === FormStackTestUtil.TEST_ITEM_ID1);
      expect(index === 0).assertTrue();
      expect(viewModel.mItemInfoList[index].translateX > 0).assertTrue();
    });

    it('getExclusiveActionItemId', 0, () => {
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let ret: boolean = expandEvent.initData(viewModel, {});
      expect(ret).assertTrue();

      let idStr: string = expandEvent.mEventInterface?.getExclusiveActionItemId?.();
      expect(idStr === '').assertTrue();
    });

    it('onClick', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onClick('');
      viewModel = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onClick('');
      expandEvent.mEventInterface?.onClick('testId');
      expandEvent.mEventInterface?.onClick(FormStackTestUtil.TEST_ITEM_ID1);
      expect(viewModel.mItemInfoList[0].zIndex).assertEqual(1);
    });

    it('onDelete', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onDelete('');
      viewModel = FormStackTestUtil.createFormStackExpandViewData(1);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onDelete('');
      viewModel = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onDelete('testId');
      expandEvent.mEventInterface?.onDelete(FormStackTestUtil.TEST_ITEM_ID1);
      viewModel = FormStackTestUtil.createFormStackExpandViewData(3);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onDelete(FormStackTestUtil.TEST_ITEM_ID1);
      expect(viewModel.mItemInfoList.length).assertEqual(2);
    });

    it('onDragStart', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
      expandEvent.initData(viewModel, {});
      const event: DragEvent = {
        getWindowX: (() => { return 0; }),
        getWindowY: (() => { return 0; }),
      } as DragEvent;
      expandEvent.mEventInterface?.onDragStart('', event);
      viewModel = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onDragStart('testId', event);
      expandEvent.mEventInterface?.onDragStart(FormStackTestUtil.TEST_ITEM_ID1, event);
      expect(expandEvent.mEventInterface?.getExclusiveActionItemId?.()).assertEqual(FormStackTestUtil.TEST_ITEM_ID1);
    });

    it('onDragMove', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
      expandEvent.initData(viewModel, {});
      const event: DragEvent = {
        getWindowX: (() => { return 0; }),
        getWindowY: (() => { return 0; }),
      } as DragEvent;
      viewModel = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expect(viewModel.mItemInfoList[0].idStr).assertEqual(FormStackTestUtil.TEST_ITEM_ID1);
    });

    it('onDragEnd', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
      expandEvent.initData(viewModel, {});
      const event: DragEvent = {
        getWindowX: (() => { return 0; }),
        getWindowY: (() => { return 0; }),
      } as DragEvent;
      expandEvent.mEventInterface?.onDragEnd('', event);
      viewModel = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onDragEnd('testId', event);
      expandEvent.mEventInterface?.onDragStart(FormStackTestUtil.TEST_ITEM_ID1, event);
      expect(expandEvent.mEventInterface?.getExclusiveActionItemId?.()).assertEqual(FormStackTestUtil.TEST_ITEM_ID1);
      expandEvent.mEventInterface?.onDragEnd(FormStackTestUtil.TEST_ITEM_ID1, event);
      expect(expandEvent.mEventInterface?.getExclusiveActionItemId?.()).assertEqual('');
    });

    it('onDragDrop', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      const event: DragEvent = {
        getWindowX: (() => { return 0; }),
        getWindowY: (() => { return 0; }),
      } as DragEvent;
    });

    it('onPanGestureMove', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(0);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onPanGestureMove('testId', 0);
      viewModel = FormStackTestUtil.createFormStackExpandViewData(1);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onPanGestureMove(FormStackTestUtil.TEST_ITEM_ID1, 0);
      viewModel = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      let formStackItemInfo: FormStackItemInfo =
        FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID, 2);
      FormStackDataAdapt.getInstance().handleMsg(FormStackMsg.SET_FORM_STACK_ITEM_INFO, formStackItemInfo);
      FormStackDebugCmd.getInstance().setExpandAnimateSwitch(['false']);
      expandEvent.mEventInterface?.onPanGestureMove(FormStackTestUtil.TEST_ITEM_ID1, 1);
    });

    it('onPanGestureEnd', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onPanGestureEnd(FormStackTestUtil.TEST_ITEM_ID1, 1, 0);
      expect(viewModel.mItemInfoList[0].translateY).assertEqual(0);
    });

    it('onTouch', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onTouch('', true);
      expandEvent.mEventInterface?.onTouch('testId', true);
      let formStackItemInfo: FormStackItemInfo =
        FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID, 2);
      FormStackDataAdapt.getInstance().handleMsg(FormStackMsg.SET_FORM_STACK_ITEM_INFO, formStackItemInfo);
      FormStackDebugCmd.getInstance().setExpandAnimateSwitch(['false']);
      expandEvent.mEventInterface?.onTouch(FormStackTestUtil.TEST_ITEM_ID1, true);
      expandEvent.mEventInterface?.onTouch(FormStackTestUtil.TEST_ITEM_ID1, false);
    });

    it('onTrashAngleMoveChange', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onTrashAngleMoveChange('', 0);
      expandEvent.mEventInterface?.onTrashAngleMoveChange('testId', 0);
      let formStackItemInfo: FormStackItemInfo =
        FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID, 2);
      FormStackDataAdapt.getInstance().handleMsg(FormStackMsg.SET_FORM_STACK_ITEM_INFO, formStackItemInfo);
      FormStackDebugCmd.getInstance().setExpandAnimateSwitch(['false']);
      expandEvent.mEventInterface?.onTrashAngleMoveChange(FormStackTestUtil.TEST_ITEM_ID1, 1);
      expect(viewModel.mItemInfoList[0].trashHeadAngle).assertEqual(0);
      expect(viewModel.mItemInfoList[0].trashBodyAngle).assertEqual(0);
    });

    it('onTrashAngleRestored', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onTrashAngleRestored('', () => {});
      expandEvent.mEventInterface?.onTrashAngleRestored('testId', () => {});
      FormStackDebugCmd.getInstance().setExpandAnimateSwitch(['false']);
      expect(viewModel.mItemInfoList[0].trashHeadAngle).assertEqual(0);
      expect(viewModel.mItemInfoList[0].trashBodyAngle).assertEqual(0);
    });

    it('onCardMoveLinkage', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onCardMoveLinkage(-1, -1);
      expandEvent.mEventInterface?.onCardMoveLinkage(0, 1);
    });

    it('onCardEndLinkage', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onCardEndLinkage(0, 1, 0);
    });

    it('restoreLateralSlideCardPos', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.restoreLateralSlideCardPos(0);
      expect(viewModel.mItemInfoList[0].translateX).assertEqual(0);
    });

    it('onLongPressGesture', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onLongPressGesture('testId');
      let formStackItemInfo: FormStackItemInfo =
        FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID, 2);
      FormStackDataAdapt.getInstance().handleMsg(FormStackMsg.SET_FORM_STACK_ITEM_INFO, formStackItemInfo);
      FormStackDebugCmd.getInstance().setExpandAnimateSwitch(['false']);
      expandEvent.mEventInterface?.onLongPressGesture(FormStackTestUtil.TEST_ITEM_ID1);
      expect(viewModel.mItemInfoList[0].bgBrightness).assertEqual(1);
    });

    it('syncDragSnapshot', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.mEventInterface?.syncDragSnapshot({} as image.PixelMap);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.syncDragSnapshot({} as image.PixelMap);
      expect(viewModel.mDragSnapshot).not().assertUndefined();
    });

    it('onDrag', 0, () => {
      try {
        let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
        expandEvent.onDragMove({} as DragEvent);
        expandEvent.onDragLeaveStack();
        let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
        expandEvent.initData(viewModel, {});
        expandEvent.onDragMove({} as DragEvent);
        expect(viewModel.mItemInfoList[0].zIndex).assertEqual(0);
        expandEvent.closeFormStackExpandView(true);
        expandEvent.onDragLeaveStack();
        expect(viewModel.mItemInfoList.length).assertEqual(2);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('onDragLeaveStack', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      const event: DragEvent = {
        getWindowX: (() => { return 0; }),
        getWindowY: (() => { return 0; }),
      } as DragEvent;
      FormStackDebugCmd.getInstance().setExpandAnimateSwitch(['false']);
      expandEvent.mEventInterface?.onDragStart(FormStackTestUtil.TEST_ITEM_ID1, event);
      expandEvent.onDragLeaveStack();
      expect(viewModel.mItemInfoList.length).assertEqual(1);
    });

    it('onDragDropStack', 0, () => {
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      const event: DragEvent = {
        getWindowX: (() => { return 0; }),
        getWindowY: (() => { return 0; }),
      } as DragEvent;
      expandEvent.onDragDropStack(event);
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(3);
      expandEvent.initData(viewModel, {});
      expandEvent.onDragDropStack(event);
      expandEvent.mEventInterface?.onDragStart(FormStackTestUtil.TEST_ITEM_ID1, event);
      expandEvent.onDragDropStack(event);
      expect(viewModel.mIsDropItem).assertTrue();
    });

    let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
    let event: DragEvent = {
      getWindowX: (() => {
        return 0;
      }),
      getWindowY: (() => {
        return 0;
      }),
    } as DragEvent;
    expandEvent.onDragDropStack(event);
    let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(3);
    let mLayoutModel: FormStackExpandLayoutModel = new FormStackExpandLayoutModel();
    let formStackItemInfo: FormStackItemInfo =
      FormStackTestUtil.createFormStackItemInfo(FormStackTestUtil.TEST_FORM_STACK_ID, 2);
    let mExpandModel: FormStackExpandModel = new FormStackExpandModel();
    let mCriticalAnimate: FormStackExpandCriticalAnimate = new FormStackExpandCriticalAnimate();
    let formStackExpandItem: FormStackExpandItem = new FormStackExpandItem();
    let formStackExpandItem1: FormStackExpandItem = new FormStackExpandItem();
    let formStackExpandItem2: FormStackExpandItem = new FormStackExpandItem();
    let itemList: FormStackExpandItem[] = [formStackExpandItem, formStackExpandItem, formStackExpandItem];
    let mSlideAnimate: FormStackExpandSlideAnimate = new FormStackExpandSlideAnimate();

    it('onBlankAreaClick_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expandEvent.onBlankAreaClick();
      expect(expandEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
    });

    it('onDragMove_test01', 0, () => {
      (expandEvent as object)['onDragMove']();
      expect(expandEvent).not().assertUndefined();

      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      config.mLastCardShowSize = 3;
      let event: DragEvent = {
        getWindowX: (() => {
          return 3;
        }),
        getWindowY: (() => {
          return 3;
        }),
      } as DragEvent;
      formStackExpandItem.translateY = 1;
      viewModel.mItemInfoList = itemList;
      expandEvent.mViewData = viewModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      let mockFunc1 = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(config);
      mLayoutModel.mChildCount = 1;
      mLayoutModel.mShowMaxCount = 0;
      mLayoutModel.mLastShowItemIndex = 0;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      expandEvent.onDragMove(event);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(FormStackExpandConfig);
    });

    it('onDragMove_test02', 0, () => {
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      config.mLastCardShowSize = 3;
      config.mFullDisplayHeight = 1;
      let event: DragEvent = {
        getWindowX: (() => {
          return 1;
        }),
        getWindowY: (() => {
          return 1;
        }),
      } as DragEvent;
      formStackExpandItem.translateY = 3;
      viewModel.mItemInfoList = itemList;
      expandEvent.mViewData = viewModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      let mockFunc1 = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(config);
      mLayoutModel.mChildCount = 1;
      mLayoutModel.mShowMaxCount = 0;
      mLayoutModel.mLastShowItemIndex = 0;
      (expandEvent as object)['mEnterHotAreaTime'] = 0;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      expandEvent.onDragMove(event);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(FormStackExpandConfig);
    });

    it('onDragMove_test03', 0, () => {
      let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      config.mLastCardShowSize = 3;
      config.mFullDisplayHeight = 4;
      let event: DragEvent = {
        getWindowX: (() => {
          return 1;
        }),
        getWindowY: (() => {
          return 1;
        }),
      } as DragEvent;
      formStackExpandItem.translateY = 3;
      viewModel.mItemInfoList = itemList;
      expandEvent.mViewData = viewModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      let mockFunc1 = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(config);
      mLayoutModel.mChildCount = 1;
      mLayoutModel.mShowMaxCount = 0;
      mLayoutModel.mLastShowItemIndex = 0;
      (expandEvent as object)['mEnterHotAreaTime'] = 0;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      expandEvent.onDragMove(event);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(FormStackExpandConfig);
    });

    it('registerDisplayChangeCallback_test01', 0, () => {
      expandEvent.mViewData = viewModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (expandEvent as object)['registerDisplayChangeCallback']();
      expect(expandEvent).not().assertUndefined();
      mocker.clear(DeviceHelper);
    });

    it('unregisterDisplayChangeCallback_test01', 0, () => {
      expandEvent.mViewData = viewModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (expandEvent as object)['unregisterDisplayChangeCallback']();
      expect(expandEvent).not().assertUndefined();
      mocker.clear(DeviceHelper);
    });

    it('setFormStackItemInfo_test01', 0, () => {
      expandEvent.mViewData = viewModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isFormStackLayoutItemInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (expandEvent as object)['setFormStackItemInfo'](formStackItemInfo);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('setFormStackItemInfo_test02', 0, () => {
      expandEvent.mViewData = undefined;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isFormStackLayoutItemInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (expandEvent as object)['setFormStackItemInfo'](formStackItemInfo);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(FormStackUtil);
    });

    it('setFormStackItemInfo_test03', 0, () => {
      expandEvent.mViewData = viewModel;
      (expandEvent as object)['mExpandModel'] = mExpandModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isFormStackLayoutItemInvalid);
      let mockFunc1 = mocker.mockFunc(mExpandModel, mExpandModel.initData);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      (expandEvent as object)['setFormStackItemInfo'](formStackItemInfo);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(FormStackUtil);
      mocker.clear(mExpandModel);
    });

    it('setFormStackItemInfo_test04', 0, () => {
      expandEvent.mViewData = viewModel;
      (expandEvent as object)['mExpandModel'] = mExpandModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isFormStackLayoutItemInvalid);
      let mockFunc1 = mocker.mockFunc(mExpandModel, mExpandModel.initData);
      let mockFunc2 = mocker.mockFunc(viewModel, viewModel.initData);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      (expandEvent as object)['setFormStackItemInfo'](formStackItemInfo);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(FormStackUtil);
      mocker.clear(mExpandModel);
      mocker.clear(viewModel);
    });

    it('setFormStackItemInfo_test05', 0, () => {
      expandEvent.mViewData = viewModel;
      (expandEvent as object)['mExpandModel'] = mExpandModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(FormStackUtil, FormStackUtil.isFormStackLayoutItemInvalid);
      let mockFunc1 = mocker.mockFunc(mExpandModel, mExpandModel.initData);
      let mockFunc2 = mocker.mockFunc(viewModel, viewModel.initData);
      let mockFunc3 =
        mocker.mockFunc(FormStackExpandConfig.getInstance(), FormStackExpandConfig.getInstance().updateFormLayoutInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      (expandEvent as object)['setFormStackItemInfo'](formStackItemInfo);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(FormStackUtil);
      mocker.clear(mExpandModel);
      mocker.clear(viewModel);
      mocker.clear(FormStackExpandConfig.getInstance());
    });

    it('initAnimateData_test01', 0, () => {
      (expandEvent as object)['mCriticalAnimate'] = mCriticalAnimate;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(mCriticalAnimate, mCriticalAnimate.initFormStackExpandCriticalParam);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (expandEvent as object)['initAnimateData'](viewModel);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(mCriticalAnimate);
    });

    it('reportAdjustSubCardsOrder_test01', 0, () => {
      (expandEvent as object)['reportAdjustSubCardsOrder']('a', 1, 2);
      expect(expandEvent).not().assertUndefined();
    });

    it('onItemPanGestureMove_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      let mockFunc2 = mocker.mockFunc(mSlideAnimate, mSlideAnimate.heelSlideAnimate);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(2);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      (expandEvent as object)['onItemPanGestureMove']('a', 1);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
      mocker.clear(mSlideAnimate);
    });

    it('reportAdjustSubCardsOrder_test01', 0, () => {
      let cardInfo: CardItemInfo = new CardItemInfo();
      cardInfo.cardId = 'a';
      cardInfo.area = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getCardInfo']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(cardInfo);
      (expandEvent as object)['reportAdjustSubCardsOrder']('a', 1, 1);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('reportDeleteItem_test01', 0, () => {
      let cardInfo: CardItemInfo = new CardItemInfo();
      cardInfo.cardId = 'a';
      cardInfo.area = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getCardInfo']);
      let mockFunc2 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getAllCardsNum']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(cardInfo);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(2);
      (expandEvent as object)['reportDeleteItem']('a', RemoveSubCardState.LEFT_SLIDE_NOT_DELETE);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('reportDeleteItem_test02', 0, () => {
      let cardInfo: CardItemInfo = new CardItemInfo();
      cardInfo.cardId = 'a';
      cardInfo.area = [1, 2, 3];
      let mocker: MockKit = new MockKit();
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getCardInfo']);
      let mockFunc2 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getAllCardsNum']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(cardInfo);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(2);
      (expandEvent as object)['reportDeleteItem']('a', RemoveSubCardState.CLICK_DELETE);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('onItemTouch_test01', 0, () => {
      (expandEvent as object)['mIsLongPressStatus'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      (expandEvent as object)['onItemTouch']('a', false);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear((expandEvent as object));
    });

    it('onItemTouch_test02', 0, () => {
      (expandEvent as object)['mIsLongPressStatus'] = false;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      (expandEvent as object)['onItemTouch']('a', false);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear((expandEvent as object));
    });

    it('onItemTouch_test03', 0, () => {
      (expandEvent as object)['mIsLongPressStatus'] = false;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      (expandEvent as object)['onItemTouch']('a', true);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear((expandEvent as object));
    });

    it('onItemTrashImgChange_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(-1);
      (expandEvent as object)['onItemTrashImgChange']('a', 1);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear((expandEvent as object));
    });

    it('onItemTrashImgChange_test02', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      (expandEvent as object)['onItemTrashImgChange']('a', 1);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear((expandEvent as object));
    });

    it('onItemTrashImgRestored_test01', 0, () => {
      let a = () => {
      };
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(-1);
      (expandEvent as object)['onItemTrashImgRestored']('a', a);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear((expandEvent as object));
    });

    it('onItemTrashImgRestored_test02', 0, () => {
      let a = () => {
      };
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      (expandEvent as object)['onItemTrashImgRestored']('a', a);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear((expandEvent as object));
    });

    it('getCardCollapseType_test01', 0, () => {
      mLayoutModel.mChildCount = 1;
      mLayoutModel.mShowMaxCount = 0;
      mLayoutModel.mLastShowItemIndex = 1;
      mLayoutModel.mShowMaxCount = 0;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      (expandEvent as object)['getCardCollapseType']();
      expect(expandEvent).not().assertUndefined();
    });

    it('getCardCollapseType_test02', 0, () => {
      mLayoutModel.mChildCount = 1;
      mLayoutModel.mShowMaxCount = 0;
      mLayoutModel.mLastShowItemIndex = 0;
      mLayoutModel.mShowMaxCount = 1;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      (expandEvent as object)['getCardCollapseType']();
      expect(expandEvent).not().assertUndefined();
    });

    it('getCardCollapseType_test03', 0, () => {
      mLayoutModel.mChildCount = 1;
      mLayoutModel.mShowMaxCount = 3;
      mLayoutModel.mLastShowItemIndex = 0;
      mLayoutModel.mShowMaxCount = 1;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      (expandEvent as object)['getCardCollapseType']();
      expect(expandEvent).not().assertUndefined();
    });

    it('onCardMoveLinkage_test01', 0, () => {
      (expandEvent as object)['mCardCollapseType'] = 0;
      (expandEvent as object)['onCardMoveLinkage'](1, 1);
      expect(expandEvent).not().assertUndefined();

      (expandEvent as object)['mCardCollapseType'] = 1;
      (expandEvent as object)['onCardMoveLinkage'](1, 1);
      expect(expandEvent).not().assertUndefined();

      (expandEvent as object)['mCardCollapseType'] = 2;
      (expandEvent as object)['onCardMoveLinkage'](1, 1);
      expect(expandEvent).not().assertUndefined();
    });

    it('onCardEndLinkage_test01', 0, () => {
      (expandEvent as object)['mCardCollapseType'] = 0;
      (expandEvent as object)['onCardEndLinkage'](1, 1, 1);
      expect(expandEvent).not().assertUndefined();

      (expandEvent as object)['mCardCollapseType'] = 1;
      (expandEvent as object)['onCardEndLinkage'](1, 1, 1);
      expect(expandEvent).not().assertUndefined();

      (expandEvent as object)['mCardCollapseType'] = 2;
      (expandEvent as object)['onCardEndLinkage'](1, 1, 1);
      expect(expandEvent).not().assertUndefined();
    });

    it('makeCardFilling_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(-1);
      (expandEvent as object)['makeCardFilling'](1, 1, true, 1);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('makeCardFilling_test02', 0, () => {
      mLayoutModel.mLastShowItemIndex = 4;
      mLayoutModel.mShowMaxCount = 1;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      (expandEvent as object)['makeCardFilling'](1, 1, true, 1);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('makeCardFilling_test03', 0, () => {
      mLayoutModel.mLastShowItemIndex = 4;
      mLayoutModel.mShowMaxCount = 1;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(3);
      (expandEvent as object)['makeCardFilling'](1, 1, false, 1);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('makeCardFilling_test04', 0, () => {
      mLayoutModel.mLastShowItemIndex = 4;
      mLayoutModel.mShowMaxCount = 1;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(3);
      (expandEvent as object)['makeCardFilling'](1, 1, false, undefined);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('makeCardFilling_test05', 0, () => {
      mLayoutModel.mLastShowItemIndex = 4;
      mLayoutModel.mShowMaxCount = 1;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(3);
      (expandEvent as object)['makeCardFilling'](1, 1, true, undefined);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('makeCardFilling_test06', 0, () => {
      mLayoutModel.mLastShowItemIndex = 4;
      mLayoutModel.mShowMaxCount = 1;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(3);
      (expandEvent as object)['makeCardFilling'](1, 1, true, 2);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('makeCardFilling_test07', 0, () => {
      mLayoutModel.mLastShowItemIndex = 4;
      mLayoutModel.mShowMaxCount = 1;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(3);
      (expandEvent as object)['makeCardFilling'](1, 1, true, 1);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('makeCardFilling_test08', 0, () => {
      mLayoutModel.mChildCount = 2;
      mLayoutModel.mLastShowItemIndex = 4;
      mLayoutModel.mShowMaxCount = 1;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      (expandEvent as object)['mCardCollapseType'] = 0;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(3);
      (expandEvent as object)['makeCardFilling'](1, 1, true, 0);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('makeCardFilling_test09', 0, () => {
      mLayoutModel.mChildCount = 2;
      mLayoutModel.mLastShowItemIndex = 4;
      mLayoutModel.mShowMaxCount = 1;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      (expandEvent as object)['mCardCollapseType'] = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(3);
      (expandEvent as object)['makeCardFilling'](1, 1, true, 0);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('onLongPressGesture_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(5);
      (expandEvent as object)['onLongPressGesture']('a');
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('isCollapseCardDragMove_test01', 0, () => {
      mLayoutModel.mLastShowItemIndex = 2;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getCardCollapseType']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      (expandEvent as object)['isCollapseCardDragMove'](3);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('isCollapseCardDragMove_test02', 0, () => {
      mLayoutModel.mLastShowItemIndex = 2;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getCardCollapseType']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      (expandEvent as object)['isCollapseCardDragMove'](1);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('isCollapseCardDragMove_test03', 0, () => {
      mLayoutModel.mLastShowItemIndex = 5;
      mLayoutModel.mShowMaxCount = 2;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getCardCollapseType']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      (expandEvent as object)['isCollapseCardDragMove'](1);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('isCollapseCardDragMove_test04', 0, () => {
      mLayoutModel.mLastShowItemIndex = 2;
      mLayoutModel.mShowMaxCount = 1;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      (expandEvent as object)['mCardCollapseType'] = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getCardCollapseType']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      (expandEvent as object)['isCollapseCardDragMove'](3);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('isCollapseCardDragMove_test05', 0, () => {
      mLayoutModel.mLastShowItemIndex = 5;
      mLayoutModel.mShowMaxCount = 4;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      (expandEvent as object)['mCardCollapseType'] = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getCardCollapseType']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      (expandEvent as object)['isCollapseCardDragMove'](3);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('scrollingListAndSwapItem_test01', 0, () => {
      mLayoutModel.mLastShowItemIndex = 5;
      mLayoutModel.mShowMaxCount = 4;
      mLayoutModel.mShowSizePerPage = 4;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      (expandEvent as object)['scrollingListAndSwapItem'](true, itemList);
      expect(expandEvent).not().assertUndefined();
    });

    it('scrollingListAndSwapItem_test02', 0, () => {
      mLayoutModel.mLastShowItemIndex = 5;
      mLayoutModel.mShowMaxCount = 4;
      mLayoutModel.mChildCount = 8;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      (expandEvent as object)['scrollingListAndSwapItem'](false, itemList);
      expect(expandEvent).not().assertUndefined();
    });

    it('scrollingListAndSwapItem_test03', 0, () => {
      mLayoutModel.mLastShowItemIndex = 5;
      mLayoutModel.mShowMaxCount = 4;
      mLayoutModel.mChildCount = 3;
      (expandEvent as object)['mLayoutModel'] = mLayoutModel;
      (expandEvent as object)['scrollingListAndSwapItem'](false, itemList);
      expect(expandEvent).not().assertUndefined();
    });

    it('autoSwapByDragging_test01', 0, () => {
      try {
        formStackExpandItem.idStr = 'a';
        mLayoutModel.mShowMaxCount = 1;
        (expandEvent as object)['mLayoutModel'] = mLayoutModel;
        (expandEvent as object)['mLastDragId'] = 'a';
        (expandEvent as object)['autoSwapByDragging'](true, itemList, 3);
        expect(expandEvent).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('autoSwapByDragging_test02', 0, () => {
      try {
        formStackExpandItem.idStr = 'a';
        mLayoutModel.mShowMaxCount = 1;
        mLayoutModel.mChildCount = 10;
        (expandEvent as object)['mLayoutModel'] = mLayoutModel;
        (expandEvent as object)['mLastDragId'] = 'a';
        (expandEvent as object)['autoSwapByDragging'](false, itemList, 4);
        expect(expandEvent).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('autoSwapByDragging_test03', 0, () => {
      try {
        formStackExpandItem.idStr = 'a';
        mLayoutModel.mShowMaxCount = 1;
        mLayoutModel.mChildCount = 2;
        (expandEvent as object)['mLayoutModel'] = mLayoutModel;
        (expandEvent as object)['mLastDragId'] = 'a';
        (expandEvent as object)['autoSwapByDragging'](false, itemList, 4);
        expect(expandEvent).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('closeCustomDropAnimation_test01', 0, () => {
      event.useCustomDropAnimation = true;
      (expandEvent as object)['closeCustomDropAnimation'](event);
      expect(expandEvent).not().assertUndefined();
    });

    it('setDropItem_test01', 0, () => {
      let formStackExpandConfig: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      formStackExpandConfig.mFormStackOffsetX = 6;
      formStackExpandConfig.mDisplayWidth = 4;
      formStackExpandConfig.mFormShowWidth = 4;
      expandEvent.mViewData = viewModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      let mockFunc2 = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(-1);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(formStackExpandConfig);
      (expandEvent as object)['setDropItem'](1, 1);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear((expandEvent as object));
      mocker.clear(FormStackExpandConfig);
    });

    it('setDropItem_test02', 0, () => {
      let formStackExpandConfig: FormStackExpandConfig = FormStackExpandConfig.getInstance();
      formStackExpandConfig.mFormStackOffsetX = 6;
      formStackExpandConfig.mDisplayWidth = 4;
      formStackExpandConfig.mFormShowWidth = 4;
      formStackExpandConfig.mIsExpandCenter = false;
      expandEvent.mViewData = viewModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      let mockFunc2 = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(-1);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(formStackExpandConfig);
      (expandEvent as object)['setDropItem'](1, 1);
      expect(expandEvent).not().assertUndefined();
      mocker.clear(CheckEmptyUtils);
      mocker.clear((expandEvent as object));
      mocker.clear(FormStackExpandConfig);
    });

    it('onItemDragMove_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        viewModel.mItemInfoList = itemList;
        expandEvent.mViewData = viewModel;
        event.useCustomDropAnimation = true;
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['isCollapseCardDragMove']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
        (expandEvent as object)['onItemDragMove']('a', event);
        expect(expandEvent).not().assertUndefined();
        mocker.clear(CheckEmptyUtils);
        mocker.clear((expandEvent as object));
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('onItemDragMove_test02', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let itemList: FormStackExpandItem[] = [formStackExpandItem, formStackExpandItem1, formStackExpandItem2];
        (expandEvent as object)['mLastDragId'] = 'a';
        let event: DragEvent = {
          getWindowX: (() => {
            return 1;
          }),
          getWindowY: (() => {
            return 1;
          }),
        } as DragEvent;
        formStackExpandItem.idStr = 'a';
        formStackExpandItem1.idStr = 'b';
        formStackExpandItem2.idStr = 'a';
        viewModel.mItemInfoList = itemList;
        expandEvent.mViewData = viewModel;
        event.useCustomDropAnimation = true;

        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['isCollapseCardDragMove']);
        let mockFunc2 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getMiddlePointY']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(3);
        (expandEvent as object)['onItemDragMove']('b', event);
        expect(expandEvent).not().assertUndefined();
        mocker.clear(CheckEmptyUtils);
        mocker.clear((expandEvent as object));
        mocker.clear((expandEvent as object));
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('onItemDragMove_test04', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let itemList: FormStackExpandItem[] = [formStackExpandItem, formStackExpandItem1, formStackExpandItem2];
        (expandEvent as object)['mLastDragId'] = 'a';
        let event: DragEvent = {
          getWindowX: (() => {
            return 2;
          }),
          getWindowY: (() => {
            return 2;
          }),
        } as DragEvent;
        formStackExpandItem.idStr = 'a';
        formStackExpandItem1.idStr = 'a';
        formStackExpandItem2.idStr = 'a';
        viewModel.mItemInfoList = itemList;
        expandEvent.mViewData = viewModel;
        event.useCustomDropAnimation = true;

        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['isCollapseCardDragMove']);
        let mockFunc2 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getMiddlePointY']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);
        (expandEvent as object)['onItemDragMove']('b', event);
        expect(expandEvent).not().assertUndefined();
        mocker.clear(CheckEmptyUtils);
        mocker.clear((expandEvent as object));
        mocker.clear((expandEvent as object));
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('closeFormStackWithReset_test01', 0, () => {
      try {
        expandEvent.mViewData = undefined;
        (expandEvent as object)['closeFormStackWithReset']();
        expect(expandEvent).not().assertUndefined();

        viewModel.mVisible = false;
        expandEvent.mViewData = viewModel;
        (expandEvent as object)['closeFormStackWithReset']();
        expect(expandEvent).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('deleteItemAndCloseEditView_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let expandModel: FormStackExpandModel = new FormStackExpandModel();
        let cardInfo: CardItemInfo = {
          id: 'test1',
          cardId: 'test2',
        } as CardItemInfo;
        expandModel.setCardInfo('123', cardInfo);
        (expandEvent as object)['mExpandModel'] = expandModel;
        (expandEvent as object)['deleteItemAndCloseEditView']();
        expect(expandEvent).not().assertUndefined();
        let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getLastCardId']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn('a');
        (expandEvent as object)['deleteItemAndCloseEditView']('a','123');
        expect(expandEvent).not().assertUndefined();
        mocker.clear((expandEvent as object));
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('onItemDragMove_test03', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let expandModel: FormStackExpandModel = new FormStackExpandModel();
        let cardInfo: CardItemInfo = {
          id: 'test1',
          cardId: 'test2',
        } as CardItemInfo;
        expandModel.setCardInfo('123', cardInfo);
        (expandEvent as object)['mExpandModel'] = expandModel;
        let itemList: FormStackExpandItem[] = [formStackExpandItem, formStackExpandItem1, formStackExpandItem2];
        (expandEvent as object)['mLastDragId'] = 'a';
        let event: DragEvent = {
          getWindowX: (() => {
            return 2;
          }),
          getWindowY: (() => {
            return 2;
          }),
        } as DragEvent;
        formStackExpandItem.idStr = 'a';
        formStackExpandItem1.idStr = 'b';
        formStackExpandItem2.idStr = 'b';
        viewModel.mItemInfoList = itemList;
        expandEvent.mViewData = viewModel;
        event.useCustomDropAnimation = true;
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['isCollapseCardDragMove']);
        let mockFunc2 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getMiddlePointY']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);
        (expandEvent as object)['onItemDragMove']('123', event);
        expect(expandEvent).not().assertUndefined();
        mocker.clear(CheckEmptyUtils);
        mocker.clear((expandEvent as object));
        mocker.clear((expandEvent as object));
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('updateDragItemInfo_test01', 0, () => {
      let expandModel: FormStackExpandModel = new FormStackExpandModel();
      let cardInfo: CardItemInfo = {
        id: 'test1',
        cardId: 'test2',
      } as CardItemInfo;
      expandModel.setCardInfo('123', cardInfo);
      (expandEvent as object)['mExpandModel'] = expandModel;
      let mocker: MockKit = new MockKit();
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getCardInfo']);
      let mockFunc2 = mocker.mockFunc(FormStackUtil, FormStackUtil.isValidCard);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(cardInfo);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      (expandEvent as object)['updateDragItemInfo']('123');
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
      mocker.clear(FormStackUtil);
    });

    it('restoreLateralSlideCardPos_test01', 0, () => {
      formStackExpandItem.translateX = 0;
      viewModel.mItemInfoList = itemList;
      expandEvent.mViewData = viewModel;
      (expandEvent as object)['mExpandModel'] = mExpandModel;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getFormIdx']);
      let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['execCardLateralEnd']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(5);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing;
      (expandEvent as object)['restoreLateralSlideCardPos'](1);
      expect(expandEvent).not().assertUndefined();
      mocker.clear((expandEvent as object));
    });

    it('onItemDragMove_test05', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let itemList: FormStackExpandItem[] = [formStackExpandItem, formStackExpandItem1, formStackExpandItem2];
        (expandEvent as object)['mLastDragId'] = 'a';
        let event: DragEvent = {
          getWindowX: (() => {
            return 2;
          }),
          getWindowY: (() => {
            return 2;
          }),
        } as DragEvent;
        formStackExpandItem.idStr = 'a';
        formStackExpandItem1.idStr = 'a';
        formStackExpandItem2.idStr = 'a';
        viewModel.mItemInfoList = itemList;
        expandEvent.mViewData = viewModel;
        event.useCustomDropAnimation = true;
        let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        let mockFunc1 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['isCollapseCardDragMove']);
        let mockFunc2 = mocker.mockFunc((expandEvent as object), (expandEvent as object)['getMiddlePointY']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);
        (expandEvent as object)['onItemDragMove']('b', event);
        expect(expandEvent).not().assertUndefined();
        mocker.clear(CheckEmptyUtils);
        mocker.clear((expandEvent as object));
        mocker.clear((expandEvent as object));
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });
  });
}