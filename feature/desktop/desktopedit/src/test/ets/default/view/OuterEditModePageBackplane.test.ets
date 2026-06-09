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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { DragConstants, DropAnimationEndReason } from '../../../../../../main/ets/component/constants/DragConstants';
import { DragEventManager } from '../../../../../../main/ets/component/manager/DragEventManager';
import { GlobalContext } from '../../../../../../main/ets/TsIndex';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import type { DropAnimationParam } from '../../../../../../main/ets/component/utils/DropAnimationParam';
import type { DragEventCallback } from '../../../../../../main/ets/component/service/drag/DragEventCallback';

function checkNotFail(func: Function): void {
  expect(func()).not().assertFail();
}

export function OuterEditModePageBackplaneTest() {
  describe('OuterEditModePageBackplaneTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('DragEventManagerTest_getInstance_should_not_null', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragLeaveEvent_should_return_string', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_getDragStartEvent_should_return_string', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('DragEventManagerTest_getInstance_should_not_null01', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string01', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string01', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string01', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string01', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string01', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string01', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string01', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('DragEventManagerTest_getInstance_should_not_null02', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string02', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string02', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string02', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string02', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string02', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string02', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string02', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('DragEventManagerTest_getInstance_should_not_null03', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string03', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string03', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string03', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string03', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string03', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string03', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string03', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_isDropInDesktop03', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('test_registerDragEvent_unregisterDragEvent03', Level.LEVEL0, (): void => {
      let dragEventManager: DragEventManager = DragEventManager.getInstance();
      let validCallback: DragEventCallback = {};
      let validItemKey: number = 1;
      checkNotFail(() => dragEventManager.registerDragEvent(null, 0));
      checkNotFail(() => dragEventManager.registerDragEvent(validCallback, 0));
      checkNotFail(() => dragEventManager.registerDragEvent(validCallback, validItemKey));
      checkNotFail(() => dragEventManager.unRegisterDragEvent(null, 0));
      checkNotFail(() => dragEventManager.unRegisterDragEvent(validCallback, 0));
      checkNotFail(() => dragEventManager.unRegisterDragEvent(validCallback, validItemKey));
    })

    it('test_sendDragEvent203', Level.LEVEL0, (): void => {
      let groupId: string = 'groupId'
      let pageIndex: number = 10
      let result: number = 0;

      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex),
        (keyName: string): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex),
        (keyName: string): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex),
        (): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getStartDropAnimationEvent(groupId,
        pageIndex), (param: DropAnimationParam): void => { result = 1});

      DragEventManager.getInstance().dragStart(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      result = 0;
      DragEventManager.getInstance().dragEnter(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      result = 0;
      DragEventManager.getInstance().dragLeave(groupId, pageIndex);
      expect(result).assertEqual(0);

      result = 0;
      DragEventManager.getInstance().dragDrop(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex));
      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex));
      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex));
      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getStartDropAnimationEvent(groupId,
        pageIndex));
    })

    it('test_sendDragEvent2_no_content03', Level.LEVEL0, (): void => {
      let groupId: string = 'groupId'
      let pageIndex: number = 10
      let result: number = 0;

      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex),
        (keyName: string): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex),
        (keyName: string): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex),
        (): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getStartDropAnimationEvent(groupId,
        pageIndex), (param: DropAnimationParam): void => { result = 1});

      let tmp = GlobalContext.getContext();
      GlobalContext.setContext(null);

      DragEventManager.getInstance().dragStart(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      DragEventManager.getInstance().dragEnter(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      DragEventManager.getInstance().dragLeave(groupId, pageIndex);
      expect(result).assertEqual(0);

      DragEventManager.getInstance().dragDrop(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      GlobalContext.setContext(tmp);

      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex));
      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex));
      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex));
      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getStartDropAnimationEvent(groupId,
        pageIndex));
    })

    it('DragEventManagerTest_getInstance_should_not_null04', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string04', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string04', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string04', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string04', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string04', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string04', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string04', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_cancelDropAnimation04', Level.LEVEL0, (): void => {
      let context: ServiceExtensionContext = GlobalContext.getContext();
      if (context != null) {
        let dropAnimationEndReason: number = -1;
        let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
        context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(-1);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
        context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
      } else {
        checkNotFail(() => DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END));
      }
    })

    it('test_isDropInDesktop04', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('test_registerDragEvent_unregisterDragEvent04', Level.LEVEL0, (): void => {
      let dragEventManager: DragEventManager = DragEventManager.getInstance();
      let validCallback: DragEventCallback = {};
      let validItemKey: number = 1;
      checkNotFail(() => dragEventManager.registerDragEvent(null, 0));
      checkNotFail(() => dragEventManager.registerDragEvent(validCallback, 0));
      checkNotFail(() => dragEventManager.registerDragEvent(validCallback, validItemKey));
      checkNotFail(() => dragEventManager.unRegisterDragEvent(null, 0));
      checkNotFail(() => dragEventManager.unRegisterDragEvent(validCallback, 0));
      checkNotFail(() => dragEventManager.unRegisterDragEvent(validCallback, validItemKey));
    })

    it('test_sendDragEvent204', Level.LEVEL0, (): void => {
      let groupId: string = 'groupId'
      let pageIndex: number = 10
      let result: number = 0;

      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex),
        (keyName: string): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex),
        (keyName: string): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex),
        (): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getStartDropAnimationEvent(groupId,
        pageIndex), (param: DropAnimationParam): void => { result = 1});

      DragEventManager.getInstance().dragStart(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      result = 0;
      DragEventManager.getInstance().dragEnter(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      result = 0;
      DragEventManager.getInstance().dragLeave(groupId, pageIndex);
      expect(result).assertEqual(0);

      result = 0;
      DragEventManager.getInstance().dragDrop(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex));
      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex));
      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex));
      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getStartDropAnimationEvent(groupId,
        pageIndex));
    })

    it('test_sendDragEvent2_no_content04', Level.LEVEL0, (): void => {
      let groupId: string = 'groupId'
      let pageIndex: number = 10
      let result: number = 0;

      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex),
        (keyName: string): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex),
        (keyName: string): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex),
        (): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getStartDropAnimationEvent(groupId,
        pageIndex), (param: DropAnimationParam): void => { result = 1});

      let tmp = GlobalContext.getContext();
      GlobalContext.setContext(null);

      DragEventManager.getInstance().dragStart(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      DragEventManager.getInstance().dragEnter(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      DragEventManager.getInstance().dragLeave(groupId, pageIndex);
      expect(result).assertEqual(0);

      DragEventManager.getInstance().dragDrop(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      GlobalContext.setContext(tmp);

      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex));
      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex));
      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex));
      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getStartDropAnimationEvent(groupId,
        pageIndex));
    })

    it('DragEventManagerTest_getInstance_should_not_null05', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string05', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string05', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string05', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string05', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string05', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string05', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string05', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_cancelDropAnimation05', Level.LEVEL0, (): void => {
      let context: ServiceExtensionContext = GlobalContext.getContext();
      if (context != null) {
        let dropAnimationEndReason: number = -1;
        let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
        context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(-1);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
        context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
      } else {
        checkNotFail(() => DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END));
      }
    })

    it('test_isDropInDesktop05', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null06', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string06', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string06', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string06', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string06', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string06', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string06', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string06', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_cancelDropAnimation06', Level.LEVEL0, (): void => {
      let context: ServiceExtensionContext = GlobalContext.getContext();
      if (context != null) {
        let dropAnimationEndReason: number = -1;
        let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
        context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(-1);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
        context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
      } else {
        checkNotFail(() => DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END));
      }
    })

    it('test_isDropInDesktop06', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null07', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string07', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string07', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string07', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string07', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string07', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string07', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string07', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_cancelDropAnimation07', Level.LEVEL0, (): void => {
      let context: ServiceExtensionContext = GlobalContext.getContext();
      if (context != null) {
        let dropAnimationEndReason: number = -1;
        let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
        context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(-1);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
        context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
      } else {
        checkNotFail(() => DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END));
      }
    })

    it('test_isDropInDesktop07', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null08', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string08', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string08', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string08', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string08', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string08', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string08', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string08', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_cancelDropAnimation08', Level.LEVEL0, (): void => {
      let context: ServiceExtensionContext = GlobalContext.getContext();
      if (context != null) {
        let dropAnimationEndReason: number = -1;
        let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
        context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(-1);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
        context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
      } else {
        checkNotFail(() => DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END));
      }
    })

    it('test_isDropInDesktop08', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null09', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string09', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string09', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string09', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string09', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string09', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string09', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string09', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_cancelDropAnimation09', Level.LEVEL0, (): void => {
      let context: ServiceExtensionContext = GlobalContext.getContext();
      if (context != null) {
        let dropAnimationEndReason: number = -1;
        let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
        context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(-1);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
        context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
      } else {
        checkNotFail(() => DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END));
      }
    })

    it('test_isDropInDesktop09', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null10', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string10', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string10', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string10', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string10', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string10', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string10', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string10', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_isDropInDesktop10', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null11', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string11', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string11', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string11', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string11', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string11', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string11', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string11', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_isDropInDesktop11', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null12', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string12', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string12', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string12', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string12', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string12', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string12', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string12', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_isDropInDesktop12', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null13', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string13', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string13', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string13', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string13', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string13', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string13', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string13', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_isDropInDesktop13', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null14', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string14', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string14', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string14', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string14', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string14', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string14', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string14', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_cancelDropAnimation14', Level.LEVEL0, (): void => {
      let context: ServiceExtensionContext = GlobalContext.getContext();
      if (context != null) {
        let dropAnimationEndReason: number = -1;
        let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
        context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(-1);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
        context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
      }
    })

    it('test_isDropInDesktop14', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null15', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string15', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string15', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string15', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string15', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string15', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string15', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string15', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_cancelDropAnimation15', Level.LEVEL0, (): void => {
      let context: ServiceExtensionContext = GlobalContext.getContext();
      if (context != null) {
        let dropAnimationEndReason: number = -1;
        let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
        context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(-1);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
        context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
      }
    })

    it('test_isDropInDesktop15', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null16', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string16', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string16', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string16', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string16', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string16', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string16', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string16', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_cancelDropAnimation16', Level.LEVEL0, (): void => {
      let context: ServiceExtensionContext = GlobalContext.getContext();
      if (context != null) {
        let dropAnimationEndReason: number = -1;
        let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
        context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(-1);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
        context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
      }
    })

    it('test_isDropInDesktop16', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('test_registerDragEvent_unregisterDragEvent17', Level.LEVEL0, (): void => {
      let dragEventManager: DragEventManager = DragEventManager.getInstance();
      let validCallback: DragEventCallback = {};
      let validItemKey: number = 1;
      checkNotFail(() => dragEventManager.registerDragEvent(null, 0));
      checkNotFail(() => dragEventManager.registerDragEvent(validCallback, 0));
      checkNotFail(() => dragEventManager.registerDragEvent(validCallback, validItemKey));
      checkNotFail(() => dragEventManager.unRegisterDragEvent(null, 0));
      checkNotFail(() => dragEventManager.unRegisterDragEvent(validCallback, 0));
      checkNotFail(() => dragEventManager.unRegisterDragEvent(validCallback, validItemKey));
    })

    it('test_sendDragEvent17', Level.LEVEL0, (): void => {
      let itemId: number = 0;
      let result: number = 0;
      let dragEventCallback: DragEventCallback = {
        onStartSqueezedEvent: () => {
          result = 1;
        },
        onCancelSqueezedEvent: () => {
          result = 1;
        },
        onItemDropStartEvent: () => {
          result = 1;
        }
      };
      DragEventManager.getInstance().registerDragEvent(dragEventCallback, itemId);

      result = 0;
      DragEventManager.getInstance().dragStartInDesktop(itemId);
      expect(result).assertEqual(0);

      result = 0;
      DragEventManager.getInstance().startSqueezedInDesktop(itemId, null);
      expect(result).assertEqual(0);

      DragEventManager.getInstance().unRegisterDragEvent(dragEventCallback, itemId);
    })

    it('test_sendDragEvent217', Level.LEVEL0, (): void => {
      let groupId: string = 'groupId'
      let pageIndex: number = 10
      let result: number = 0;

      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex),
        (keyName: string): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex),
        (keyName: string): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex),
        (): void => { result = 1});
      GlobalContext.getContext()?.eventHub.on(DragEventManager.getInstance().getStartDropAnimationEvent(groupId,
        pageIndex), (param: DropAnimationParam): void => { result = 1});

      DragEventManager.getInstance().dragStart(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      result = 0;
      DragEventManager.getInstance().dragDrop(groupId, pageIndex, null);
      expect(result).assertEqual(0);

      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex));
      GlobalContext.getContext()?.eventHub.off(DragEventManager.getInstance().getStartDropAnimationEvent(groupId,
        pageIndex));
    })

    it('test_isDropInDesktop18', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null18', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string18', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string18', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string18', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string18', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string18', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string18', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string18', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_cancelDropAnimation18', Level.LEVEL0, (): void => {
      let context: ServiceExtensionContext = GlobalContext.getContext();
      if (context != null) {
        let dropAnimationEndReason: number = -1;
        let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
        context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(-1);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
        context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
      }
    })

    it('test_isDropInDesktop18', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null18', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string18', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string18', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string18', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string18', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string18', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string18', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string18', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_cancelDropAnimation18', Level.LEVEL0, (): void => {
      let context: ServiceExtensionContext = GlobalContext.getContext();
      if (context != null) {
        let dropAnimationEndReason: number = -1;
        let callback: Function = (endReason: DropAnimationEndReason) => dropAnimationEndReason = endReason;
        context.eventHub.on(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', false);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(-1);
        AppStorage.setOrCreate<boolean>('isInDropAnimation', true);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.NORMAL_END);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.NORMAL_END);
        DragEventManager.getInstance().cancelDropAnimation(DropAnimationEndReason.CANCEL_BY_TOUCH);
        expect(dropAnimationEndReason).assertEqual(DropAnimationEndReason.CANCEL_BY_TOUCH);
        context.eventHub.off(DragConstants.CANCEL_DROP_ANIMATION_EVENT, callback);
      }
    })

    it('test_isDropInDesktop18', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('test_registerDragEvent_unregisterDragEvent17', Level.LEVEL0, (): void => {
      let dragEventManager: DragEventManager = DragEventManager.getInstance();
      let validCallback: DragEventCallback = {};
      let validItemKey: number = 1;
      checkNotFail(() => dragEventManager.registerDragEvent(null, 0));
      checkNotFail(() => dragEventManager.registerDragEvent(validCallback, 0));
      checkNotFail(() => dragEventManager.registerDragEvent(validCallback, validItemKey));
      checkNotFail(() => dragEventManager.unRegisterDragEvent(null, 0));
      checkNotFail(() => dragEventManager.unRegisterDragEvent(validCallback, 0));
      checkNotFail(() => dragEventManager.unRegisterDragEvent(validCallback, validItemKey));
    })

    it('test_isDropInDesktop18', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null19', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string19', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string19', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string19', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string19', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string19', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string19', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string19', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_getDragEnterEvent_should_return_string20', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string20', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string20', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })

    it('test_getDropAnimationEndEvent_should_return_string20', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropAnimationEndEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropAnimationEndEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_ANIMATION_END_EVENT}123`);
    })

    it('test_getDragStartInDesktopEvent_should_return_string20', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDragStartInDesktopEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDragStartInDesktopEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DRAG_START_EVENT}123`);
    })

    it('test_isDropInDesktop20', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop(0);
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('DragEventManagerTest_getInstance_should_not_null20', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_getDragStartEvent_should_return_string20', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragStartEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_START_EVENT}grid1`);
    })

    it('test_getStartDropAnimationEvent_should_return_string20', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getStartDropAnimationEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DROP_ANIMATION_START_EVENT}grid1`);
    })

    it('test_getDragEnterEvent_should_return_string20', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragEnterEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_ENTER_EVENT}grid1`);
    })

    it('test_getDragLeaveEvent_should_return_string20', Level.LEVEL0, (): void => {
      let groupId: string = 'grid';
      let pageIndex: number = 1;
      let event = DragEventManager.getInstance().getDragLeaveEvent(groupId, pageIndex);
      expect(event).assertEqual(`${DragConstants.DRAG_LEAVE_EVENT}grid1`);
    })

    it('test_getDropStartEvent_should_return_string20', Level.LEVEL0, (): void => {
      let itemKey: string = 'appItem';
      let event = DragEventManager.getInstance().getDropStartEvent(itemKey);
      expect(event).assertEqual(`${DragConstants.DROP_START_EVENT}appItem`);

      let itemId: number = 123;
      let event1 = DragEventManager.getInstance().getDropStartEvent(itemId);
      expect(event1).assertEqual(`${DragConstants.DROP_START_EVENT}123`);
    })
  })
}