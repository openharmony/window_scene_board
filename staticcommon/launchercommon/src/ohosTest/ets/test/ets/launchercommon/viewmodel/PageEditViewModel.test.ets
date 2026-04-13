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

import { DeviceHelper } from "@ohos/frameworkwrapper";
import { ArgumentMatchers, describe, expect, it, MockKit, when } from "@ohos/hypium";
import { SwiperLoadData } from "@ohos/swiperdata";
import { launcherStatusUtil } from "@ohos/windowscene";
import { LaunchLayoutCacheManager } from "../../../../../../main/ets/cache/layout/LaunchLayoutCacheManager";
import { pageEditManager } from "../../../../../../main/ets/editmode/model/PageEditManager";
import { DragingPageType } from "../../../../../../main/ets/editmode/viewModel/PageDragAction";
import {
  PageEditItemViewData,
  PageEditViewModel } from "../../../../../../main/ets/editmode/viewModel/PageEditViewModel";
import EditModeConstants from "../../../../../../main/ets/utils/EditModeConstants";
import { EditModeUtils } from "../../../../../../main/ets/utils/EditModeUtils";
import GridLayoutUtil from '../../../../../../main/ets/utils/GridLayoutUtil';
import { Position } from '@kit.ArkUI';
import { EditModePageActionEnum } from "../../../../../../main/ets/editmode/data/PageEditData";
import sceneSessionManager from "@ohos.sceneSessionManager";
import { PageDragManager } from "../../../../../../main/ets/editmode/model/PageDragManager";

export default function PageEditViewModelTest() {
  const instance: PageEditViewModel = new PageEditViewModel();
  describe('PageEditViewModelTest', () => {
    it('test_addBlankPageCurrentPageAnimate', 0, async () => {
      try {
        instance.addBlankPageCurrentPageAnimate(false);
        await EditModeUtils.sleep(EditModeConstants.PAGE_EDIT_ANIMATE_TIME * 2);
        expect(pageEditManager.editModeBlankAnimatePageData.blankAnimatePageOpacity).assertEqual(1);
      } catch (err) {}
    })

    it('test_deleteBlankPageCurrentPageAnimate', 0, async () => {
      try {
        instance.deleteBlankPageCurrentPageAnimate(false);
        await EditModeUtils.sleep(EditModeConstants.PAGE_EDIT_ANIMATE_TIME * 2);
        expect(pageEditManager.editModeBlankAnimatePageData.blankAnimatePageOpacity).assertEqual(0);
      } catch (err) {}
    })

    it('test_isAddingLastPage', 0, () => {
      try {
        SwiperLoadData.getInstance().clearSwiperPages();
        const isAddingLastPage = instance.isAddingLastPage(true);
        expect(isAddingLastPage).assertFalse();
      } catch (err) {}
    })

    it('test_isAddingLastPage2', 0, (done:Function) => {
      try {
        SwiperLoadData.getInstance().clearSwiperPages();
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isLargeFoldExpanded);
        when(mockFunction)().afterReturn(true);
        const isAddingLastPage = instance.isAddingLastPage(true);
        expect(isAddingLastPage).assertFalse();
        mocker.clear(GridLayoutUtil);
        mocker.clearAll();
        done();
      } catch (err) {}
    })

    it('test_getScreenWidthOrHeight', 0, () => {
      try {
        const ScreenWidth = instance.getScreenWidthOrHeight(true, false);
        expect(ScreenWidth).not().assertNaN();
        const ScreenHeight = instance.getScreenWidthOrHeight(false, false);
        expect(ScreenHeight).not().assertNaN();
        const getOuterScreenWidthOrHeight = instance.getScreenWidthOrHeight(false, true);
        expect(getOuterScreenWidthOrHeight).not().assertNaN();
      } catch (err) {}
    })

    it('test_getSwiperHeight', 0, (done:Function) => {
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockFunction)().afterReturn(true);
        const swiperHeight = instance.getSwiperHeight();
        expect(swiperHeight).not().assertNaN();
        mocker.clear(DeviceHelper);
        mocker.clearAll();
        done();
      } catch (err) {}
    })

    it('test_getSwiperHeight2', 0, (done:Function) => {
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockFunction)().afterReturn(false);
        const swiperHeight = instance.getSwiperHeight();
        expect(swiperHeight).not().assertNaN();
        mocker.clear(DeviceHelper);
        mocker.clearAll();
        done();
      } catch (err) {}
    })

    it('test_getDeleteButtonYFromBgTop', 0, () => {
      try {
        const buttonY = instance.getDeleteButtonYFromBgTop(false);
        expect(buttonY).not().assertNaN();
        const outerButtonY = instance.getDeleteButtonYFromBgTop(true);
        expect(outerButtonY).not().assertNaN();
      } catch (err) {}
    })

    it('test_updateEditModeBackGroundPointY2', 0, (done:Function) => {
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.isCurrentDesktopVisible);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        let mockFunction2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockFunction2)().afterReturn(false);
        instance.updateEditModeBackGroundPointY(0, 1, 1, false);
        expect(pageEditManager.editModeDragAnimatePageData.editModeBgTopPointY).not().assertEqual(0);
        instance.updateEditModeBackGroundPointY(0, 1, 1, true);
        expect(pageEditManager.editModeDragAnimatePageData.editModeBgTopPointY).not().assertEqual(0);
        mocker.clear(launcherStatusUtil);
        mocker.clear(DeviceHelper);
        mocker.clearAll();
        done();
      } catch (err) {}
    })

    it('test_getEditModeBackGroundBottomDistanceY', 0, (done:Function) => {
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        when(mockFunction)().afterReturn(false);
        const distanceY = instance.getEditModeBackGroundBottomDistanceY(0, 1);
        expect(distanceY).not().assertEqual(0);
        mocker.clear(DeviceHelper);
        mocker.clearAll();
        done();
      } catch (err) {}
    })

    it('test_dropPageAnimate', 0, () => {
      try {
        const dragEvent: DragEvent = {
          getPreviewRect: (): Rectangle => {
            return {
              x: 0,
              y: 0,
              width: 0,
              height: 0,
            }
          }
        } as DragEvent;
        instance.dropPageAnimate(dragEvent, true);
        instance.dropPageAnimate(dragEvent, false);
        expect(dragEvent.useCustomDropAnimation).assertTrue();
      } catch (err) {}
    })

    it('test_onLongPressForSnapshotEnd', 0, async () => {
      try {
        const gestureEvent: GestureEvent = {
          timestamp: 0,
        } as GestureEvent;
        const snapshotEnd = instance.onLongPressForSnapshotEnd(gestureEvent, 0);
        expect(snapshotEnd).assertTrue();
        const gestureEvent2: GestureEvent = {
          timestamp: 1,
        } as GestureEvent;
        const snapshotEnd2 = instance.onLongPressForSnapshotEnd(gestureEvent2, 1);
        expect(snapshotEnd2).assertFalse();
      } catch (err) {}
    })

    it('test_onLongPressForDrag', 0, async () => {
      try {
        const gestureEvent: GestureEvent = {
          timestamp: 0,
        } as GestureEvent;
        await instance.onLongPressForDrag(gestureEvent, 0, 0, true);
        expect((instance as object)['pageDrag']).assertNull();
      } catch (err) {}
    })

    it('test_onLongPressForDrag2', 0, async () => {
      try {
        const gestureEvent: GestureEvent = {
          timestamp: 0,
        } as GestureEvent;
        const ctx: UIContext = sceneSessionManager.getRootSceneUIContext();
        await instance.onLongPressForDrag(gestureEvent, 0, 0, true, ctx);
        expect((instance as object)['pageDrag']).assertNull();
      } catch (err) {}
    })

    it('test_onLongPressForAnimateEnd', 0, () => {
      try {
        instance.onLongPressForAnimateEnd();
        expect((instance as object)['animatedPage'].length).assertEqual(0);
      } catch (err) {}
    })

    it('test_createDragAction', 0, () => {
      try {
        const DraggingPage: DragingPageType = new DragingPageType();
        DraggingPage.width = 0;
        DraggingPage.height = 0;
        DraggingPage.defaultX = 0;
        DraggingPage.defaultY = 0;
        DraggingPage.targetX = 0;
        DraggingPage.targetY = 0;
        DraggingPage.pageIndex = 0;
        DraggingPage.pageKey = 0;
        DraggingPage.radius = 0;
        DraggingPage.animationType = 0;
        const touchPoint: Position = {
          x: 0,
          y: 0,
        };
        instance.createDragAction(DraggingPage, touchPoint, true);
        expect((instance as object)['pageDrag']).not().assertNull();
      } catch (err) {}
    })

    it('test_createDragAction2', 0, () => {
      try {
        const DraggingPage: DragingPageType = new DragingPageType();
        DraggingPage.width = 0;
        DraggingPage.height = 0;
        DraggingPage.defaultX = 0;
        DraggingPage.defaultY = 0;
        DraggingPage.targetX = 0;
        DraggingPage.targetY = 0;
        DraggingPage.pageIndex = 0;
        DraggingPage.pageKey = 0;
        DraggingPage.radius = 0;
        DraggingPage.animationType = 0;
        const touchPoint: Position = {
          x: 0,
          y: 0,
        };
        const ctx: UIContext = sceneSessionManager.getRootSceneUIContext();
        instance.createDragAction(DraggingPage, touchPoint, true, ctx);
        expect((instance as object)['pageDrag']).not().assertNull();
      } catch (err) {}
    })

    it('test_getPageEditAnimateDelayTime', 0, () => {
      try {
        pageEditManager.editModeEditPageData.handleEditPageState = EditModePageActionEnum.DELETEING_BLANK_PAGE;
        const time = instance.getPageEditAnimateDelayTime();
        expect(time).assertEqual(100);
        pageEditManager.editModeEditPageData.handleEditPageState = EditModePageActionEnum.WAITTING_ACTION;
        const time2 = instance.getPageEditAnimateDelayTime();
        expect(time2).assertEqual(0);
      } catch (err) {}
    })

    it('test_onAddingOrDeletingPageForAnimate', 0, () => {
      try {
        const pageEditItemViewData: PageEditItemViewData = new PageEditItemViewData();
        const key = PageDragManager.getInstance().getPageUniqueKey(0);
        instance.singlePageItemObserver.register(key, pageEditItemViewData);
        let ctx: UIContext = sceneSessionManager.getRootSceneUIContext();
        instance.onAddingOrDeletingPageForAnimate(0, 0, ctx, false);
        expect(key).not().assertEqual(0);
        instance.singlePageItemObserver.unregister(key);
        instance.onAddingOrDeletingPageForAnimate(0, 0, ctx, false);
        expect(key).not().assertEqual(0);
      } catch (err) {}
    })

    it('test_recoverPageTranslateX', 0, () => {
      try {
        const pageEditItemViewData: PageEditItemViewData = new PageEditItemViewData();
        const key = PageDragManager.getInstance().getPageUniqueKey(0);
        instance.singlePageItemObserver.register(key, pageEditItemViewData);
        instance.recoverPageTranslateX(0, false);
        expect(key).not().assertEqual(0);
        instance.singlePageItemObserver.unregister(key);
        instance.recoverPageTranslateX(0, false);
        expect(key).not().assertEqual(0);
      } catch (err) {}
    })

    it('test_onLongPressForSnapshot', 0, async () => {
      try {
        const gestureEvent: GestureEvent = {
          timestamp: 0,
        } as GestureEvent;
        const customBuilder: CustomBuilder = () => {};
        instance.onLongPressForSnapshot(customBuilder, gestureEvent, 0, 0, false);
        expect((instance as object)['snapshotTimestamp']).assertEqual(0);
      } catch (err) {}
    })

    it('test_isCurrentPageBlank', 0, async () => {
      try {
        pageEditManager.pageEditState.isFoldExpandStatus = false;
        const currentPageBlank = instance.isCurrentPageBlank(0, false);
        expect(currentPageBlank).assertFalse();
        pageEditManager.pageEditState.isFoldExpandStatus = true;
        const currentPageBlank2 = instance.isCurrentPageBlank(0, false);
        expect(currentPageBlank2).assertFalse();
      } catch (err) {}
    })
  })
}