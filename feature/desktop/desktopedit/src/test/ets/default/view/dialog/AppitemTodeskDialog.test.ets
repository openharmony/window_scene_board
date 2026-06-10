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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'

/**
 * AppCategorizeCommon测试
 *
 * @since 2025-02-25
 */
export default function AppitemTodeskDialogTest() {
    describe('AppitemTodeskDialogTest', (): void => {
        beforeAll((): void => {
        })

        beforeEach((): void => {
        })

        afterEach((): void => {
        })

        afterAll((): void => {
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


        it('test_GridOccupyStatus_isInStatusForGrid11', Level.LEVEL0, (): void => {
            expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
            instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForRect11', Level.LEVEL0, (): void => {
            instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        })

        it('test_GridOccupyStatus_copyFrom11', Level.LEVEL0, (): void => {
            instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        })

        it('test_GridOccupyStatus_getStatus11', Level.LEVEL0, (): void => {
            let cellX:number = -1;
            let cellY:number = 1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = -1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = 1;
            expect(instance.getStatus(cellX,cellY));
        })

        it('test_GridOccupyStatus_isFree11', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus11', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan11', Level.LEVEL0, (): void => {
            let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_getGridOccupyStatus11', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.toString();
        })


        it('test_GridOccupyStatus_markStatus11', Level.LEVEL0, (): void => {
            instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
        })

        it('test_GridOccupyStatus_create11', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            expect(instance.getSizeX()).assertEqual(4);
            expect(instance.getSizeY()).assertEqual(4);
            instance.toString();
        })

        it('test_GridOccupyStatus_isOccupied11', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatusForGrid11', Level.LEVEL0, (): void => {
            expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertFalse();
            instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForRect11', Level.LEVEL0, (): void => {
            instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_copyFrom11', Level.LEVEL0, (): void => {
            instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        })

        it('test_GridOccupyStatus_getStatus11', Level.LEVEL0, (): void => {
            let cellX:number = -1;
            let cellY:number = 1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = -1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = 1;
            expect(instance.getStatus(cellX,cellY));
        })

        it('test_GridOccupyStatus_isFree11', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus11', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan11', Level.LEVEL0, (): void => {
            let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_getGridOccupyStatus11', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.toString();
        })

        it('test_GridOccupyStatus_isInStatus11', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan11', Level.LEVEL0, (): void => {
            let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_getGridOccupyStatus11', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.toString();
        })


        it('test_GridOccupyStatus_markStatus11', Level.LEVEL0, (): void => {
            instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
        })

        it('test_GridOccupyStatus_create11', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            expect(instance.getSizeX()).assertEqual(4);
            expect(instance.getSizeY()).assertEqual(4);
            instance.toString();
        })

        it('test_GridOccupyStatus_isOccupied11', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatusForGrid11', Level.LEVEL0, (): void => {
            expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
            instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForRect11', Level.LEVEL0, (): void => {
            instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        })

        it('test_GridOccupyStatus_copyFrom11', Level.LEVEL0, (): void => {
            instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        })

        it('test_GridOccupyStatus_getStatus11', Level.LEVEL0, (): void => {
            let cellX:number = -1;
            let cellY:number = 1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = -1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = 1;
            expect(instance.getStatus(cellX,cellY));
        })

        it('test_GridOccupyStatus_create10', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            expect(instance.getSizeX()).assertEqual(4);
            expect(instance.getSizeY()).assertEqual(4);
            instance.toString();
        })

        it('test_GridOccupyStatus_isOccupied12', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatusForGrid12', Level.LEVEL0, (): void => {
            expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 5, 5, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
            instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForRect12', Level.LEVEL0, (): void => {
            instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        })

        it('test_GridOccupyStatus_copyFrom12', Level.LEVEL0, (): void => {
            instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        })

        it('test_GridOccupyStatus_getStatus12', Level.LEVEL0, (): void => {
            let cellX:number = -1;
            let cellY:number = 1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = -1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = 1;
            expect(instance.getStatus(cellX,cellY));
        })

        it('test_GridOccupyStatus_isFree12', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus12', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan12', Level.LEVEL0, (): void => {
            let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_getGridOccupyStatus12', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.toString();
        })

        it('test_GridOccupyStatus_markStatus12', Level.LEVEL0, (): void => {
            instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
        })

        it('test_GridOccupyStatus_create12', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            expect(instance.getSizeX()).assertEqual(4);
            expect(instance.getSizeY()).assertEqual(4);
            instance.toString();
        })

        it('test_GridOccupyStatus_isInStatusForGrid09', Level.LEVEL0, (): void => {
            expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
            instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForRect09', Level.LEVEL0, (): void => {
            instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        })

        it('test_GridOccupyStatus_copyFrom09', Level.LEVEL0, (): void => {
            instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        })

        it('test_GridOccupyStatus_getStatus09', Level.LEVEL0, (): void => {
            let cellX:number = -1;
            let cellY:number = 1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = -1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = 1;
            expect(instance.getStatus(cellX,cellY));
        })

        it('test_GridOccupyStatus_create10', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            expect(instance.getSizeX()).assertEqual(4);
            expect(instance.getSizeY()).assertEqual(4);
            instance.toString();
        })

        it('test_GridOccupyStatus_isOccupied10', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatusForGrid10', Level.LEVEL0, (): void => {
            expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
            instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForRect10', Level.LEVEL0, (): void => {
            instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        })

        it('test_GridOccupyStatus_copyFrom10', Level.LEVEL0, (): void => {
            instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        })

        it('test_GridOccupyStatus_getStatus10', Level.LEVEL0, (): void => {
            let cellX:number = -1;
            let cellY:number = 1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = -1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = 1;
            expect(instance.getStatus(cellX,cellY));
        })

        it('test_GridOccupyStatus_isFree10', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus10', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan10', Level.LEVEL0, (): void => {
            let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_getGridOccupyStatus10', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.toString();
        })


        it('test_GridOccupyStatus_markStatus10', Level.LEVEL0, (): void => {
            instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
        })

        it('test_GridOccupyStatus_create10', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            expect(instance.getSizeX()).assertEqual(4);
            expect(instance.getSizeY()).assertEqual(4);
            instance.toString();
        })

        it('test_GridOccupyStatus_isOccupied10', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isOccupied11', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatusForGrid11', Level.LEVEL0, (): void => {
            expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
            instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForRect11', Level.LEVEL0, (): void => {
            instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        })

        it('test_GridOccupyStatus_copyFrom11', Level.LEVEL0, (): void => {
            instance.copyFrom(new GridOccupyStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        })

        it('test_GridOccupyStatus_getStatus11', Level.LEVEL0, (): void => {
            let cellX:number = -1;
            let cellY:number = 1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = -1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = 1;
            expect(instance.getStatus(cellX,cellY));
        })

        it('test_GridOccupyStatus_isFree11', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 4, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus11', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan11', Level.LEVEL0, (): void => {
            let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_getStatus04', Level.LEVEL0, (): void => {
            let cellX:number = -2;
            let cellY:number = 2;
            expect(instance.getStatus(cellX,cellY));
            cellX = 4;
            cellY = -4;
            expect(instance.getStatus(cellX,cellY));
            cellX = 6;
            cellY = 6;
            expect(instance.getStatus(cellX,cellY));
        })

        it('test_GridOccupyStatus_isFree04', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus04', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-1,1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 1,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(1,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan04', Level.LEVEL0, (): void => {
            let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_getGridOccupyStatus07', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.toString();
        })


        it('test_GridOccupyStatus_markStatus07', Level.LEVEL0, (): void => {
            instance.markStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(1 << 2, 1 << 3, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
        })

        it('test_GridOccupyStatus_create07', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            expect(instance.getSizeX()).assertEqual(4);
            expect(instance.getSizeY()).assertEqual(4);
            instance.toString();
        })

        it('test_GridOccupyStatus_isOccupied07', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatusForGrid07', Level.LEVEL0, (): void => {
            expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
            instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForRect07', Level.LEVEL0, (): void => {
            instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        })

        it('test_GridOccupyStatus_copyFrom07', Level.LEVEL0, (): void => {
            instance.copyFrom(new GridOccupyStatus(1 << 3, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 3, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        })

        it('test_GridOccupyStatus_getStatus07', Level.LEVEL0, (): void => {
            let cellX:number = -1;
            let cellY:number = 1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = -1;
            expect(instance.getStatus(cellX,cellY));
            cellX = 1;
            cellY = 1;
            expect(instance.getStatus(cellX,cellY));
        })

        it('test_GridOccupyStatus_isFree07', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(1 << 3, 1 << 2)).assertFalse();
            expect(instance.isOccupied(1, 1)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus07', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan07', Level.LEVEL0, (): void => {
            let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_getGridOccupyStatus06', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.toString();
        })

        it('test_GridOccupyStatus_markStatus06', Level.LEVEL0, (): void => {
            instance.markStatus(2 << 3, 2 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(2 << 2, 2 << 3, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
        })

        it('test_GridOccupyStatus_create06', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            expect(instance.getSizeX()).assertEqual(4);
            expect(instance.getSizeY()).assertEqual(4);
            instance.toString();
        })

        it('test_GridOccupyStatus_isOccupied06', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
            expect(instance.isOccupied(2, 2)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatusForGrid06', Level.LEVEL0, (): void => {
            expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
            instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForRect06', Level.LEVEL0, (): void => {
            instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        })

        it('test_GridOccupyStatus_copyFrom06', Level.LEVEL0, (): void => {
            instance.copyFrom(new GridOccupyStatus(2 << 3, 2 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(2 << 2, 2 << 3, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        })

        it('test_GridOccupyStatus_getStatus06', Level.LEVEL0, (): void => {
            let cellX:number = -2;
            let cellY:number = 2;
            expect(instance.getStatus(cellX,cellY));
            cellX = 2;
            cellY = -2;
            expect(instance.getStatus(cellX,cellY));
            cellX = 2;
            cellY = 2;
            expect(instance.getStatus(cellX,cellY));
        })

        it('test_GridOccupyStatus_isFree06', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
            expect(instance.isOccupied(2, 2)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus06', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan06', Level.LEVEL0, (): void => {
            let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_getGridOccupyStatus07', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.toString();
        })


        it('test_GridOccupyStatus_markStatus07', Level.LEVEL0, (): void => {
            instance.markStatus(2 << 3, 2 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(2 << 2, 2 << 3, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
        })

        it('test_GridOccupyStatus_create07', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            expect(instance.getSizeX()).assertEqual(4);
            expect(instance.getSizeY()).assertEqual(4);
            instance.toString();
        })

        it('test_GridOccupyStatus_isOccupied07', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
            expect(instance.isOccupied(2, 2)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatusForGrid07', Level.LEVEL0, (): void => {
            expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
            instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForRect07', Level.LEVEL0, (): void => {
            instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        })

        it('test_GridOccupyStatus_copyFrom07', Level.LEVEL0, (): void => {
            instance.copyFrom(new GridOccupyStatus(2 << 3, 2 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(2 << 2, 2 << 3, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        })

        it('test_GridOccupyStatus_getStatus07', Level.LEVEL0, (): void => {
            let cellX:number = -2;
            let cellY:number = 2;
            expect(instance.getStatus(cellX,cellY));
            cellX = 2;
            cellY = -2;
            expect(instance.getStatus(cellX,cellY));
            cellX = 2;
            cellY = 2;
            expect(instance.getStatus(cellX,cellY));
        })

        it('test_GridOccupyStatus_isFree07', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
            expect(instance.isOccupied(2, 2)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus07', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan07', Level.LEVEL0, (): void => {
            let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_isOccupied08', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
            expect(instance.isOccupied(2, 2)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatusForGrid08', Level.LEVEL0, (): void => {
            expect(instance.isInStatusForGrid(0, 0, 0, 0, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 7, 7, GridOccupyStatusEnum.FREE)).assertFalse();
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertFalse();
            instance.markStatus(0, 0, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForRect08', Level.LEVEL0, (): void => {
            instance.markGridForRect(new RectItem(0, 0, 4, 4), GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
        })

        it('test_GridOccupyStatus_copyFrom08', Level.LEVEL0, (): void => {
            instance.copyFrom(new GridOccupyStatus(2 << 3, 2 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(2 << 2, 2 << 3, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.copyFrom(new GridOccupyStatus(2 << 2, 2 << 2, GridOccupyStatusEnum.OCCUPIED));
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.OCCUPIED);
        })

        it('test_GridOccupyStatus_getStatus08', Level.LEVEL0, (): void => {
            let cellX:number = -2;
            let cellY:number = 2;
            expect(instance.getStatus(cellX,cellY));
            cellX = 2;
            cellY = -2;
            expect(instance.getStatus(cellX,cellY));
            cellX = 2;
            cellY = 2;
            expect(instance.getStatus(cellX,cellY));
        })

        it('test_GridOccupyStatus_isFree08', Level.LEVEL0, (): void => {
            expect(instance.isOccupied(2 << 3, 2 << 2)).assertFalse();
            expect(instance.isOccupied(2, 2)).assertTrue();
            expect(instance.isFree(0, 0)).assertTrue();
        })

        it('test_GridOccupyStatus_isInStatus08', Level.LEVEL0, (): void => {
            expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(-2,2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(0,instance.mStatus.length + 2,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
            expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.FREE)).assertTrue();
            expect(instance.isInStatus(2,instance.mStatus.length,GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_markGridForCellAndSpan08', Level.LEVEL0, (): void => {
            let cellToSetup : CellAndSpan = new CellAndSpan(0,0,4,4);
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.FREE);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.FREE)).assertTrue();
            instance.markGridForCellAndSpan(cellToSetup, GridOccupyStatusEnum.OCCUPIED);
            expect(instance.isInStatusForGrid(0, 0, 4, 4, GridOccupyStatusEnum.OCCUPIED)).assertTrue();
        })

        it('test_GridOccupyStatus_getGridOccupyStatus08', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            instance.toString();
        })


        it('test_GridOccupyStatus_markStatus08', Level.LEVEL0, (): void => {
            instance.markStatus(1 << 4, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(1 << 2, 1 << 4, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.OCCUPIED);
            instance.markStatus(0, 0, GridOccupyStatusEnum.FREE);
            expect(instance.getStatus(0, 0)).assertEqual(GridOccupyStatusEnum.FREE);
        })

        it('test_GridOccupyStatus_create08', Level.LEVEL0, (): void => {
            expect(instance.getGridOccupyStatus()).assertNull();
            instance = new GridOccupyStatus(1 << 2, 1 << 2, GridOccupyStatusEnum.FREE);
            expect(instance.getGridOccupyStatus()[0][0]).assertEqual(GridOccupyStatusEnum.FREE);
            expect(instance.getSizeX()).assertEqual(4);
            expect(instance.getSizeY()).assertEqual(4);
            instance.toString();
        })
    })
}