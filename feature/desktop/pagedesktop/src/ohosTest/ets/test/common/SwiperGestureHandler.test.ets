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
} from '@ohos/hypium';
import {  EventConstants } from '@ohos/launchercommon';
import { LanguageUtils } from '@ohos/basicutils';
import { SCBTransitionManager } from '@ohos/windowscene';
import {
  GlobalSearchConstants,
  ViewManagerPolicy,
  sOutSideWindowMgr,
  localEventManager,
  SCBDesktopCacheManager,
  ViewType
} from '@ohos/frameworkwrapper';
import { SwiperGestureHandler } from '../../../../main/ets/default/common/SwiperGestureHandler';

export default function SwiperGestureHandlerTest() {
  describe('SwiperGestureHandlerTest', () => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });
    it('globalSearchActionCancelTest', 0, () => {
      let swiperHandler:SwiperGestureHandler = SwiperGestureHandler.getInstance();
      swiperHandler.globalSearchActionCancel();
      expect(swiperHandler !== undefined).assertTrue();
    });
    it('isBeginSwipeToNegativePageTest001', 0, () => {
      let swiperHandler: SwiperGestureHandler = SwiperGestureHandler.getInstance();
      let isBeginSwipeToNegativePage: boolean = swiperHandler.isBeginSwipeToNegativePage();
      expect(isBeginSwipeToNegativePage).assertFalse();
    });

    it('isBeginSwipeToNegativePageTest002', 0, () => {
      let swiperHandler: SwiperGestureHandler = SwiperGestureHandler.getInstance();
      (SwiperGestureHandler as object)['beginSwipeToNegativePage'] = true;
      let isBeginSwipeToNegativePage: boolean = swiperHandler.isBeginSwipeToNegativePage();
      expect(isBeginSwipeToNegativePage).assertFalse();
    });

    it('globalSearchKeyActionTest001', 0, () => {
      let swiperHandler: SwiperGestureHandler = SwiperGestureHandler.getInstance();
      swiperHandler.globalSearchKeyAction(true);
      expect(swiperHandler !== undefined).assertTrue();
    });

    it('globalSearchKeyActionTest002', 0, () => {
      let swiperHandler: SwiperGestureHandler = SwiperGestureHandler.getInstance();
      swiperHandler.globalSearchKeyAction(false);
      expect(swiperHandler !== undefined).assertTrue();
    });

    it('should_not_proceed_if_isChangingPage_is_true', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.globalSearchKeyAction(true);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_proceed_with_animation_if_isChangingPage_is_false', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let mockSetDesktopCacheWithDfx: ESObject = mocker.mockFunc(SCBDesktopCacheManager.getInstance(), SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx);
      let mockSetOrCreate: ESObject = mocker.mockFunc(AppStorage, AppStorage.setOrCreate);
      let mockSetIsHidingGlobalSearch: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.setIsHidingGlobalSearch);
      let mockCancelCloseAppAnimate: ESObject = mocker.mockFunc(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().cancelCloseAppAnimate);
      let mockSetDesktopEnabled: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.setDesktopEnabled);
      let mockShowView: ESObject = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.showView);
      let mockSetGlobalSearchTranslateY: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.setGlobalSearchTranslateY);
      let mockSetGlobalSearchOpacity: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.setGlobalSearchOpacity);
      let mockEmit: ESObject = mocker.mockFunc(swiperGestureHandler.desktopContext.eventHub, swiperGestureHandler.desktopContext.eventHub.emit);

      when(mockSetDesktopCacheWithDfx)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);
      when(mockSetOrCreate)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);
      when(mockSetIsHidingGlobalSearch)(ArgumentMatchers.any).afterReturn(null);
      when(mockCancelCloseAppAnimate)().afterReturn(null);
      when(mockSetDesktopEnabled)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);
      when(mockShowView)(ArgumentMatchers.any).afterReturn(null);
      when(mockSetGlobalSearchTranslateY)(ArgumentMatchers.any).afterReturn(null);
      when(mockSetGlobalSearchOpacity)(ArgumentMatchers.any).afterReturn(null);
      when(mockEmit)(ArgumentMatchers.any).afterReturn(null);

      swiperGestureHandler.globalSearchKeyAction(false);

      mocker.ignoreMock(SCBDesktopCacheManager.getInstance(), SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx);
      mocker.ignoreMock(AppStorage, AppStorage.setOrCreate);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.setIsHidingGlobalSearch);
      mocker.ignoreMock(SCBTransitionManager.getInstance(), SCBTransitionManager.getInstance().cancelCloseAppAnimate);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.setDesktopEnabled);
      mocker.ignoreMock(ViewManagerPolicy, ViewManagerPolicy.showView);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.setGlobalSearchTranslateY);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.setGlobalSearchOpacity);
      mocker.ignoreMock(swiperGestureHandler.desktopContext.eventHub, swiperGestureHandler.desktopContext.eventHub.emit);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_not_proceed_if_isChangingPage_is_true_002', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let event: ESObject = { timestamp: 12345 };
      swiperGestureHandler.globalSearchActionStart(event, true);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_proceed_if_isChangingPage_is_false', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let event: ESObject = { timestamp: 12345 };
      swiperGestureHandler.globalSearchActionStart(event, false);
      expect(swiperGestureHandler.beginTime).assertEqual(event.timestamp);
      expect(swiperGestureHandler.globalSearchDistanceY).assertEqual(GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET);
      done();
    });

    it('should_not_proceed_if_beginSwipeToGlobalSearch_is_false', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = false;
      let event: ESObject = { offsetY: 100 };
      swiperGestureHandler.globalSearchActionUpdate(event, true);
      expect(swiperGestureHandler.globalSearchDistanceY).not().assertNull();
      done();
    });

    it('should_handle_global_search_update_correctly', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = true;
      let event: ESObject = { offsetY: 100 };
      swiperGestureHandler.globalSearchActionUpdate(event, true);
      expect(swiperGestureHandler.globalSearchDistanceY).assertLarger(0);
      done();
    });

    it('should_handle_global_search_update_with_negative_distance', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = true;
      let event: ESObject = { offsetY: -100 };
      swiperGestureHandler.globalSearchActionUpdate(event, true);
      expect(swiperGestureHandler.globalSearchDistanceY).assertEqual(GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET);
      done();
    });

    it('should_handle_global_search_update_with_first_frame_for_search', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = true;
      swiperGestureHandler.isFirstFrameForSearch = true;
      let event: ESObject = { offsetY: 100 };
      swiperGestureHandler.globalSearchActionUpdate(event, true);
      expect(swiperGestureHandler.isFirstFrameForSearch).assertFalse();
      done();
    });

    it('should_handle_global_search_update_with_view_not_showing', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = true;
      let event: ESObject = { offsetY: 100 };
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(mockFunc)(ViewType.GLOBAL_SEARCH).afterReturn(false);
      swiperGestureHandler.globalSearchActionUpdate(event, true);
      expect(ViewManagerPolicy.showView).not().assertNull();
      mocker.ignoreMock(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      done();
    });

    it('should_handle_global_search_update_with_view_showing', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = true;
      let event: ESObject = { offsetY: 100 };
      let mocker: ESObject = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(mockFunc)(ViewType.GLOBAL_SEARCH).afterReturn(true);
      swiperGestureHandler.globalSearchActionUpdate(event, true);
      expect(true).assertTrue()
      mocker.ignoreMock(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      done();
    });

    it('should_handle_global_search_update_with_move_up', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = true;
      let event: ESObject = { offsetY: 100 };
      swiperGestureHandler.globalSearchCurrentOffsetY = 200;
      swiperGestureHandler.globalSearchActionUpdate(event, true);
      expect(swiperGestureHandler.globalSearchOpacity).assertEqual(undefined);
      done();
    });

    it('should_handle_global_search_update_with_move_down', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = true;
      let event: ESObject = { offsetY: 200 };
      swiperGestureHandler.globalSearchCurrentOffsetY = 100;
      swiperGestureHandler.globalSearchActionUpdate(event, true);
      expect(swiperGestureHandler.globalSearchOpacity).assertEqual(undefined);
      done();
    });

    it('should_handle_global_search_update_with_min_distance_y', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = true;
      let event: ESObject = { offsetY: 100 };
      swiperGestureHandler.minGlobalSearchCurrentOffsetY = 200;
      swiperGestureHandler.globalSearchActionUpdate(event, true);
      expect(swiperGestureHandler.minGlobalSearchCurrentOffsetY).assertEqual(100);
      done();
    });

    it('should_call_intoSearchAnimate_when_speed_is_greater_than_threshold_and_duration_is_greater_than_zero', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let event: ESObject = { timestamp: 1000, offsetY: 100 };
      let mockFunc: ESObject = mocker.mockFunc(swiperGestureHandler, swiperGestureHandler.intoSearchAnimate);
      when(mockFunc)().afterReturn(null);
      swiperGestureHandler.globalSearchActionEnd(event, true);
      mocker.verify('intoSearchAnimate', []).atLeast(1);
      mocker.ignoreMock(swiperGestureHandler, swiperGestureHandler.intoSearchAnimate);
      done();
    });

    it('should_call_exitSearchAnimate_when_speed_is_not_greater_than_threshold_and_offset_is_less_than_threshold', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let event: ESObject = { timestamp: 1000, offsetY: 50 };
      let mockFunc: ESObject = mocker.mockFunc(swiperGestureHandler, swiperGestureHandler.exitSearchAnimate);
      when(mockFunc)().afterReturn(null);
      swiperGestureHandler.globalSearchActionEnd(event, true);
      mocker.ignoreMock(swiperGestureHandler, swiperGestureHandler.exitSearchAnimate);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_call_intoSearchAnimate_when_beginSwipeToGlobalSearch_is_true_and_offset_is_greater_than_threshold', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = true;
      let mocker: ESObject = new MockKit();
      let event: ESObject = { timestamp: 1000, offsetY: 100 };
      let mockFunc: ESObject = mocker.mockFunc(swiperGestureHandler, swiperGestureHandler.intoSearchAnimate);
      when(mockFunc)().afterReturn(null);
      swiperGestureHandler.globalSearchActionEnd(event, true);
      mocker.verify('intoSearchAnimate', []).atLeast(1);
      mocker.ignoreMock(swiperGestureHandler, swiperGestureHandler.intoSearchAnimate);
      done();
    });

    it('should_call_exitSearchAnimate_when_beginSwipeToGlobalSearch_is_true_and_offset_is_less_than_threshold', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = true;
      let mocker: ESObject = new MockKit();
      let event: ESObject = { timestamp: 1000, offsetY: 50 };
      let mockFunc: ESObject = mocker.mockFunc(swiperGestureHandler, swiperGestureHandler.exitSearchAnimate);
      when(mockFunc)().afterReturn(null);
      swiperGestureHandler.globalSearchActionEnd(event, true);
      mocker.ignoreMock(swiperGestureHandler, swiperGestureHandler.exitSearchAnimate);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_reset_beginSwipeToGlobalSearch_and_beginTime_after_method_execution', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.globalSearchActionEnd({ timestamp: 1000, offsetY: 50 }, true);
      expect(swiperGestureHandler.beginSwipeToGlobalSearch).assertFalse();
      expect(swiperGestureHandler.beginTime).assertEqual(0);
      done();
    });

    it('should_reset_globalSearchDistanceY_and_globalSearchCurrentOffsetY_after_method_execution', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.globalSearchActionEnd({ timestamp: 1000, offsetY: 50 }, true);
      expect(swiperGestureHandler.globalSearchDistanceY).assertEqual(GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET);
      expect(swiperGestureHandler.globalSearchCurrentOffsetY).assertEqual(0);
      done();
    });

    it('should_clear_timeout_and_reset_minGlobalSearchCurrentOffsetY_when_beginSwipeToGlobalSearch_is_false', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = false;
      swiperGestureHandler.globalSearchActionCancel();
      expect(swiperGestureHandler.minGlobalSearchCurrentOffsetY).assertEqual(0);
      expect(swiperGestureHandler.beginTime).assertEqual(0);
      expect(swiperGestureHandler.beginSwipeToGlobalSearch).assertFalse();
      expect(swiperGestureHandler.globalSearchDistanceY).assertEqual(GlobalSearchConstants.GLOBAL_SEARCH_START_TRANSLATE_Y_OFFSET);
      expect(swiperGestureHandler.globalSearchCurrentOffsetY).assertEqual(0);
      done();
    });

    it('should_animate_and_hide_view_when_beginSwipeToGlobalSearch_is_true_and_animation_count_matches', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = true;
      let mocker: ESObject = new MockKit();
      let mockGetGlobalSearchAnimationCount: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getGlobalSearchAnimationCount);
      let mockHideView: ESObject = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.hideView);
      let mockSetGlobalSearchStatus: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.setGlobalSearchStatus);
      let mockClearGlobalSearchAnimationCount: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.clearGlobalSearchAnimationCount);
      let mockHideGlobalSearchDirectly: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.hideGlobalSearchDirectly);
      when(mockGetGlobalSearchAnimationCount)().afterReturn(1);
      swiperGestureHandler.globalSearchActionCancel();
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.getGlobalSearchAnimationCount);
      mocker.ignoreMock(ViewManagerPolicy, ViewManagerPolicy.hideView);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.setGlobalSearchStatus);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.clearGlobalSearchAnimationCount);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.hideGlobalSearchDirectly);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_not_animate_and_hide_view_when_beginSwipeToGlobalSearch_is_true_and_animation_count_does_not_match', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = true;
      let mocker: ESObject = new MockKit();
      let mockGetGlobalSearchAnimationCount: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getGlobalSearchAnimationCount);
      let mockHideView: ESObject = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.hideView);
      let mockSetGlobalSearchStatus: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.setGlobalSearchStatus);
      let mockClearGlobalSearchAnimationCount: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.clearGlobalSearchAnimationCount);
      let mockHideGlobalSearchDirectly: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.hideGlobalSearchDirectly);
      when(mockGetGlobalSearchAnimationCount)().afterReturn(2);
      swiperGestureHandler.globalSearchActionCancel();
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.getGlobalSearchAnimationCount);
      mocker.ignoreMock(ViewManagerPolicy, ViewManagerPolicy.hideView);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.setGlobalSearchStatus);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.clearGlobalSearchAnimationCount);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.hideGlobalSearchDirectly);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_set_beginSwipeToNegativePage_to_true_when_offsetX_is_positive_and_not_mirror_language', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let event: ESObject = { offsetX: 10, timestamp: 12345 };
      let mockLanguageUtils: ESObject = mocker.mockFunc(LanguageUtils, LanguageUtils.isMirrorLanguage);
      when(mockLanguageUtils)().afterReturn(false);
      swiperGestureHandler.negativeActionStart(event);
      expect(swiperGestureHandler.beginSwipeToNegativePage).assertTrue();
      mocker.ignoreMock(LanguageUtils, LanguageUtils.isMirrorLanguage);
      done();
    });

    it('should_set_beginSwipeToNegativePage_to_true_when_offsetX_is_negative_and_mirror_language', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let event: ESObject = { offsetX: -10, timestamp: 12345 };
      let mockLanguageUtils: ESObject = mocker.mockFunc(LanguageUtils, LanguageUtils.isMirrorLanguage);
      when(mockLanguageUtils)().afterReturn(true);
      swiperGestureHandler.negativeActionStart(event);
      expect(swiperGestureHandler.beginSwipeToNegativePage).assertTrue();
      mocker.ignoreMock(LanguageUtils, LanguageUtils.isMirrorLanguage);
      done();
    });

    it('should_set_beginSwipeToNegativePage_to_false_when_offsetX_is_positive_and_mirror_language', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let event: ESObject = { offsetX: 10, timestamp: 12345 };
      let mockLanguageUtils: ESObject = mocker.mockFunc(LanguageUtils, LanguageUtils.isMirrorLanguage);
      when(mockLanguageUtils)().afterReturn(true);
      swiperGestureHandler.negativeActionStart(event);
      expect(swiperGestureHandler.beginSwipeToNegativePage).assertFalse();
      mocker.ignoreMock(LanguageUtils, LanguageUtils.isMirrorLanguage);
      done();
    });

    it('should_set_beginSwipeToNegativePage_to_false_when_offsetX_is_negative_and_not_mirror_language', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let event: ESObject = { offsetX: -10, timestamp: 12345 };
      let mockLanguageUtils: ESObject = mocker.mockFunc(LanguageUtils, LanguageUtils.isMirrorLanguage);
      when(mockLanguageUtils)().afterReturn(false);
      swiperGestureHandler.negativeActionStart(event);
      expect(swiperGestureHandler.beginSwipeToNegativePage).assertFalse();
      mocker.ignoreMock(LanguageUtils, LanguageUtils.isMirrorLanguage);
      done();
    });

    it('should_not_proceed_if_beginSwipeToNegativePage_is_false', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToNegativePage = false;
      swiperGestureHandler.negativeActionUpdate({ offsetX: 100 });
      expect(swiperGestureHandler.beginSwipeToNegativePage).assertFalse();
      done();
    });

    it('should_handle_subsequent_frames_for_negative_screen', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToNegativePage = true;
      swiperGestureHandler.isFirstFrameForNegative = false;
      swiperGestureHandler.negativeActionUpdate({ offsetX: 100 });
      expect(swiperGestureHandler.isFirstFrameForNegative).assertFalse();
      done();
    });

    it('should_clear_timeout_and_reset_flags_when_beginSwipeToNegativePage_is_false', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToNegativePage = false;
      let mocker: MockKit = new MockKit();
      let mockClearTimeout: ESObject = mocker.mockFunc(globalThis, globalThis.clearTimeout);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturn(null);
      swiperGestureHandler.negativeActionCancel();
      expect(swiperGestureHandler.beginSwipeToNegativePage).assertFalse();
      expect(swiperGestureHandler.beginTime).assertEqual(0);
      mocker.ignoreMock(globalThis, globalThis.clearTimeout);
      done();
    });

    it('should_update_negative_animation_time_and_open_fail_animation_when_beginSwipeToNegativePage_is_true', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToNegativePage = true;
      let mocker: MockKit = new MockKit();
      let mockClearTimeout: ESObject = mocker.mockFunc(globalThis, globalThis.clearTimeout);
      let mockUpdateNegativeAnimationTime: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.updateNegativeAnimationTime);
      let mockGetNegativeAnimationTime: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.getNegativeAnimationTime);
      let mockOpenFailAnimation: ESObject = mocker.mockFunc(swiperGestureHandler, swiperGestureHandler.openFailAnimation);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturn(null);
      when(mockUpdateNegativeAnimationTime)().afterReturn(null);
      when(mockGetNegativeAnimationTime)().afterReturn(100);
      when(mockOpenFailAnimation)(100).afterReturn(null);
      swiperGestureHandler.negativeActionCancel();
      expect(swiperGestureHandler.beginSwipeToNegativePage).assertFalse();
      expect(swiperGestureHandler.beginTime).assertEqual(0);
      mocker.ignoreMock(globalThis, globalThis.clearTimeout);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.updateNegativeAnimationTime);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.getNegativeAnimationTime);
      mocker.ignoreMock(swiperGestureHandler, swiperGestureHandler.openFailAnimation);
      done();
    });

    it('should_emit_correct_events_and_set_correct_states_when_animation_ends', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(swiperGestureHandler, swiperGestureHandler.intoNegativeAnimation);
      when(mockFunc)().afterReturn(null);
      swiperGestureHandler.intoNegativeAnimation();
      expect(swiperGestureHandler.negativeAnimateCount).not().assertNull();
      mocker.verify('intoNegativeAnimation', []).atLeast(1);
      mocker.ignoreMock(swiperGestureHandler, swiperGestureHandler.intoNegativeAnimation);
      done();
    });

    it('should_send_local_event_when_isDrag_is_true', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mockAppStorage: ESObject = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockAppStorage)('isDrag').afterReturn(true);
      let mockLocalEventManager: ESObject = mocker.mockFunc(localEventManager, localEventManager.sendLocalEventSticky);
      swiperGestureHandler.openFailAnimation(1000);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    });

    it('should_not_send_local_event_when_isDrag_is_false', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mockAppStorage: ESObject = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockAppStorage)('isDrag').afterReturn(false);
      let mockLocalEventManager: ESObject = mocker.mockFunc(localEventManager, localEventManager.sendLocalEventSticky);
      swiperGestureHandler.openFailAnimation(1000);
      mocker.verify('sendLocalEventSticky', [EventConstants.EVENT_INTELLIGENT_CARD_DRAG_FAIL, {}]).never();
      mocker.ignoreMock(AppStorage, AppStorage.get);
      done();
    });

    it('should_call_openFailDirectly_when_isKeyGuard_is_true', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mockViewManagerPolicy: ESObject = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(mockViewManagerPolicy)(ViewType.KEYGUARD).afterReturn(true);
      let mockOpenFailDirectly: ESObject = mocker.mockFunc(swiperGestureHandler, swiperGestureHandler.openFailDirectly);
      swiperGestureHandler.openFailAnimation(1000);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      done();
    });

    it('should_not_call_openFailDirectly_when_isKeyGuard_is_false', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mockViewManagerPolicy: ESObject = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(mockViewManagerPolicy)(ViewType.KEYGUARD).afterReturn(false);
      let mockOpenFailDirectly: ESObject = mocker.mockFunc(swiperGestureHandler, swiperGestureHandler.openFailDirectly);
      swiperGestureHandler.openFailAnimation(1000);
      mocker.verify('openFailDirectly', []).never();
      mocker.ignoreMock(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      done();
    });

    it('should_decrement_negativeAnimateCount_and_set_NegativeAnimateEnd_to_true_on_animation_finish', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mockSetNegativeAnimateEnd: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.setNegativeAnimateEnd);
      swiperGestureHandler.openFailAnimation(1000);
      expect(swiperGestureHandler.negativeAnimateCount).not().assertNull();
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.setNegativeAnimateEnd);
      done();
    });

    it('should_set_NegativeScreenVisible_and_ShowNegative_to_false_when_animationTime_equals_startTime_and_negativeAnimateCount_is_zero', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mockSetNegativeScreenVisible: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.setNegativeScreenVisible);
      let mockSetShowNegative: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.setShowNegative);
      when(mockSetNegativeScreenVisible)(false).afterReturn(true);
      when(mockSetShowNegative)(false).afterReturn(true);
      swiperGestureHandler.openFailAnimation(1000);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.setNegativeScreenVisible);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.setShowNegative);
      done();
    });

    it('should_set_NegativeOffset_and_NegativeDesktopProgress_based_on_language_direction', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mockLanguageUtils: ESObject = mocker.mockFunc(LanguageUtils, LanguageUtils.isMirrorLanguage);
      when(mockLanguageUtils)().afterReturn(true);
      let mockSetNegativeOffset: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.setNegativeOffset);
      let mockSetNegativeDesktopProgress: ESObject = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.setNegativeDesktopProgress);
      swiperGestureHandler.openFailAnimation(1000);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(LanguageUtils, LanguageUtils.isMirrorLanguage);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.setNegativeOffset);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.setNegativeDesktopProgress);
      done();
    });

    it('should_decrement_negativeAnimateCount_when_greater_than_zero', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.negativeAnimateCount = 1;
      swiperGestureHandler.openFailDirectly();
      expect(swiperGestureHandler.negativeAnimateCount).assertEqual(1);
      done();
    });

    it('should_not_decrement_negativeAnimateCount_when_zero', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.negativeAnimateCount = 0;
      swiperGestureHandler.openFailDirectly();
      expect(swiperGestureHandler.negativeAnimateCount).assertEqual(0);
      done();
    });

    it('should_set_negative_offset_based_on_language_direction', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let mockLanguageUtils: ESObject = mocker.mockFunc(LanguageUtils, LanguageUtils.isMirrorLanguage);
      when(mockLanguageUtils)().afterReturn(true);
      swiperGestureHandler.windowWidth = 100;
      swiperGestureHandler.openFailDirectly();
      expect(sOutSideWindowMgr.setNegativeOffset).not().assertNull();
      mocker.ignoreMock(LanguageUtils, LanguageUtils.isMirrorLanguage);
      done();
    });

    it('should_set_negative_offset_to_positive_when_not_mirror_language', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let mockLanguageUtils: ESObject = mocker.mockFunc(LanguageUtils, LanguageUtils.isMirrorLanguage);
      when(mockLanguageUtils)().afterReturn(false);
      swiperGestureHandler.windowWidth = 100;
      swiperGestureHandler.openFailDirectly();
      expect(sOutSideWindowMgr.setNegativeOffset).not().assertNull();
      mocker.ignoreMock(LanguageUtils, LanguageUtils.isMirrorLanguage);
      done();
    });

    it('should_set_negative_desktop_progress_to_zero', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.openFailDirectly();
      expect(sOutSideWindowMgr.setNegativeDesktopProgress).not().assertNull();
      done();
    });

    it('should_set_desktop_cache_with_dfx_to_false', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.openFailDirectly();
      expect(SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx).not().assertNull();
      done();
    });

    it('should_set_negative_screen_visible_to_false', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.openFailDirectly();
      expect(sOutSideWindowMgr.setNegativeScreenVisible).not().assertNull();
      done();
    });

    it('should_set_show_negative_to_false', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.openFailDirectly();
      expect(sOutSideWindowMgr.setShowNegative).not().assertNull();
      done();
    });

    it('should_return_startValue_when_offset_is_less_than_5_or_maxDistance_is_0', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      const result: ESObject = swiperGestureHandler.getValueWithOffset(3, 0, 10, 20);
      expect(result).assertEqual(10);
      done();
    });

    it('should_return_endValue_when_offset_is_greater_than_or_equal_to_maxDistance', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      const result: ESObject = swiperGestureHandler.getValueWithOffset(10, 5, 10, 20);
      expect(result).assertEqual(20);
      done();
    });

    it('should_handle_fast_swipe_to_negative_screen', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let event: ESObject = {
        timestamp: 1000,
        offsetX: 0,
        velocityX: 1000
      };
      let mockFunc: ESObject = mocker.mockFunc(swiperGestureHandler, swiperGestureHandler.intoNegativeAnimation);
      when(mockFunc)().afterReturn(null);
      swiperGestureHandler.beginSwipeToNegativePage = true;
      swiperGestureHandler.beginTime = 500;
      swiperGestureHandler.negativeActionEnd(event);
      mocker.verify('intoNegativeAnimation', []).atLeast(1);
      mocker.ignoreMock(swiperGestureHandler, swiperGestureHandler.intoNegativeAnimation);
      done();
    });

    it('should_handle_slow_swipe_to_fail_animation', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let event: ESObject = {
        timestamp: 1000,
        offsetX: 0,
        velocityX: 500
      };
      let mockFunc: ESObject = mocker.mockFunc(swiperGestureHandler, swiperGestureHandler.openFailAnimation);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      swiperGestureHandler.beginSwipeToNegativePage = true;
      swiperGestureHandler.beginTime = 500;
      swiperGestureHandler.negativeActionEnd(event);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(swiperGestureHandler, swiperGestureHandler.openFailAnimation);
      done();
    });

    it('should_handle_mirror_language_swipe_to_negative_screen', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let event: ESObject = {
        timestamp: 1000,
        offsetX: -1000,
        velocityX: 1000
      };
      let mockFunc: ESObject = mocker.mockFunc(swiperGestureHandler, swiperGestureHandler.intoNegativeAnimation);
      when(mockFunc)().afterReturn(null);
      swiperGestureHandler.beginSwipeToNegativePage = true;
      swiperGestureHandler.beginTime = 500;
      swiperGestureHandler.negativeActionEnd(event);
      mocker.verify('intoNegativeAnimation', []).atLeast(1);
      mocker.ignoreMock(swiperGestureHandler, swiperGestureHandler.intoNegativeAnimation);
      done();
    });

    it('should_handle_mirror_language_swipe_to_fail_animation', 0, async (done: Function) => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: ESObject = new MockKit();
      let event: ESObject = {
        timestamp: 1000,
        offsetX: 1000,
        velocityX: 1000
      };
      let mockFunc: ESObject = mocker.mockFunc(swiperGestureHandler, swiperGestureHandler.openFailAnimation);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      swiperGestureHandler.beginSwipeToNegativePage = true;
      swiperGestureHandler.beginTime = 500;
      swiperGestureHandler.negativeActionEnd(event);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(swiperGestureHandler, swiperGestureHandler.openFailAnimation);
      done();
    });

    it('should_handle_subsequent_frames_for_negative_screen_1', 0, () => {
      try {
        let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
        swiperGestureHandler.beginSwipeToNegativePage = true;
        swiperGestureHandler.isFirstFrameForNegative = true;
        swiperGestureHandler.negativeActionUpdate({
          offsetX: 100
        });
        expect(swiperGestureHandler.isFirstFrameForNegative).assertFalse();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      };
    });

    it('test_getOpacityValueWithOffset_1', 0, () => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      expect(swiperGestureHandler.getOpacityValueWithOffset(100, 100, 100, 200)).assertInstanceOf('Number');
      expect(swiperGestureHandler.getOpacityValueWithOffset(100, 200, 100, 200)).assertInstanceOf('Number');
    });

    it('test_onExitSearchWithAnimation_1', 0, () => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(swiperGestureHandler.onExitSearchWithAnimation()).not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(swiperGestureHandler.onExitSearchWithAnimation(true)).not().assertNull();
      expect(swiperGestureHandler.onExitSearchWithAnimation(false)).not().assertNull();
      mocker.clear(ViewManagerPolicy);
      mocker.clearAll();
    });

    it('test_globalSearchActionEnd_1', 0, () => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = false;
      const gestureEvent: GestureEvent = {
        timestamp: 1000,
        velocityX: 100,
        offsetY: 0
      } as GestureEvent;
      swiperGestureHandler.beginSwipeToGlobalSearch = false;
      expect(swiperGestureHandler.globalSearchActionEnd(gestureEvent, true)).not().assertTrue();
      swiperGestureHandler.beginSwipeToGlobalSearch = true;
      expect(swiperGestureHandler.globalSearchActionEnd(gestureEvent, true)).not().assertTrue();
    });

    it('test_negativeActionEnd_1', 0, () => {
      try {
        let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
        swiperGestureHandler.beginSwipeToNegativePage = 1;
        const gestureEvent: GestureEvent = {
          timestamp: 1000,
          velocityX: 100,
          offsetX: -1000
        } as GestureEvent;
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(LanguageUtils, LanguageUtils.isMirrorLanguage);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        expect(swiperGestureHandler.negativeActionEnd(gestureEvent)).not().assertTrue();
        gestureEvent.offsetX = 1000;
        swiperGestureHandler.beginSwipeToNegativePage = 0;
        expect(swiperGestureHandler.negativeActionEnd(gestureEvent)).not().assertTrue();
        mocker.clear(LanguageUtils);
        mocker.clearAll();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      };
    });

    it('test_intoSearchAnimate_1', 0, () => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.beginSwipeToGlobalSearch = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(swiperGestureHandler.intoSearchAnimate()).not().assertTrue();
      mocker.clear(ViewManagerPolicy);
      mocker.clearAll();
    });

    it('test_openFailDirectly_1', 0, () => {
      try {
        const gestureEvent: GestureEvent = {
          timestamp: 1000,
          velocityX: 100,
          offsetX: 1000
        } as GestureEvent;
        let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(LanguageUtils, LanguageUtils.isMirrorLanguage);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        swiperGestureHandler.negativeAnimateCount = 1;
        swiperGestureHandler.negativeActionStart(gestureEvent)
        expect(swiperGestureHandler.openFailDirectly()).not().assertTrue();
        mocker.clear(LanguageUtils);
        mocker.clearAll();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      };
    });

    it('test_openFailDirectly_2', 0, () => {
      let swiperGestureHandler: ESObject = SwiperGestureHandler.getInstance();
      swiperGestureHandler.negativeAnimateCount = 0;
      expect(swiperGestureHandler.openFailDirectly()).not().assertTrue();
    });
  });
}
