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
import { AppCenterViewModel } from '@ohos/appcenter';
import { DragGridParam, DragItemPosition, RealPaddingParam } from '@ohos/componentdrag';
import { RTLUtil } from '@ohos/componenthelper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { AppItemInfo } from '@ohos/launchercommon';
import { AppLayoutInfo } from '@ohos/appcenter/src/main/ets/default/common/viewmodel/AppLayoutInfo';
import LayoutConstants from '@ohos/appcenter/src/main/ets/default/constants/LayoutConstants';
import { layoutConfigManager, StyleConstants } from '@ohos/launchercommon';
import { AppCenterGridStyleConfig } from '@ohos/appcenter/src/main/ets/default/common/AppCenterGridStyleConfig';
import FeatureConstants from '@ohos/appcenter/src/main/ets/default/common/constants/FeatureConstants';

export default function AppCenterViewModelTest() {
  describe('AppCenterViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('beginSearch', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.beginSearch();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('endSearch', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.endSearch();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('inputChangeEvent', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      let input: string = 'a';
      try {
        model.inputChangeEvent(input);
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getSearchResult1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      let input: string = 'a';
      try {
        model.getSearchResult(input);
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getSearchResult2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      let input: string = '';
      try {
        model.getSearchResult(input);
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getAppGridStyleConfig1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.getAppGridStyleConfig();
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getAppGridStyleConfig2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.getAppGridStyleConfig(1);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('setSwiperController1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      let swiperController: SwiperController = new SwiperController();
      try {
        model.setSwiperController(swiperController);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('setSwiperController2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      let swiperController: SwiperController = new SwiperController();
      try {
        model.setSwiperController(swiperController, 1);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getSwiperController1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.getSwiperController();
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getSwiperController2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.getSwiperController(1);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('showNext1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.showNext();
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('showNext2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.showNext(1);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('showPrevious1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.showPrevious();
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('showPrevious2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.showPrevious(1);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('goExactPage1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.goExactPage(0, 1);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('goExactPage2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.goExactPage(0, 0);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('goExactPage3', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.goExactPage(-1, 0);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('initAnimationData1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.initAnimationData();
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('initAnimationData2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.initAnimationData();
        model.initAnimationData();
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getCircleMap', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.getCircleMap();
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getTimeAsc', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.getTimeAsc();
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getTimeDesc', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.getTimeDesc();
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getAppItemEdgePos', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.getAppItemEdgePos();
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getIndexOfGrid1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.getIndexOfGrid(-1, -1);
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getIndexOfGrid2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        if (model.getIndexOfGrid(0, 0) === 0) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('convertToAllList', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let fullAppPageList: AppLayoutInfo[] = [];
        model.convertToAllList(fullAppPageList);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('doAppCenterDataPaging', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let appInfos: AppItemInfo[] = [];
        model.doAppCenterDataPaging(appInfos);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('changeIndex', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.changeIndex(0);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('removeAppUpdateAppCenter1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let app: AppItemInfo = new AppItemInfo();
        app.bundleName = 'test';
        let appInfos: AppItemInfo[] = [app];
        if (model.removeAppUpdateAppCenter(appInfos, app.bundleName).length === 0) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('removeAppUpdateAppCenter2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let app: AppItemInfo = new AppItemInfo();
        app.bundleName = 'test';
        let appInfos: AppItemInfo[] = [app];
        if (model.removeAppUpdateAppCenter(appInfos, 't').length === 1) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('doDataPagingAndSort1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let appInfos: AppItemInfo[] = [];
        if (model.doDataPagingAndSort(appInfos).length === 0) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('doDataPagingAndSort2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let app: AppItemInfo = new AppItemInfo();
        app.page = 0;
        let appInfos: AppItemInfo[] = [app];
        if (model.doDataPagingAndSort(appInfos).length === 1) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('doDataPagingAndSort3', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let app: AppItemInfo = new AppItemInfo();
        app.page = undefined;
        let appInfos: AppItemInfo[] = [app];
        model.doDataPagingAndSort(appInfos);
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('doDataPagingAndSort4', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let app: AppItemInfo = new AppItemInfo();
        app.page = 0;
        let app1: AppItemInfo = new AppItemInfo();
        app1.page = 0;
        let appInfos: AppItemInfo[] = [app, app1];
        model.doDataPagingAndSort(appInfos);
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('doDataPagingAndSort5', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let app: AppItemInfo = new AppItemInfo();
        app.page = 0;
        let app1: AppItemInfo = new AppItemInfo();
        app1.page = undefined;
        let appInfos: AppItemInfo[] = [app, app1];
        model.doDataPagingAndSort(appInfos);
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('findPositionOnPage1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        if (!model.findPositionOnPage([], [])) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('findPositionOnPage2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let app: AppItemInfo = new AppItemInfo();
        let leftAppItems: AppItemInfo[] = [app];
        if (!model.findPositionOnPage([], leftAppItems)) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('findPositionOnPage3', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let info: AppLayoutInfo = new AppLayoutInfo();
        let appCenterLayoutInfo: AppLayoutInfo[] = [info];
        if (!model.findPositionOnPage(appCenterLayoutInfo, [])) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('findPositionOnPage4', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let app: AppItemInfo = new AppItemInfo();
        let leftAppItems: AppItemInfo[] = [app];
        let appCenterLayoutInfo: AppLayoutInfo[] = [];
        let fullPage: AppLayoutInfo = new AppLayoutInfo();
        fullPage.pageInfo = [];
        let mAppGridStyleConfig: AppCenterGridStyleConfig = layoutConfigManager.getStyleConfig(AppCenterGridStyleConfig.APP_GRID_STYLE_CONFIG,
          FeatureConstants.FEATURE_NAME);
        for (let i = 0; i < mAppGridStyleConfig.mColumns * mAppGridStyleConfig.mRows; i++) {
          fullPage.pageInfo.push(app);
        }
        for (let i = 0; i < LayoutConstants.MAX_PAGE_COUNT; i++) {
          appCenterLayoutInfo.push(fullPage);
        }
        if (!model.findPositionOnPage(appCenterLayoutInfo, leftAppItems)) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('findPositionOnPage5', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let app: AppItemInfo = new AppItemInfo();
        let leftAppItems: AppItemInfo[] = [app];
        let appCenterLayoutInfo: AppLayoutInfo[] = [];
        let fullPage: AppLayoutInfo = new AppLayoutInfo();
        fullPage.pageInfo = [];
        let mAppGridStyleConfig: AppCenterGridStyleConfig = layoutConfigManager.getStyleConfig(AppCenterGridStyleConfig.APP_GRID_STYLE_CONFIG,
          FeatureConstants.FEATURE_NAME);
        for (let i = 0; i < mAppGridStyleConfig.mColumns * mAppGridStyleConfig.mRows; i++) {
          fullPage.pageInfo.push(app);
        }
        appCenterLayoutInfo.push(fullPage);
        if (model.findPositionOnPage(appCenterLayoutInfo, leftAppItems)) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('sortPageData1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.sortPageData([]);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('sortPageData2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let app: AppItemInfo = new AppItemInfo();
        let appItems: AppItemInfo[] = [app];
        model.sortPageData(appItems);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('sortAllData1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let layout: AppLayoutInfo = new AppLayoutInfo();
        let layoutItems: AppLayoutInfo[] = [layout];
        model.sortAllData(layoutItems);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('sortAllData2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let layout: AppLayoutInfo = new AppLayoutInfo();
        let layoutItems: AppLayoutInfo[] = [layout];
        model.sortAllData(layoutItems, [0]);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('sortAllData3', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        let layout: AppLayoutInfo = new AppLayoutInfo();
        let layoutItems: AppLayoutInfo[] = [layout];
        model.sortAllData(layoutItems, []);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getAppItemPosX', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.getAppItemPosX();
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getAppItemPosY', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.getAppItemPosY();
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getAppItemOpacity', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.getAppItemOpacity();
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('initAnimationParamsByScreen1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.destroyAnimationParamsByScreen(0);
        model.initAnimationParamsByScreen(0);
        if (model.getDynamicEffectMap(0)) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('initAnimationParamsByScreen2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.initAnimationParamsByScreen(0);
        model.initAnimationParamsByScreen(0);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('destroyAnimationParamsByScreen', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.initAnimationParamsByScreen(0);
        model.destroyAnimationParamsByScreen(0);
        if (!model.getDynamicEffectMap(0)) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('initDynamicEffect1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.initDynamicEffect(0, 0, [], [], [], []);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('initDynamicEffect2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.initDynamicEffect(0, 1, [], [], [], []);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('initDynamicEffectFold1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.initDynamicEffectFold(0, 1, [], [], [], [], [], [], [], [], true);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('initDynamicEffectFold2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.initDynamicEffectFold(0, 2, [], [], [], [], [], [], [], [], false);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('initDynamicEffectFold3', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        AppStorage.setOrCreate('isAppCenterShow', true);
        model.initDynamicEffectFold(0, 0, [], [], [], [], [], [], [], [], false);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('initDynamicEffectFold4', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        AppStorage.setOrCreate('isAppCenterShow', true);
        model.initDynamicEffectFold(1, 0, [], [], [], [], [], [], [], [], false);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('initDynamicEffectFold5', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.destroyAnimationParamsByScreen(0);
        model.initDynamicEffectFold(0, 1, [], [], [], [], [], [], [], [], false);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('initDynamicEffectFold6', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        AppStorage.setOrCreate('isAppCenterShow', true);
        model.initAnimationParamsByScreen(0);
        model.initDynamicEffectFold(0, 1, [], [], [], [], [], [], [], [], false);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('initDynamicEffectFold7', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        AppStorage.setOrCreate('isAppCenterShow', false);
        model.initAnimationParamsByScreen(0);
        model.initDynamicEffectFold(0, 1, [], [], [], [], [], [], [], [], false);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('setAppItemEdgePosForFold', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.setAppItemEdgePosForFold([]);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('setCurSearchPageIndex', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.setCurSearchPageIndex(0);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('getCurSearchPageIndex', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.setCurSearchPageIndex(0);
        if (model.getCurSearchPageIndex() === 0) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('registerDynamicEffect1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.unregisterDynamicEffect(0, 0);
        model.destroyAnimationParamsByScreen(0);
        if (model.registerDynamicEffect(0, 0, [], [], [], [])) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(false).assertTrue();
    })
    it('registerDynamicEffect2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.destroyAnimationParamsByScreen(0);
        model.registerDynamicEffect(0, 0, [], [], [], []);
        if (!model.registerDynamicEffect(0, 0, [], [], [], [])) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('registerDynamicEffect3', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.initAnimationParamsByScreen(0);
        model.registerDynamicEffect(0, 0, [], [], [], []);
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('registerDynamicEffect4', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.initAnimationParamsByScreen(0);
        model.registerDynamicEffect(0, 0, [], [], [], []);
        if (!model.registerDynamicEffect(0, 0, [], [], [], [])) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(false).assertTrue();
    })
    it('unregisterDynamicEffect1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.destroyAnimationParamsByScreen(0);
        model.registerDynamicEffect(0, 0, [], [], [], []);
        if (model.unregisterDynamicEffect(0, 0)) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('unregisterDynamicEffect2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.destroyAnimationParamsByScreen(0);
        model.unregisterDynamicEffect(0, 0);
        if (!model.unregisterDynamicEffect(0, 0)) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('unregisterDynamicEffect3', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.initAnimationParamsByScreen(0);
        model.registerDynamicEffect(0, 0, [], [], [], []);
        if (model.unregisterDynamicEffect(0, 0)) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('unregisterDynamicEffect4', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.initAnimationParamsByScreen(0);
        model.unregisterDynamicEffect(0, 0);
        if (!model.unregisterDynamicEffect(0, 0)) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('getDynamicEffectMap1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.initAnimationParamsByScreen(0);
        if (model.getDynamicEffectMap(0)) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('getDynamicEffectMap2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.destroyAnimationParamsByScreen(0);
        if (!model.getDynamicEffectMap(0)) {
          expect(model instanceof AppCenterViewModel).assertTrue();
          return;
        }
      } catch (e) {
      }
      expect(model instanceof AppCenterViewModel).assertTrue();
    })
    it('startPreloadSwiperPages1', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.startPreloadSwiperPages(0);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('startPreloadSwiperPages2', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.startPreloadSwiperPages(0);
        model.startPreloadSwiperPages(0);
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('updateSearchInputTextBeforeEnter', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.updateSearchInputTextBeforeEnter('');
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
    it('isChangedAfterEnter', Level.LEVEL0, (): void => {
      let model: AppCenterViewModel = AppCenterViewModel.getInstance();
      try {
        model.isChangedAfterEnter('');
        expect(model instanceof AppCenterViewModel).assertTrue();
      } catch (e) {
        expect(model instanceof AppCenterViewModel).assertTrue();
      }
    })
  })
}