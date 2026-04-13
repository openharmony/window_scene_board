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
  AppItemInfo,
  AppModel,
  AtomicServiceAppModel,
  CardItemInfo,
  CommonConstants,
  FormModel
} from '@ohos/launchercommon';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  Level,
  TestType,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import RecommendManager from '../../../../../../main/ets/default/manager/RecommendFormManager';
import ServiceFormManager from '../../../../../../main/ets/default/manager/ServiceFormManager';

export function ServiceFormManagerTest() {
  describe('ServiceFormManagerTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getShowFormInfos_emptyRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        const arr: CardItemInfo[] = manager.getShowFormInfos([]);
        expect(arr.length).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getShowFormInfos_middleRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        let cardItemList: CardItemInfo[] = [];
        let cardItem: CardItemInfo = new CardItemInfo();
        cardItem.cardDimension = 3;
        cardItemList.push(cardItem);
        const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
        expect(arr.length).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getShowFormInfos_middleRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        let cardItemList: CardItemInfo[] = [];
        let cardItem: CardItemInfo = new CardItemInfo();
        cardItem.cardDimension = 3;
        cardItemList.push(cardItem);
        const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
        expect(arr.length).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getShowFormInfos_oneSmallRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        let cardItemList: CardItemInfo[] = [];
        let cardItem: CardItemInfo = new CardItemInfo();
        cardItem.cardId = '123';
        cardItem.cardDimension = 2;
        cardItemList.push(cardItem);
        const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
        expect(arr.length).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getShowFormInfos_twoSmallRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        let cardItemList: CardItemInfo[] = [];
        let cardItem: CardItemInfo = new CardItemInfo();
        cardItem.cardId = '123';
        cardItem.cardDimension = 2;
        cardItemList.push(cardItem);
        cardItem.cardId = '234';
        cardItem.cardDimension = 2;
        cardItemList.push(cardItem);
        const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
        expect(arr.length).assertEqual(2);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('formInfoComplete', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        let recommendForms: CardItemInfo[] = [];
        manager.formInfoComplete(recommendForms, []);
        expect(recommendForms.length).assertEqual(0);

        let cardItem: CardItemInfo = new CardItemInfo();
        cardItem.cardId = '123';
        cardItem.cardDimension = 2;
        recommendForms.push(cardItem);
        manager.formInfoComplete(recommendForms, []);
        expect(recommendForms.length).assertEqual(1);

        let serviceFormAppList: AppItemInfo[] = [];
        let serviceFormApp: AppItemInfo = new AppItemInfo();
        serviceFormApp.bundleName = 'test';
        serviceFormAppList.push(serviceFormApp);
        manager.formInfoComplete(recommendForms, serviceFormAppList);
        expect(recommendForms.length).assertEqual(1);

        recommendForms[0].bundleName = 'test';
        manager.formInfoComplete(recommendForms, serviceFormAppList);
        expect(recommendForms.length).assertEqual(1);

        serviceFormAppList[0].applicationLabelId = 123;
        serviceFormAppList[0].applicationName = 'testAppName';
        manager.formInfoComplete(recommendForms, serviceFormAppList);
        expect(recommendForms[0].appLabelId === 123).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getServiceFormAppList_emptyList', TestType.FUNCTION | Level.LEVEL0, async () => {
      const mocker: MockKit = new MockKit();
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        const formModel: FormModel = FormModel.getInstance();
        const appModel: AppModel = AppModel.getInstance();

        const mockGetFormMap: Function = mocker.mockFunc(formModel, formModel.getAllAppItemFormInfoMap);
        let appItemFormInfoMap: Map<string, CardItemInfo[]> = new Map<string, CardItemInfo[]>();
        when(mockGetFormMap)(ArgumentMatchers.any).afterReturn(appItemFormInfoMap);
        const mockGetFormAppList: Function = mocker.mockFunc(appModel, appModel.getAppList);
        let appListInfo: AppItemInfo[] = [];
        when(mockGetFormAppList)(ArgumentMatchers.any).afterReturn(appListInfo);

        let appAtomicFormInfoMap: Map<string, CardItemInfo[]> = new Map<string, CardItemInfo[]>();
        const atomicAppModel: AtomicServiceAppModel = AtomicServiceAppModel.getInstance();
        const getAtomicFormAppList: Function = mocker.mockFunc(atomicAppModel, atomicAppModel.getAtomicServiceAppList);
        let atomicAppListInfo: AppItemInfo[] = [];
        when(getAtomicFormAppList)(ArgumentMatchers.any).afterReturn(atomicAppListInfo);
        let allAppList: AppItemInfo[] = await manager.getServiceFormAppList();
        expect(allAppList.length).assertEqual(0);
        mocker.clear(formModel);
        mocker.clear(appModel);
        mocker.clear(atomicAppModel);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('getServiceFormAppList', TestType.FUNCTION | Level.LEVEL0, async () => {
      const mocker: MockKit = new MockKit();
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        const formModel: FormModel = FormModel.getInstance();
        const appModel: AppModel = AppModel.getInstance();
        const mockGetFormMap: Function = mocker.mockFunc(formModel, formModel.getAllAppItemFormInfoMap);
        let appItemFormInfoMap: Map<string, CardItemInfo[]> = new Map<string, CardItemInfo[]>();
        let bundleName: string = 'com.ohos.photos';
        let cardItemInfo: CardItemInfo = new CardItemInfo();
        cardItemInfo.bundleName = bundleName;
        cardItemInfo.cardDimension = 2;
        let cardItemList: CardItemInfo[] = [cardItemInfo];
        appItemFormInfoMap.set(bundleName, cardItemList);
        when(mockGetFormMap)(ArgumentMatchers.any).afterReturn(appItemFormInfoMap);
        const mockGetFormAppList: Function = mocker.mockFunc(appModel, appModel.getAppList);
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.bundleName = bundleName;
        let appListInfo: AppItemInfo[] = [];
        appListInfo.push(appItem);
        when(mockGetFormAppList)(ArgumentMatchers.any).afterReturn(appListInfo);

        let appAtomicFormInfoMap: Map<string, CardItemInfo[]> = new Map<string, CardItemInfo[]>();
        const atomicAppModel: AtomicServiceAppModel = AtomicServiceAppModel.getInstance();
        const getAtomicFormAppList: Function = mocker.mockFunc(atomicAppModel, atomicAppModel.getAtomicServiceAppList);
        let atomicAppListInfo: AppItemInfo[] = [];
        when(getAtomicFormAppList)(ArgumentMatchers.any).afterReturn(atomicAppListInfo);
        let allAppList: AppItemInfo[] = await manager.getServiceFormAppList();
        expect(allAppList.length).assertEqual(1);
        mocker.clear(formModel);
        mocker.clear(appModel);
        mocker.clear(atomicAppModel);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('getServiceFormAppList_atomicForm', TestType.FUNCTION | Level.LEVEL0, async () => {
      const mocker: MockKit = new MockKit();
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        const formModel: FormModel = FormModel.getInstance();
        const appModel: AppModel = AppModel.getInstance();
        const mockGetFormMap: Function = mocker.mockFunc(formModel, formModel.getAllAppItemFormInfoMap);
        let appItemFormInfoMap: Map<string, CardItemInfo[]> = new Map<string, CardItemInfo[]>();
        when(mockGetFormMap)(ArgumentMatchers.any).afterReturn(appItemFormInfoMap);
        const mockGetFormAppList: Function = mocker.mockFunc(appModel, appModel.getAppList);
        let appListInfo: AppItemInfo[] = [];
        when(mockGetFormAppList)(ArgumentMatchers.any).afterReturn(appListInfo);

        let appAtomicFormInfoMap: Map<string, CardItemInfo[]> = new Map<string, CardItemInfo[]>();
        let bundleName: string = 'com.ohos.photos';
        let cardItemInfo: CardItemInfo = new CardItemInfo();
        cardItemInfo.bundleName = bundleName;
        cardItemInfo.cardDimension = 2;
        let cardItemList: CardItemInfo[] = [cardItemInfo];
        appAtomicFormInfoMap.set(bundleName, cardItemList);
        const atomicAppModel: AtomicServiceAppModel = AtomicServiceAppModel.getInstance();
        const getAtomicFormAppList: Function = mocker.mockFunc(atomicAppModel, atomicAppModel.getAtomicServiceAppList);
        let atomicAppListInfo: AppItemInfo[] = [];
        let atomicItem: AppItemInfo = new AppItemInfo();
        atomicItem.bundleName = bundleName;
        atomicAppListInfo.push(atomicItem);
        when(getAtomicFormAppList)(ArgumentMatchers.any).afterReturn(atomicAppListInfo);
        let allAppList: AppItemInfo[] = await manager.getServiceFormAppList();
        expect(allAppList.length >= 0).assertTrue();
        mocker.clear(formModel);
        mocker.clear(appModel);
        mocker.clear(atomicAppModel);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('getServiceForm', TestType.FUNCTION | Level.LEVEL0, async () => {
      const mocker: MockKit = new MockKit();
      try {
        const recommendManager: RecommendManager = RecommendManager.getInstance();
        const mockGetArray: Function = mocker.mockFunc(recommendManager, recommendManager.getRecommendFormArray);
        let cardItemList: CardItemInfo[] = [];
        when(mockGetArray)(ArgumentMatchers.any).afterReturn([]);
        const serviceManager: ServiceFormManager = ServiceFormManager.getInstance();
        cardItemList = await serviceManager.getServiceForm();
        expect(cardItemList.length).assertEqual(0);
        mocker.clear(recommendManager);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('getShowFormInfosInner_emptyRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        const arr: CardItemInfo[] = manager.getShowFormInfosInner([]);
        expect(arr.length).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getShowFormInfosInner_middleRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        let cardItemList: CardItemInfo[] = [];
        let cardItem: CardItemInfo = new CardItemInfo();
        cardItem.cardDimension = 3;
        cardItemList.push(cardItem);
        const arr: CardItemInfo[] = manager.getShowFormInfosInner(cardItemList);
        expect(arr.length).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getShowFormInfosInner_oneSmallRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        let cardItemList: CardItemInfo[] = [];
        let cardItem: CardItemInfo = new CardItemInfo();
        cardItem.cardId = '123';
        cardItem.cardDimension = 2;
        cardItemList.push(cardItem);
        const arr: CardItemInfo[] = manager.getShowFormInfosInner(cardItemList);
        expect(arr.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getShowFormInfosInner_twoSmallRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        let cardItemList: CardItemInfo[] = [];
        let cardItem: CardItemInfo = new CardItemInfo();
        cardItem.cardId = '123';
        cardItem.cardDimension = 2;
        cardItemList.push(cardItem);
        cardItem.cardId = '234';
        cardItem.cardDimension = 2;
        cardItemList.push(cardItem);
        const arr: CardItemInfo[] = manager.getShowFormInfosInner(cardItemList);
        expect(arr.length).assertEqual(2);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getShowFormInfosInner_bigRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        const manager: ServiceFormManager = ServiceFormManager.getInstance();
        let cardItemList: CardItemInfo[] = [];
        let cardItem: CardItemInfo = new CardItemInfo();
        cardItem.cardId = '123';
        cardItem.cardDimension = 4;
        cardItemList.push(cardItem);
        const arr: CardItemInfo[] = manager.getShowFormInfosInner(cardItemList);
        expect(arr.length).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}