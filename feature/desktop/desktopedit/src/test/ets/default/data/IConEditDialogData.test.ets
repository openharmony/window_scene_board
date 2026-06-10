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


export function DragEventManagerTest() {
    describe('DragEventManagerTest', (): void => {
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
        it('test_getCachedEffectKit_should_return_data04', Level.LEVEL0, async (done: Function) => {
            let appIconId: number = 0;
            let abilityName: string = 'bundleTest_getCachedEffectKit';
            let value: image.PixelMap = await resourceManagerCreateImage();
            let res: image.PixelMap = ResourceManager.getInstance().getCachedEffectKit(appIconId, abilityName);
            expect(res).assertNull();

            ResourceManager.getInstance().setEffectKitCache(appIconId, abilityName, value);
            res = ResourceManager.getInstance().getCachedEffectKit(appIconId, abilityName);
            expect(res).assertEqual(value);

            done();
        })

        it('test_deleteAppResourceCache_should_return_data04', Level.LEVEL0, (): void => {
            let cacheKey: string = 'cacheKey_deleteAppResourceCache';
            let cacheType: string = 'cacheType_deleteAppResourceCache'
            let value: string = 'value_deleteAppResourceCache'
            let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertNull();

            ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
            res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertEqual(value);

            ResourceManager.getInstance().deleteAppResourceCache(cacheKey, cacheType);
            res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertNull();
        })

        it('test_clearAppResourceCache_should_return_data04', Level.LEVEL0, (): void => {
            let cacheKey: string = 'cacheKey_clearAppResourceCache';
            let cacheType: string = 'cacheType_clearAppResourceCache'
            let value: string = 'value_clearAppResourceCache'
            let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertNull();

            ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
            res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertEqual(value);

            ResourceManager.getInstance().clearAppResourceCache();
            res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertNull();
        })

        it('test_clearAppAllResourceCache_should_return_data04', Level.LEVEL0, (): void => {
            let cacheKey: string = 'cacheKey_clearAppAllResourceCache';
            let cacheType: string = 'cacheType_clearAppAllResourceCache'
            let value: string = 'value_clearAppAllResourceCache'
            let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertNull();

            ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
            res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertEqual(value);

            ResourceManager.getInstance().clearAppAllResourceCache();
            res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertNull();
        })

        it('test_getBundleAppIcon_should_return_data04', Level.LEVEL0, (): void => {
            let bundleName: string = 'bundleTest_getBundleAppIcon';
            let value: string = 'valueTest';
            let res: string = ResourceManager.getInstance().getBundleAppIcon('');
            expect(res).assertEqual(StyleConstants.DEFAULT_ICON);
            res = ResourceManager.getInstance().getBundleAppIcon(null);
            expect(res).assertEqual(StyleConstants.DEFAULT_ICON);

            /* 查询不存在的bundle，还是默认值 */
            res = ResourceManager.getInstance().getBundleAppIcon(bundleName);
            expect(res).assertEqual(StyleConstants.DEFAULT_ICON);

            ResourceManager.getInstance().setBundleAppIconCache(bundleName, value);
            res = ResourceManager.getInstance().getBundleAppIcon(bundleName);
            expect(res).assertEqual(value);
        })

        it('test_getBundleAppName_should_return_data04', Level.LEVEL0, (): void => {
            let bundleName: string = 'bundleTest_getBundleAppName';
            let value: string = 'valueTest';
            let res: string = ResourceManager.getInstance().getBundleAppName(null);
            expect(res).assertNull();
            res = ResourceManager.getInstance().getBundleAppName('');
            expect(res).assertEqual('');

            /* 查询不存在的bundle，还是原始值 */
            res = ResourceManager.getInstance().getBundleAppName(bundleName);
            expect(res).assertEqual(bundleName);

            ResourceManager.getInstance().setBundleAppNameCache(bundleName, value);
            res = ResourceManager.getInstance().getBundleAppName(bundleName);
            expect(res).assertEqual(value);
        })

        it('test_getAbilityAppName_should_return_data04', Level.LEVEL0, (): void => {
            let bundleName: string = 'bundleTest_getAbilityAppName';
            let moduleName: string = 'moduleTest';
            let abilityName: string = 'abilityTest';
            let value: string = 'valueTest';
            let res: string = ResourceManager.getInstance().getAbilityAppName(null, null, null);
            expect(res).assertEqual(null);
            res = ResourceManager.getInstance().getAbilityAppName('', moduleName, abilityName);
            expect(res).assertEqual('');
            res = ResourceManager.getInstance().getAbilityAppName(bundleName, '', abilityName);
            expect(res).assertEqual(bundleName);
            res = ResourceManager.getInstance().getAbilityAppName(bundleName, moduleName, '');
            expect(res).assertEqual(bundleName);

            /* 查询不存在的bundle，还是原始值 */
            res = ResourceManager.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
            expect(res).assertEqual(bundleName);

            ResourceManager.getInstance().setAbilityAppNameCache(bundleName, moduleName, abilityName, value);
            res = ResourceManager.getInstance().getAbilityAppName(bundleName, moduleName, abilityName);
            expect(res).assertEqual(value);
        })

        it('test_getSCBInnerString_should_return_string05', Level.LEVEL0, (): void => {
            let name: string = '';
            ResourceManager.getInstance().getSCBInnerString(CommonConstants.NTF_MANAGEMENT_MODULE, (value: string): void => {
                name = value;
                expect(name).not().assertEqual('');
            });

            ResourceManager.getInstance().getSCBInnerString('', (value: string): void => {
                name = value;
                expect(name).assertEqual('');
            });
        })

        it('test_getStringByName_should_return_string05', Level.LEVEL0, (): void => {
            let name: string = ResourceManager.getInstance().getStringByName('duplicate_add');
            expect(name).not().assertEqual('');

            /* 异常数据时查询返回空字符串 */
            name = ResourceManager.getInstance().getStringByName(null);
            expect(name).assertEqual('');
        })

        it('test_getNumberById_invalid_input_number05', Level.LEVEL0, (): void => {
            let res: number = ResourceManager.getInstance().getNumberById(0);
            expect(res).assertEqual(0);
        })

        it('test_getFontWeightRegular_should_return_string05', Level.LEVEL0, async (done: Function) => {
            let name: string = await ResourceManager.getInstance().getFontWeightRegular();
            expect(name).not().assertNull();
            done();
        })

        it('test_getFontWeightMedium_should_return_string05', Level.LEVEL0, async (done: Function) => {
            let name: string = await ResourceManager.getInstance().getFontWeightMedium();
            expect(name).not().assertNull();
            done();
        })

        it('test_getSCBInnerIcon_should_return_data05', Level.LEVEL0, (): void => {
            ResourceManager.getInstance().getSCBInnerIcon('', (image: Resource): void => {
                expect(image).assertNull();
            }, null);

            ResourceManager.getInstance().getSCBInnerIcon(CommonConstants.NTF_MANAGEMENT_MODULE, (image: Resource): void => {
                expect(image).not().assertNull();
            }, null);
        })


        it('test_isSCBInnerModule_should_return_boolean05', Level.LEVEL0, (): void => {
            let res: boolean = ResourceManager.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
                CommonConstants.NTF_MANAGEMENT_MODULE);
            expect(res).assertTrue();

            res = ResourceManager.getInstance().isSCBInnerModule(CommonConstants.SYSTEMUI_PKG,
                '');
            expect(res).assertFalse();

            res = ResourceManager.getInstance().isSCBInnerModule('',
                CommonConstants.NTF_MANAGEMENT_MODULE);
            expect(res).assertFalse();
        })

        it('test_getAccountSAState_should_return_boolean05', Level.LEVEL0, async (done: Function) => {
            let res: boolean = await ResourceManager.getInstance().getAccountSAState();
            expect(res).assertTrue();
            done();
        })

        it('test_getCachedAppIcon_should_return_data05', Level.LEVEL0, (): void => {
            let iconId: number = 0;
            let bundleName: string = 'bundleTest_getCachedAppIcon';
            let moduleName: string = 'moduleTest';
            let value = 'valueTest'
            let res: string = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
            expect(res).assertNull();

            let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
            ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
            res = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
            expect(res).assertEqual(value);
        })

        it('test_getCachedAppName_should_return_data05', Level.LEVEL0, (): void => {
            let labelId: number = 0;
            let bundleName: string = 'bundleTest_getCachedAppName';
            let moduleName: string = 'moduleTest';
            let value = 'valueTest'
            let res: string = ResourceManager.getInstance().getCachedAppName(labelId, bundleName, moduleName);
            expect(res).assertNull();

            let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
            ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', value);
            res = ResourceManager.getInstance().getCachedAppName(labelId, bundleName, moduleName);
            expect(res).assertEqual(value);
        })

        it('test_getCachedIconPixelMap_should_return_data05', Level.LEVEL0, async (done: Function) => {
            let iconId: number = 0;
            let bundleName: string = 'bundleTest_getCachedIconPixelMap';
            let moduleName: string = 'moduleTest';
            let value: image.PixelMap = await resourceManagerCreateImage();
            let res: image.PixelMap = ResourceManager.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
            expect(res).assertNull();

            let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
            ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
            res = ResourceManager.getInstance().getCachedIconPixelMap(iconId, bundleName, moduleName);
            expect(res).assertEqual(value);
            done();
        })

        it('test_getCachedCardSnapshot_should_return_data05', Level.LEVEL0, async (done: Function) => {
            let bundleName: string = 'bundleTest_getCachedCardSnapshot';
            let value: image.PixelMap = await resourceManagerCreateImage();
            let res: image.PixelMap = ResourceManager.getInstance().getCachedCardSnapshot(bundleName);
            expect(res).assertNull();

            ResourceManager.getInstance().setAppResourceCache(bundleName, 'cardSnapshot', value);
            res = ResourceManager.getInstance().getCachedCardSnapshot(bundleName);
            expect(res).assertEqual(value);

            done();
        })

        it('test_getCachedAppCanNotice_should_return_data05', Level.LEVEL0, (): void => {
            let iconId: number = 0;
            let bundleName: string = 'bundleTest_getCachedAppCanNotice';
            let moduleName: string = 'moduleTest';
            let value: string = "valueTest";
            let res: string = ResourceManager.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
            expect(res).assertNull();

            let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
            ResourceManager.getInstance().setAppResourceCache(cacheKey, 'canNotice', value);
            res = ResourceManager.getInstance().getCachedAppCanNotice(iconId, bundleName, moduleName);
            expect(res).assertEqual(value);
        })

        it('test_getCachedEffectKit_should_return_data05', Level.LEVEL0, async (done: Function) => {
            let appIconId: number = 0;
            let abilityName: string = 'bundleTest_getCachedEffectKit';
            let value: image.PixelMap = await resourceManagerCreateImage();
            let res: image.PixelMap = ResourceManager.getInstance().getCachedEffectKit(appIconId, abilityName);
            expect(res).assertNull();

            ResourceManager.getInstance().setEffectKitCache(appIconId, abilityName, value);
            res = ResourceManager.getInstance().getCachedEffectKit(appIconId, abilityName);
            expect(res).assertEqual(value);

            done();
        })

        it('test_deleteAppResourceCache_should_return_data05', Level.LEVEL0, (): void => {
            let cacheKey: string = 'cacheKey_deleteAppResourceCache';
            let cacheType: string = 'cacheType_deleteAppResourceCache'
            let value: string = 'value_deleteAppResourceCache'
            let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertNull();

            ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
            res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertEqual(value);

            ResourceManager.getInstance().deleteAppResourceCache(cacheKey, cacheType);
            res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertNull();
        })

        it('test_clearAppResourceCache_should_return_data05', Level.LEVEL0, (): void => {
            let cacheKey: string = 'cacheKey_clearAppResourceCache';
            let cacheType: string = 'cacheType_clearAppResourceCache'
            let value: string = 'value_clearAppResourceCache'
            let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertNull();

            ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
            res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertEqual(value);

            ResourceManager.getInstance().clearAppResourceCache();
            res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertNull();
        })

        it('test_clearAppAllResourceCache_should_return_data05', Level.LEVEL0, (): void => {
            let cacheKey: string = 'cacheKey_clearAppAllResourceCache';
            let cacheType: string = 'cacheType_clearAppAllResourceCache'
            let value: string = 'value_clearAppAllResourceCache'
            let res: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertNull();

            ResourceManager.getInstance().setAppResourceCache(cacheKey, cacheType, value);
            res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertEqual(value);

            ResourceManager.getInstance().clearAppAllResourceCache();
            res = ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as string;
            expect(res).assertNull();
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

        it('IconChangeWantDataTest_getInstance_should_not_null07', Level.LEVEL0, (): void => {
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

        it('IconChangeWantDataTest_getInstance_should_not_null08', Level.LEVEL0, (): void => {
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

        it('IconChangeWantDataTest_getInstance_should_not_null09', Level.LEVEL0, (): void => {
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

        it('IconChangeWantDataTest_getInstance_should_not_null10', Level.LEVEL0, (): void => {
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

        it('IconChangeWantDataTest_getInstance_should_not_null11', Level.LEVEL0, (): void => {
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

        it('IconChangeWantDataTest_getInstance_should_not_null12', Level.LEVEL0, (): void => {
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

        it('IconChangeWantDataTest_getInstance_should_not_null13', Level.LEVEL0, (): void => {
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
    })
}
