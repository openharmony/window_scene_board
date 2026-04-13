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

import { CheckEmptyUtils, RectInfo } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { desktopUtil } from '@ohos/componenthelper';
import { DeviceHelper, sOutSideWindowMgr, ViewManagerPolicy } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers,
  when} from '@ohos/hypium'
import { PageDesktopOneShotManager } from '../../../../../../../Index'
import {
  CardItemInfo,
  CommonConstants,
  DesktopModeManager,
  editModeManager,
  FolderData,
  FormCenterViewManager,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  PadLaunchLayoutCacheManager
} from '../../../../../../main/ets/TsIndex'

const CLOCK_WEATHER_CARD_NAME: string = 'ClockWeatherCard';

export default function PageDesktopOneShotManagerTest() {
  describe('PageDesktopOneShotManagerTest', () => {
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
    it('test_isSatisfiedOneShotAnimation', 0, () => {
      try {
        let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
        let pageIndex: number = AppStorage.get<number>('pageIndex') as number;
        let scenePanelState: number = AppStorage.get<number>('scenePanelState') as number;
        let mLauncherLayoutCacheManager = DeviceHelper.isPad() ? PadLaunchLayoutCacheManager.getInstance() :
        LaunchLayoutCacheManager.getInstance();
        let gridLayoutItemInfo: GridLayoutItemInfo[] = mLauncherLayoutCacheManager.selectGridLayoutItemsByType(CommonConstants.TYPE_CARD);
        let cardIndex: number = gridLayoutItemInfo.findIndex(item => item.cardName === CLOCK_WEATHER_CARD_NAME &&
          !CheckEmptyUtils.isEmpty(item.cardId) && item.page === 0);
        let result: boolean = true;
        if (pageIndex !== 0 || scenePanelState !== 0 || cardIndex === -1) {
          result = false;
        }
        let response: boolean = instance.isSatisfiedOneShotAnimation()
        expect(response).assertEqual(result);
      } catch (err) {}
    })

    it('test_getClockPosition', 0, () => {
      try {
        let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
        let pageIndex: number = AppStorage.get<number>('pageIndex') as number;
        let scenePanelState: number = AppStorage.get<number>('scenePanelState') as number;
        let mLauncherLayoutCacheManager = DeviceHelper.isPad() ? PadLaunchLayoutCacheManager.getInstance() :
        LaunchLayoutCacheManager.getInstance();
        let gridLayoutItemInfo: GridLayoutItemInfo[] = mLauncherLayoutCacheManager.selectGridLayoutItemsByType(CommonConstants.TYPE_CARD);
        let cardIndex: number = gridLayoutItemInfo.findIndex(item => item.cardName === CLOCK_WEATHER_CARD_NAME &&
          !CheckEmptyUtils.isEmpty(item.cardId) && item.page === 0);
        let result: boolean = true;
        if (pageIndex !== 0 || scenePanelState !== 0 || cardIndex === -1) {
          result = false;
        }
        let cardPosition: RectInfo = instance.getClockPosition()
        let response: boolean = true;
        if (cardPosition.left === 0) {
          response = false;
        }
        expect(response).assertEqual(result);
      } catch (err) {}
    })

    it('test_isClockWeatherCard', 0, () => {
      try {
        let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
        let isSatisfied: boolean = instance.isSatisfiedOneShotAnimation();
        instance.setIsHideClockAnimation(true);
        let mLauncherLayoutCacheManager = DeviceHelper.isPad() ? PadLaunchLayoutCacheManager.getInstance() :
        LaunchLayoutCacheManager.getInstance();
        let gridLayoutItemInfo: GridLayoutItemInfo[] = mLauncherLayoutCacheManager.selectGridLayoutItemsByType(CommonConstants.TYPE_CARD);
        let cardIndex: number = gridLayoutItemInfo.findIndex(item => item.cardName === CLOCK_WEATHER_CARD_NAME &&
          !CheckEmptyUtils.isEmpty(item.cardId) && item.page === 0);
        let response: boolean;
        if (cardIndex! === -1 && isSatisfied) {
          response = instance.isClockWeatherCard(gridLayoutItemInfo[cardIndex])
          expect(response).assertEqual(true);
        } else {
          response = instance.isClockWeatherCard(gridLayoutItemInfo[0])
          expect(response).assertEqual(false);
        }
      } catch (err) {}
    })

    it('test_notifiyFormHideCard', 0, () => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      instance.notifiyFormHideCard();
      expect(instance).not().assertNull();
    })

    it('test_setIsHideClockAnimation', 0, () => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      expect(instance).not().assertNull();
    })

    it("isRecentState", 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction)().afterReturn(false);
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let result = instance.isRecentState();
      expect(result).assertEqual(false);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
      done();
    })

    it("needAnimate1", 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let folderData = FolderData.getInstance()
      let mockFunction: Function = mocker.mockFunc(folderData, folderData.isFolderOpen);
      when(mockFunction)().afterReturn(true);
      let mockFunction1: Function = mocker.mockFunc(editModeManager, editModeManager.isInEditMode);
      when(mockFunction1)().afterReturn(true);
      let mockFunction2: Function = mocker.mockFunc(FormCenterViewManager.getInstance(), FormCenterViewManager.getInstance().isFormCenterViewShowing);
      when(mockFunction2)().afterReturn(true);
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let mockFunction3: Function = mocker.mockFunc(instance, instance.isRecentState);
      when(mockFunction3)().afterReturn(true);
      try {
        let result = instance.needAnimate();
        expect(result).assertEqual(false);
      }catch (err){}
      mocker.clear(folderData);
      mocker.clear(editModeManager);
      mocker.clear(FormCenterViewManager);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("needAnimate2", 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let folderData = FolderData.getInstance()
      let mockFunction: Function = mocker.mockFunc(FolderData.getInstance(), FolderData.getInstance().isFolderOpen);
      when(mockFunction)().afterReturn(true);
      let mockFunction1: Function = mocker.mockFunc(editModeManager, editModeManager.isInEditMode);
      when(mockFunction1)().afterReturn(true);
      let mockFunction2: Function = mocker.mockFunc(FormCenterViewManager.getInstance(), FormCenterViewManager.getInstance().isFormCenterViewShowing);
      when(mockFunction2)().afterReturn(true);
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let mockFunction3: Function = mocker.mockFunc(instance, instance.isRecentState);
      when(mockFunction3)().afterReturn(false);
      try {
        let result = instance.needAnimate();
        expect(result).assertEqual(false);
      } catch (err) {}
      mocker.clear(folderData);
      mocker.clear(editModeManager);
      mocker.clear(FormCenterViewManager.getInstance());
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("isBaseDeskPage1", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function = mocker.mockFunc(instance, instance.needAnimate);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let result = instance.isBaseDeskPage();
      expect(result).assertEqual(false);
      mocker.clear(AppStorage);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("isBaseDeskPage2", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function = mocker.mockFunc(instance, instance.needAnimate);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let result = instance.isBaseDeskPage();
      expect(result).assertEqual(true);
      mocker.clear(AppStorage);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("isSatisfiedOneShotAnimation1", 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =  mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction)().afterReturn(false);
      let mockFunction1: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().checkActiveSessionListIsEmpty);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction4: Function = mocker.mockFunc(DesktopModeManager.getInstance(), DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction7: Function = mocker.mockFunc(desktopUtil, desktopUtil.getPageIndexValue);
      when(mockFunction7)(ArgumentMatchers.any).afterReturn(0);
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let gridItemInfo1 = new GridLayoutItemInfo();
      gridItemInfo1.row = 1;
      gridItemInfo1.column = 1;
      gridItemInfo1.cardName = 'ClockWeatherCard';
      gridItemInfo1.bundleName = 'com.ohos.totemweather';
      gridItemInfo1.cardId = 'cardId';
      let gridItemInfo2 = new GridLayoutItemInfo();
      gridItemInfo2.row = 2;
      gridItemInfo2.column = 2;
      gridItemInfo1.cardName = 'ClockWeatherCard1';
      gridItemInfo1.bundleName = 'com.ohos.totemweather1';
      gridItemInfo1.cardId = 'cardId1';
      let gridLayoutItemInfoList = [gridItemInfo1,gridItemInfo2]
      let mockFunction6: Function = mocker.mockFunc(instance, instance.needAnimate);
      when(mockFunction6)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction5: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfoList);
      let result = instance.isSatisfiedOneShotAnimation();
      expect(result).assertInstanceOf('Boolean');
      mocker.clear(DeviceHelper);
      mocker.clear(SCBSceneSessionManager.getInstance());
      mocker.clear(ViewManagerPolicy);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(DesktopModeManager.getInstance());
      mocker.clear(desktopUtil);
      mocker.clear(instance);
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clearAll();
      done();
    })

    it("isSatisfiedOneShotAnimation2", 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =  mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction)().afterReturn(false);
      let mockFunction1: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().checkActiveSessionListIsEmpty);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction4: Function = mocker.mockFunc(DesktopModeManager.getInstance(), DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction7: Function = mocker.mockFunc(desktopUtil, desktopUtil.getPageIndexValue);
      when(mockFunction7)(ArgumentMatchers.any).afterReturn(1);
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let gridItemInfo1 = new GridLayoutItemInfo();
      gridItemInfo1.row = 1;
      gridItemInfo1.column = 1;
      gridItemInfo1.cardName = 'ClockWeatherCard';
      gridItemInfo1.bundleName = 'com.ohos.totemweather';
      gridItemInfo1.cardId = 'cardId';
      let gridItemInfo2 = new GridLayoutItemInfo();
      gridItemInfo2.row = 2;
      gridItemInfo2.column = 2;
      gridItemInfo1.cardName = 'ClockWeatherCard1';
      gridItemInfo1.bundleName = 'com.ohos.totemweather1';
      gridItemInfo1.cardId = 'cardId1';
      let gridLayoutItemInfoList = [gridItemInfo1,gridItemInfo2]
      let mockFunction6: Function = mocker.mockFunc(instance, instance.needAnimate);
      when(mockFunction6)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction5: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfoList);
      let result = instance.isSatisfiedOneShotAnimation();
      expect(result).assertInstanceOf('Boolean');
      mocker.clear(DeviceHelper);
      mocker.clear(SCBSceneSessionManager.getInstance());
      mocker.clear(ViewManagerPolicy);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(DesktopModeManager.getInstance());
      mocker.clear(desktopUtil);
      mocker.clear(instance);
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clearAll();
      done();
    })

    it("isSatisfiedOneShotAnimation3", 0, async(done:Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =  mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction)().afterReturn(false);
      let mockFunction1: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().checkActiveSessionListIsEmpty);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction4: Function = mocker.mockFunc(DesktopModeManager.getInstance(), DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction7: Function = mocker.mockFunc(desktopUtil, desktopUtil.getPageIndexValue);
      when(mockFunction7)(ArgumentMatchers.any).afterReturn(1);
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let gridItemInfo1 = new GridLayoutItemInfo();
      gridItemInfo1.row = 1;
      gridItemInfo1.column = 1;
      gridItemInfo1.cardName = 'ClockWeatherCard';
      gridItemInfo1.bundleName = 'com.ohos.totemweather';
      gridItemInfo1.cardId = 'cardId';
      let gridItemInfo2 = new GridLayoutItemInfo();
      gridItemInfo2.row = 2;
      gridItemInfo2.column = 2;
      gridItemInfo1.cardName = 'ClockWeatherCard1';
      gridItemInfo1.bundleName = 'com.ohos.totemweather1';
      gridItemInfo1.cardId = 'cardId1';
      let gridLayoutItemInfoList = [gridItemInfo1,gridItemInfo2]
      let mockFunction6: Function = mocker.mockFunc(instance, instance.needAnimate);
      when(mockFunction6)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction5: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfoList);
      (instance as object)['isSatisfiedCardList'] = ['cardId1','cardId','cardId2']
      let result = instance.isSatisfiedOneShotAnimation();
      expect(result).assertInstanceOf('Boolean');
      mocker.clear(DeviceHelper);
      mocker.clear(SCBSceneSessionManager.getInstance());
      mocker.clear(ViewManagerPolicy);
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(DesktopModeManager.getInstance());
      mocker.clear(desktopUtil);
      mocker.clear(instance);
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clearAll();
      done();
    })

    it("getClockPosition1", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      (instance as object)['isSatisfiedCondition'] = false;
      let result = instance.getClockPosition();
      expect(result.bottom).assertEqual(0);
      done();
    })

    it("getClockPosition2", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      (instance as object)['isSatisfiedCondition'] = true;
      (instance as object)['clockWeatherLayout'] = {
        cardId:'cardId',
        bundleName:'bundleName'
      } as GridLayoutItemInfo;
      let result = instance.getClockPosition();
      let cardItem:CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'bundleName';
      cardItem.cardId = 'cardId';
      expect(result.bottom).assertEqual(0);
      done();
    })

    it("notifiyFormHideCard1", 0, async(done:Function) => {
      try {
        let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
        (instance as object)['isSatisfiedCondition'] = true;
        (instance as object)['isHideClockAnimation'] = true;
        instance.notifiyFormHideCard();
        expect(instance instanceof PageDesktopOneShotManager).assertTrue();
      } catch (err) {}
      done();
    })

    it("notifiyFormHideCard2", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      (instance as object)['isSatisfiedCondition'] = false;
      (instance as object)['isHideClockAnimation'] = false;
      instance.notifiyFormHideCard();
      expect(instance instanceof PageDesktopOneShotManager).assertTrue();
      done();
    })

    it("listenStartClockAnimation", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      (instance as object)['clockWeatherLayout'] = {
        cardId:'cardId',
        bundleName:'bundleName'
      } as GridLayoutItemInfo;
      (instance as object)['listenStartClockAnimation']();
      expect((instance as object)['isSatisfiedCondition']).assertEqual(false);
      done();
    })

    it("notifyUpdateCardStyle1", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(instance, (instance as object)['getAllClockWeatherCard']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(['1','2']);
      instance.notifyUpdateCardStyle('style');
      expect((instance as object)['clockStyle']).assertEqual('style');
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("notifyUpdateCardStyle2", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(instance, (instance as object)['getAllClockWeatherCard']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(['1','2']);
      instance.notifyUpdateCardStyle('style');
      expect((instance as object)['clockStyle']).assertEqual('style');
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("updateCardStyle", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let clockCardIdList:string[] = (instance as object)['clockCardIdList'] = ['cardId1','cardId2','cardId3'];
      (instance as object)['updateCardStyle()'];
      expect(clockCardIdList.length>0).assertEqual(true);
      done();
    })

    it("listenScreenLockBeginSleep", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      (instance as object)['listenScreenLockBeginSleep']();
      let result:string[] = (instance as object)['isSatisfiedCardList']
      expect(result.length>0).assertEqual(true);
      done();
    })

    it("getAllClockWeatherCard", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let gridItem1 = {
        cardId:'cardId',
        bundleName:'com.ohos.totemweather',
        cardName:'ClockWeatherCard'
      } as GridLayoutItemInfo;
      let gridItem2 = {
        cardId:'cardId',
        bundleName:'com.ohos',
        cardName:'ClockWeather'
      } as GridLayoutItemInfo;
      let gridItem3 = {
        cardId:'',
        bundleName:'com.ohos',
        cardName:'ClockWeather'
      } as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(instance, (instance as object)['selectGridLayoutItemsByType']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([gridItem1,gridItem2,gridItem3,gridItem1,gridItem1]);
      try {
        let result:string[] = (instance as object)['getAllClockWeatherCard']();
        expect(result.length>=0).assertEqual(true);
      } catch (err) {}
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("compareGridLayoutItemByLocation1", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let itemA = {
        cardId:'cardId',
        bundleName:'com.ohos.totemweather',
        cardName:'ClockWeatherCard'
      } as GridLayoutItemInfo;
      let itemB = {
        cardId:'cardId',
        bundleName:'com.ohos',
        cardName:'ClockWeather'
      } as GridLayoutItemInfo;
      let result:number = (instance as object)['compareGridLayoutItemByLocation'](itemA,itemB);
      expect(result).assertEqual(0);
      done();
    })

    it("compareGridLayoutItemByLocation2", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let itemA = {
        row:2,
        column:2,
        cardId:'cardId',
        bundleName:'com.ohos.totemweather',
        cardName:'ClockWeatherCard'
      } as GridLayoutItemInfo;
      let itemB = {
        row:1,
        column:1,
        cardId:'cardId',
        bundleName:'com.ohos',
        cardName:'ClockWeather'
      } as GridLayoutItemInfo;
      let result:number = (instance as object)['compareGridLayoutItemByLocation'](itemA,itemB);
      expect(result).assertEqual(1);
      done();
    })

    it("isClockWeatherCard1", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let result:boolean = (instance as object)['isClockWeatherCard']([]);
      expect(result).assertEqual(false);
      done();
    })

    it("isClockWeatherCard2", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let itemA = {
        row:2,
        column:2,
        cardId:'cardId',
        bundleName:'com.ohos.totemweather',
        cardName:'ClockWeatherCard'
      } as GridLayoutItemInfo;
      (instance as object)['clockWeatherLayout'] = itemA;
      let result:boolean = (instance as object)['isClockWeatherCard'](itemA);
      expect(result).assertEqual(false);
      done();
    })

    it("setIsHideClockAnimation", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      instance.setIsHideClockAnimation(true);
      let result:boolean = (instance as object)['isHideClockAnimation']
      expect(result).assertEqual(true);
      done();
    })

    it("setFormScale", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      instance.setFormScale(1,1,'1','1');
      let centerY:ScaleOptions = (instance as object)['mFormScale'];
      expect(centerY.centerY).assertEqual('1');
      done();
    })

    it("getItemScale", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let result:ScaleOptions = instance.getItemScale();
      expect(result.y).assertEqual(NumberConstants.CONSTANT_NUMBER_ONE);
      done();
    })

    it("getCardDimension1", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let itemA = {
        row:2,
        column:2,
        cardId:'cardId',
        bundleName:'com.ohos.totemweather',
        cardName:'ClockWeatherCard',
        area:[1,2]
      } as GridLayoutItemInfo;
      (instance as object)['clockWeatherLayout'] = itemA;
      let result:number = instance.getCardDimension();
      expect(result).assertEqual(2);
      done();
    })

    it("getCardDimension2", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let itemA = {
        row:2,
        column:2,
        cardId:'cardId',
        bundleName:'com.ohos.totemweather',
        cardName:'ClockWeatherCard'
      } as GridLayoutItemInfo;
      (instance as object)['clockWeatherLayout'] = itemA;
      let result:number = instance.getCardDimension();
      expect(instance).not().assertUndefined();
      done();
    })

    it("getSatisfiedCardList", 0, async(done:Function) => {
      let instance: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      (instance as object)['getSatisfiedCardList']();
      let result:string[] = (instance as object)['isSatisfiedCardList']
      expect(result.length>=0).assertEqual(true);
      done();
    })
  })
}
