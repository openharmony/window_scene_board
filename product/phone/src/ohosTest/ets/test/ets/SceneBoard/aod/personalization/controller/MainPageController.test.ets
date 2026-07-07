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

import { describe, it, expect, MockKit, when } from '@ohos/hypium';
import {
  AodSceneType,
  StyleGroupName } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/constant/Constant';
import { MainPageController } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/controller/MainPageController'
import { AodStyleListModel } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/model/AodStyleListModel'
import { AodStyleModel } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/model/AodStyleModel';
import SmallWindowUtil from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/utils/SmallWindowUtil';

export function AodMainPageControllerTest() {
  describe('AodMainPageControllerTest', () => {

    it('test_getStyleList', 0, () => {
      const mainPageController = new MainPageController();
      const list: AodStyleListModel = new AodStyleListModel();
      mainPageController.setStyleList(StyleGroupName.FULL_SCREEN,list)
      mainPageController.getStyleList(StyleGroupName.FULL_SCREEN);
      expect(mainPageController !== null).assertEqual(true);
    });

    it('test_getStyleList_if', 0, () => {
      const mainPageController = new MainPageController();
      mainPageController.getStyleList(StyleGroupName.WINDOW);
      expect(mainPageController !== null).assertEqual(true);
    });

    it('test_getStyleListScroller', 0, () => {
      const mainPageController = new MainPageController();
      const styleListScroller: Scroller = new Scroller();
      mainPageController.setStyleListScroller(StyleGroupName.FULL_SCREEN,styleListScroller)
      mainPageController.getStyleListScroller(StyleGroupName.FULL_SCREEN);
      expect(mainPageController !== null).assertEqual(true);
    });

    it('test_getStyleListScroller_if', 0, () => {
      const mainPageController = new MainPageController();
      mainPageController.getStyleListScroller(StyleGroupName.WINDOW);

      expect(mainPageController !== null).assertEqual(true);
    });

    it('MainPageController_jumpToPreviewPage1', 0, () => {
      const mainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mainPageController, mainPageController.getScene);
      when(mockFunc)().afterReturn(AodSceneType.SETTING);
      let mockFunc1: Function = mocker.mockFunc(SmallWindowUtil, SmallWindowUtil.checkWindowSmall);
      when(mockFunc1)().afterReturn(true);
      let clickedStyle: AodStyleModel = new AodStyleModel();
      mainPageController.jumpToPreviewPage(clickedStyle, 10);
      expect(mainPageController).not().assertUndefined();
      mocker.clear(mainPageController);
      mocker.clear(SmallWindowUtil);
      mocker.clearAll();
    });

    it('MainPageController_jumpToPreviewPage2', 0, () => {
      const mainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mainPageController, mainPageController.getScene);
      when(mockFunc)().afterReturn(AodSceneType.SETTING);
      let mockFunc1: Function = mocker.mockFunc(SmallWindowUtil, SmallWindowUtil.checkWindowSmall);
      when(mockFunc1)().afterReturn(false);
      let clickedStyle: AodStyleModel = new AodStyleModel();
      mainPageController.jumpToPreviewPage(clickedStyle, 10);
      expect(mainPageController).not().assertUndefined();
      mocker.clear(mainPageController);
      mocker.clear(SmallWindowUtil);
      mocker.clearAll();
    });

    it('MainPageController_jumpToPreviewPage3', 0, () => {
      const mainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mainPageController, mainPageController.getScene);
      when(mockFunc)().afterReturn(AodSceneType.SCREEN_LOCK);
      let mockFunc1: Function = mocker.mockFunc(SmallWindowUtil, SmallWindowUtil.checkWindowSmall);
      when(mockFunc1)().afterReturn(false);
      let clickedStyle: AodStyleModel = new AodStyleModel();
      mainPageController.jumpToPreviewPage(clickedStyle, 10);
      expect(mainPageController).not().assertUndefined();
      mocker.clear(mainPageController);
      mocker.clear(SmallWindowUtil);
      mocker.clearAll();
    });

    it('MainPageController_jumpToOnlinePage1', 0, () => {
      const mainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mainPageController, mainPageController.getScene);
      when(mockFunc)().afterReturn(AodSceneType.SCREEN_LOCK);
      let pathStack: NavPathStack = new NavPathStack();
      mainPageController.jumpToOnlinePage(pathStack);
      expect(mainPageController).not().assertUndefined();
      mocker.clear(mainPageController);
      mocker.clearAll();
    });

    it('MainPageController_jumpToOnlinePage2', 0, () => {
      const mainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mainPageController, mainPageController.getScene);
      when(mockFunc)().afterReturn(AodSceneType.SETTINGS_PREVIEW);
      let pathStack: NavPathStack = new NavPathStack();
      mainPageController.jumpToOnlinePage(pathStack);
      expect(mainPageController).not().assertUndefined();
      mocker.clear(mainPageController);
      mocker.clearAll();
    });

    it('MainPageController_jumpToDetailPage1', 0, () => {
      const mainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mainPageController, mainPageController.getScene);
      when(mockFunc)().afterReturn(AodSceneType.SCREEN_LOCK);
      let style: AodStyleModel = new AodStyleModel();
      mainPageController.jumpToDetailPage(style);
      expect(mainPageController).not().assertUndefined();
      mocker.clear(mainPageController);
      mocker.clearAll();
    });

    it('MainPageController_jumpToDetailPage2', 0, () => {
      const mainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mainPageController, mainPageController.getScene);
      when(mockFunc)().afterReturn(AodSceneType.SETTINGS_PREVIEW);
      let style: AodStyleModel = new AodStyleModel();
      mainPageController.jumpToDetailPage(style);
      expect(mainPageController).not().assertUndefined();
      mocker.clear(mainPageController);
      mocker.clearAll();
    });

  })
}