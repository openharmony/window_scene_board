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
} from '@ohos/hypium';
import { FormStackExpandEvent } from '../../../../../main/ets/viewmodel/FormStackExpandEvent';
import { FormStackExpandViewData } from '../../../../../main/ets/viewmodel/FormStackExpandViewData';
import { FormStackTestUtil } from '../common/FormStackTestUtil';
import { FormStackDebugCmd } from '../../../../../main/ets/common/FormStackDebugCmd';
import { FormStackItemInfo } from '../../../../../../src/main/ets/common/FormStackItemInfo';
import { FormStackDataAdapt, FormStackMsg } from '../../../../../main/ets/common/FormStackDataAdapt';

export function FormStackExpandEventBackupTest() {
  describe('FormStackExpandEventBackupTest', () => {
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
      expandEvent.mEventInterface?.onDragMove('', undefined);
      expandEvent.mEventInterface?.onDragMove('', event);
      expandEvent.mEventInterface?.onDragMove('testId', event);
      viewModel = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.mEventInterface?.onDragMove(FormStackTestUtil.TEST_ITEM_ID1, event);
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
      expandEvent.mEventInterface?.onDragDrop('', event);
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
      let expandEvent: FormStackExpandEvent = new FormStackExpandEvent();
      expandEvent.onDragEnter();
      expandEvent.onDragMove({} as DragEvent);
      expandEvent.onDragLeaveStack();
      let viewModel: FormStackExpandViewData = FormStackTestUtil.createFormStackExpandViewData(2);
      expandEvent.initData(viewModel, {});
      expandEvent.onDragMove({} as DragEvent);
      expect(viewModel.mItemInfoList[0].zIndex).assertEqual(0);
      expandEvent.closeFormStackExpandView(true);
      expandEvent.onDragLeaveStack();
      expect(viewModel.mItemInfoList.length).assertEqual(2);
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
  });
}