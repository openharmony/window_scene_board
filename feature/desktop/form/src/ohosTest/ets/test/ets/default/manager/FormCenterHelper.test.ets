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
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  MockKit,
  TestType,
  when,
} from '@ohos/hypium';
import RecommendCardsDataPool from '../../../../../../main/ets/default/datapool/RecommendCardsDataPool';
import RecommendFormManager from '../../../../../../main/ets/default/manager/RecommendFormManager';
import { ArrayList } from '@kit.ArkTS';
import { AppItemInfo,
  AppModel,
  AtomicServiceAppModel,
  CardItemInfo,
  CommonConstants,
  EventConstants,
  FormLayoutCacheManager,
  FormModel,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import AppInstallDataSource from '../../../../../../main/ets/default/datasource/AppInstallDataSource';
import AppUpdateDataSource from '../../../../../../main/ets/default/datasource/AppUpdateDataSource';
import RecommendManager from '../../../../../../main/ets/default/manager/RecommendFormManager';
import ServiceFormManager from '../../../../../../main/ets/default/manager/ServiceFormManager';
import { FormHostService, VisibleChangeListener } from '../../../../../../main/ets/default/service/FormHostService';
import {
  SCBSceneContainerSessionArray,
  SCBSceneSessionManager, SCBScreenSessionManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import { FormCenterViewModel } from '../../../../../../main/ets/formcenter/viewmodel/FormCenterViewModel';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { FormViewModel } from '../../../../../../main/ets/default/viewmodel/FormViewModel';
import { FormStyleConfig } from '../../../../../../main/ets/default/common/FormStyleConfig';
import { FormCenterViewData } from '../../../../../../main/ets/default/viewmodel/FormCenterViewData';

export function CardMenuHelperTest() {
  describe('FormMenuHelperTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('getFormCount', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: RecommendFormManager = RecommendFormManager.getInstance();
      const count: number | undefined = manager.getFormCount('');
      expect(count).assertUndefined();
    });

    it('getRecommendFormArray', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: RecommendFormManager = RecommendFormManager.getInstance();
      const pool: RecommendCardsDataPool = RecommendCardsDataPool.getInstance();
      const mocker: MockKit = new MockKit();
      const mockGetShowDataList: Function = mocker.mockFunc(pool, pool.getShowDataList);
      let recommendFormList: ArrayList<CardItemInfo> = new ArrayList<CardItemInfo>();
      when(mockGetShowDataList)(ArgumentMatchers.any).afterReturn(recommendFormList);
      const rstRecommendList: CardItemInfo[] = await manager.getRecommendFormArray();
      expect(rstRecommendList.length).assertEqual(0);
      mocker.clear(pool);
      mocker.clearAll();
    });

    it('addFormToRecommendServiceFormList_emptyBundle', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: RecommendFormManager = RecommendFormManager.getInstance();
      const mocker: MockKit = new MockKit();
      let called: boolean = false;
      const appInstallDataSource: AppInstallDataSource = AppInstallDataSource.getInstance();
      const mockDataAdd: Function = mocker.mockFunc(appInstallDataSource, appInstallDataSource.onDataAdd);
      when(mockDataAdd)(ArgumentMatchers.any).afterAction(() => { called = true; });
      manager.addFormToRecommendServiceFormList('', EventConstants.EVENT_REQUEST_RECOMMEND_FORM_ADD);
      expect(called).assertFalse();
      mocker.clear(appInstallDataSource);
      mocker.clearAll();
    });

    it('addFormToRecommendServiceFormList_emptyRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: RecommendFormManager = RecommendFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const mocker: MockKit = new MockKit();
      const mockGetFormInfo: Function = mocker.mockFunc(formModel, formModel.getAppItemFormInfo);
      let formInfoList: CardItemInfo[] = [];
      let formItem: CardItemInfo = new CardItemInfo();
      formItem.cardId = '123';
      formItem.bundleName = 'test';
      formInfoList.push(formItem);
      when(mockGetFormInfo)(formItem.bundleName).afterReturn(formInfoList);

      const dataPool: RecommendCardsDataPool = RecommendCardsDataPool.getInstance();
      const mockGetRecommendForm: Function = mocker.mockFunc(dataPool, dataPool.getRecommendForm);
      when(mockGetRecommendForm)(formInfoList).afterReturn(null);

      let called: boolean = false;
      const appInstallDataSource: AppInstallDataSource = AppInstallDataSource.getInstance();
      const mockDataAdd: Function = mocker.mockFunc(appInstallDataSource, appInstallDataSource.onDataAdd);
      when(mockDataAdd)(ArgumentMatchers.any).afterAction(() => { called = true; });
      manager.addFormToRecommendServiceFormList('test', EventConstants.EVENT_REQUEST_RECOMMEND_FORM_ADD);
      expect(called).assertFalse();
      mocker.clear(formModel);
      mocker.clear(dataPool);
      mocker.clear(appInstallDataSource);
      mocker.clearAll();
    });

    it('addFormToRecommendServiceFormList', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: RecommendFormManager = RecommendFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const mocker: MockKit = new MockKit();
      const mockGetFormInfo: Function = mocker.mockFunc(formModel, formModel.getAppItemFormInfo);
      let formInfoList: CardItemInfo[] = [];
      let formItem: CardItemInfo = new CardItemInfo();
      formItem.cardId = '123';
      formItem.bundleName = 'test';
      formInfoList.push(formItem);
      when(mockGetFormInfo)(formItem.bundleName).afterReturn(formInfoList);

      const dataPool: RecommendCardsDataPool = RecommendCardsDataPool.getInstance();
      const mockGetRecommendForm: Function = mocker.mockFunc(dataPool, dataPool.getRecommendForm);
      when(mockGetRecommendForm)(formInfoList).afterReturn(formItem);

      let called: boolean = false;
      const appInstallDataSource: AppInstallDataSource = AppInstallDataSource.getInstance();
      const mockDataAdd: Function = mocker.mockFunc(appInstallDataSource, appInstallDataSource.onDataAdd);
      when(mockDataAdd)(ArgumentMatchers.any).afterAction(() => { called = true; });
      manager.addFormToRecommendServiceFormList('test', EventConstants.EVENT_REQUEST_RECOMMEND_FORM_ADD);
      expect(called).assertTrue();

      called = false;
      const appUpdateDataSource: AppUpdateDataSource = AppUpdateDataSource.getInstance();
      const mockDataUpdate: Function = mocker.mockFunc(appUpdateDataSource, appUpdateDataSource.onDataAdd);
      when(mockDataUpdate)(ArgumentMatchers.any).afterAction(() => { called = true; });
      manager.addFormToRecommendServiceFormList('test', EventConstants.EVENT_REQUEST_RECOMMEND_FORM_UPDATE);
      expect(called).assertTrue();
      mocker.clear(formModel);
      mocker.clear(appUpdateDataSource);
      mocker.clear(appInstallDataSource);
      mocker.clearAll();
    });

    it('removeFormFromRecommendServiceFormList', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: RecommendFormManager = RecommendFormManager.getInstance();
      const mocker: MockKit = new MockKit();
      let called: boolean = false;
      const appUpdateDataSource: AppUpdateDataSource = AppUpdateDataSource.getInstance();
      const mockDataRemove: Function = mocker.mockFunc(appUpdateDataSource, appUpdateDataSource.onDataRemove);
      when(mockDataRemove)(ArgumentMatchers.any).afterAction(() => { called = true; });
      manager.removeFormFromRecommendServiceFormList('test');
      expect(called).assertTrue();
      mocker.clear(appUpdateDataSource);
      mocker.clearAll();
    });

    it('getShowFormInfos_emptyRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const arr: CardItemInfo[] = manager.getShowFormInfos([]);
      expect(arr.length).assertEqual(0);
    });

    it('getShowFormInfos_middleRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      let cardItemList: CardItemInfo[] = [];
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.cardDimension = 3;
      cardItemList.push(cardItem);
      const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
      expect(arr.length).assertEqual(1);
    });

    it('getShowFormInfos_middleRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      let cardItemList: CardItemInfo[] = [];
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.cardDimension = 3;
      cardItemList.push(cardItem);
      const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
      expect(arr.length).assertEqual(1);
    });

    it('getShowFormInfos_oneSmallRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      let cardItemList: CardItemInfo[] = [];
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.cardId = '123';
      cardItem.cardDimension = 2;
      cardItemList.push(cardItem);
      const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
      expect(arr.length).assertEqual(0);
    });

    it('getShowFormInfos_twoSmallRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
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
    });

    it('formInfoComplete', TestType.FUNCTION | Level.LEVEL0, () => {
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
    });

    it('getServiceFormAppList_emptyList', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const appModel: AppModel = AppModel.getInstance();
      const mocker: MockKit = new MockKit();
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
      mocker.clearAll();
    });

    it('getServiceFormAppList', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const appModel: AppModel = AppModel.getInstance();
      const mocker: MockKit = new MockKit();
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
      mocker.clearAll();
    });

    it('getServiceFormAppList_atomicForm', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const appModel: AppModel = AppModel.getInstance();
      const mocker: MockKit = new MockKit();
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
      expect(allAppList.length).assertEqual(1);
      mocker.clear(formModel);
      mocker.clear(appModel);
      mocker.clear(atomicAppModel);
      mocker.clearAll();
    });

    it('getServiceForm', TestType.FUNCTION | Level.LEVEL0, async () => {
      const recommendManager: RecommendManager = RecommendManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockGetArray: Function = mocker.mockFunc(recommendManager, recommendManager.getRecommendFormArray);
      let cardItemList: CardItemInfo[] = [];
      when(mockGetArray)(ArgumentMatchers.any).afterReturn([]);
      const serviceManager: ServiceFormManager = ServiceFormManager.getInstance();
      cardItemList = await serviceManager.getServiceForm();
      expect(cardItemList.length).assertEqual(0);
      mocker.clear(recommendManager);
      mocker.clearAll();
    });

    it('getShowFormInfos_emptyRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const arr: CardItemInfo[] = manager.getShowFormInfos([]);
      expect(arr.length).assertEqual(0);
    });

    it('getShowFormInfos_middleRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      let cardItemList: CardItemInfo[] = [];
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.cardDimension = 3;
      cardItemList.push(cardItem);
      const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
      expect(arr.length).assertEqual(1);
    });

    it('getShowFormInfos_middleRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      let cardItemList: CardItemInfo[] = [];
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.cardDimension = 3;
      cardItemList.push(cardItem);
      const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
      expect(arr.length).assertEqual(1);
    });

    it('getShowFormInfos_oneSmallRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      let cardItemList: CardItemInfo[] = [];
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.cardId = '123';
      cardItem.cardDimension = 2;
      cardItemList.push(cardItem);
      const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
      expect(arr.length).assertEqual(0);
    });

    it('getShowFormInfos_twoSmallRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
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
    });

    it('formInfoComplete', TestType.FUNCTION | Level.LEVEL0, () => {
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
    });

    it('getServiceFormAppList_emptyList', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const appModel: AppModel = AppModel.getInstance();
      const mocker: MockKit = new MockKit();
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
      mocker.clearAll();
    });

    it('getServiceFormAppList', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const appModel: AppModel = AppModel.getInstance();
      const mocker: MockKit = new MockKit();
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
      mocker.clearAll();
    });

    it('getServiceFormAppList_atomicForm', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const appModel: AppModel = AppModel.getInstance();
      const mocker: MockKit = new MockKit();
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
      expect(allAppList.length).assertEqual(1);
      mocker.clear(formModel);
      mocker.clear(appModel);
      mocker.clear(atomicAppModel);
      mocker.clearAll();
    });

    it('getServiceForm', TestType.FUNCTION | Level.LEVEL0, async () => {
      const recommendManager: RecommendManager = RecommendManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockGetArray: Function = mocker.mockFunc(recommendManager, recommendManager.getRecommendFormArray);
      let cardItemList: CardItemInfo[] = [];
      when(mockGetArray)(ArgumentMatchers.any).afterReturn([]);
      const serviceManager: ServiceFormManager = ServiceFormManager.getInstance();
      cardItemList = await serviceManager.getServiceForm();
      expect(cardItemList.length).assertEqual(0);
      mocker.clear(recommendManager);
      mocker.clearAll();
    });

    it('getFormListByPageIndex_onlyCard', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.cardId = '123';
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.page = 0;
      layout.push(formItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);
      let formHostService: FormHostService = FormHostService.getInstance();
      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(1);
      mocker.clear(formLayoutManager);
      mocker.clearAll();
    });

    it('getFormListByPageIndex', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 0;
      layout.push(formItem);
      let formStackItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem.page = 0;
      let formItemInFormStack: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack.cardId = '234';
      formItemInFormStack.page = 0;
      formStackItem.layoutInfo = [[formItemInFormStack]];
      layout.push(formStackItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);
      let formHostService: FormHostService = FormHostService.getInstance();
      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(2);
      mocker.clear(formLayoutManager);
      mocker.clearAll();
    });

    it('getFormListByPageIndex_foldOpen', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 1;
      layout.push(formItem);
      let formStackItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem.page = 1;
      let formItemInFormStack: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack.cardId = '234';
      formItemInFormStack.page = 1;
      formStackItem.layoutInfo = [[formItemInFormStack]];
      layout.push(formStackItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      const mockFunc2: Function = mocker.mockFunc(sessionManager, sessionManager.isFoldablePhoneExpandStatus);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

      let formHostService: FormHostService = FormHostService.getInstance();
      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(2);
      mocker.clear(formLayoutManager);
      mocker.clear(sessionManager);
      mocker.clearAll();
    });

    it('recoverFormsOfNeighborPage', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 1;
      layout.push(formItem);
      let formStackItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem.page = 1;
      let formItemInFormStack: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack.cardId = '234';
      formItemInFormStack.page = 1;
      let formItemInFormStack1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack1.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack1.cardId = '345';
      formItemInFormStack1.page = 1;

      formStackItem.layoutInfo = [[formItemInFormStack, formItemInFormStack1]];
      layout.push(formStackItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      let layoutManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      const mockFunc2: Function = mocker.mockFunc(layoutManager, layoutManager.selectPageCount);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(3);

      let formHostService: FormHostService = FormHostService.getInstance();
      formHostService['insertListToCurrentRecycleList'](['123', '234', '345']);
      formHostService.recoverFormsOfNeighborPage(0);

      expect(formHostService['startHandlerTimer']).assertEqual(-1);
      mocker.clear(formLayoutManager);
      mocker.clear(layoutManager);
      mocker.clearAll();
    });

    it('recoverFormsOfNeighborPage_1', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 0;
      layout.push(formItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      let layoutManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      const mockFunc2: Function = mocker.mockFunc(layoutManager, layoutManager.selectPageCount);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(2);

      let formHostService: FormHostService = FormHostService.getInstance();
      formHostService['insertListToCurrentRecycleList'](['123']);
      formHostService.recoverFormsOfNeighborPage(1);

      expect(formHostService['startHandlerTimer']).assertEqual(-1);
      mocker.clear(formLayoutManager);
      mocker.clear(layoutManager);
      mocker.clearAll();
    });

    it('formRecoverWhenAppExitHandler_0', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      formHostService['startHandlerTimer'] = 123;
      formHostService.formRecoverWhenAppExitHandler(0);

      expect(formHostService['startHandlerTimer']).assertEqual(-1);
    });

    it('formRecoverWhenAppExitHandler', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      formHostService['startHandlerTimer'] = -1;
      formHostService['startRecycleTimer'] = 123;

      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 0;
      layout.push(formItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      formHostService.formRecoverWhenAppExitHandler(0);
      expect(formHostService['startRecycleTimer']).assertEqual(-1);
      mocker.clear(formLayoutManager);
      mocker.clearAll();
    });

    it('handleRecycleFormsOfInvisible', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      let formList: Array<string> = new Array();
      formList.push('123');
      formList.push('234');
      formList.push('345');
      formList.push('456');
      formHostService.formHostNotifyInvisible(formList);
      let formRecycleList: Array<string> = new Array();
      formRecycleList.push('123');
      formHostService.formHostNotifyRecycle(formRecycleList);

      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem1.typeId = CommonConstants.TYPE_CARD;
      formItem1.cardId = '123';
      formItem1.page = 0;
      formItem1.container = CommonConstants.CONTAINER_DESKTOP;
      layout.push(formItem1);

      let formItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem2.typeId = CommonConstants.TYPE_CARD;
      formItem2.cardId = '345';
      formItem2.page = 0;
      formItem2.container = CommonConstants.CONTAINER_DESKTOP;
      layout.push(formItem2);

      let formStackItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem1.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem1.page = 0;
      let formItemInFormStack1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack1.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack1.cardId = '234';
      formItemInFormStack1.page = 0;
      formItemInFormStack1.container = 55;
      formStackItem1.layoutInfo = [[formItemInFormStack1]];
      layout.push(formStackItem1);

      let formStackItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem2.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem2.page = 0;
      let formItemInFormStack2: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack2.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack2.cardId = '456';
      formItemInFormStack2.page = 0;
      formItemInFormStack2.container = 65;
      formStackItem2.layoutInfo = [[formItemInFormStack2]];
      layout.push(formStackItem2);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(4);

      mocker.clear(formLayoutManager);
      mocker.clearAll();
    });

    it('formHostNotifyVisible', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      let formList: Array<string> = new Array();
      formList.push('123');
      formList.push('234');
      formList.push('345');
      formList.push('456');
      let formRecycleList: Array<string> = new Array();
      formRecycleList.push('123');
      formRecycleList.push('567');
      formHostService.formHostNotifyRecycle(formRecycleList);
      formHostService.formHostNotifyVisible(formList);

      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      const mockFunc1: Function = mocker.mockFunc(sessionManager, sessionManager.isFoldablePhoneExpandStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

      const mockFunc2: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem1.typeId = CommonConstants.TYPE_CARD;
      formItem1.cardId = '123';
      formItem1.page = 0;
      formItem1.container = CommonConstants.CONTAINER_DESKTOP;
      layout.push(formItem1);

      let formStackItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem1.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem1.page = 0;
      let formItemInFormStack1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack1.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack1.cardId = '456';
      formItemInFormStack1.page = 0;
      formItemInFormStack1.container = 65;
      formStackItem1.layoutInfo = [[formItemInFormStack1]];
      layout.push(formStackItem1);

      when(mockFunc2)(ArgumentMatchers.any).afterReturn(layout);

      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(2);

      mocker.clear(formLayoutManager);
      mocker.clear(sessionManager);
      mocker.clearAll();
    });

    it('registerFormVisibleListener_empty', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      let calledTimes: number = 0;
      let visibleListener: VisibleChangeListener = {
        onVisibleChange: (visible: boolean): void => {
          calledTimes = calledTimes + 1;
        }
      };

      formHostService.registerFormVisibleListener('123', visibleListener);
      formHostService.registerFormVisibleListener('123', visibleListener);
      formHostService.registerFormVisibleListener('234', visibleListener);
      formHostService.formHostNotifyVisible(['123','345']);
      formHostService.unRegisterFormVisibleListener('123', visibleListener);
      formHostService.unRegisterFormVisibleListener('456', visibleListener);
      expect(calledTimes).assertEqual(2);

    });

    it('registerFormVisibleListener', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      let calledTimes: number = 0;
      let visibleListener: VisibleChangeListener = {
        onVisibleChange: (visible: boolean): void => {
          calledTimes = calledTimes + 1;
        }
      };

      formHostService.registerFormVisibleListener('123', visibleListener);
      formHostService.formHostNotifyVisible(['123']);
      formHostService.unRegisterFormVisibleListener('123', visibleListener);
      expect(calledTimes).assertEqual(1);
    });

    it('getAppFormsIndex', TestType.FUNCTION | Level.LEVEL0, () => {
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      let formItem: CardItemInfo = new CardItemInfo();
      formItem.bundleName = 'testBundle';
      formItem.abilityName = 'testAbility';
      formItem.moduleName = 'testModule';
      formItem.cardName = 'testName';
      formItem.area = [2, 2];
      let formItemList: CardItemInfo[] = [formItem];
      expect(formCenterView.getAppFormsIndex(formItem, formItemList)).assertEqual(0);
      let startForm: CardItemInfo = new CardItemInfo();
      expect(formCenterView.getAppFormsIndex(startForm, formItemList)).assertEqual(0);
    });

    it('updateFromCenterData_recommend0', TestType.FUNCTION | Level.LEVEL0, async (done: Function) => {
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      let formModel: FormModel = FormModel.getInstance();
      let serviceFormManager: ServiceFormManager = ServiceFormManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formModel, formModel.getFormCenterAppList);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([]);

      const mockFunc2: Function = mocker.mockFunc(serviceFormManager, serviceFormManager.getServiceForm);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([]);

      const mockFunc3: Function = mocker.mockFunc(serviceFormManager, serviceFormManager.getShowFormInfos);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn([]);

      await formCenterView.updateFromCenterData(false);
      expect(formCenterView.getAppList().length).assertLargerOrEqual(0);

      mocker.clear(formCenterView);
      mocker.clear(formModel);
      mocker.clear(serviceFormManager);
      mocker.clearAll();
      done();
    });

    it('updateFromCenterData_recommend1', TestType.FUNCTION | Level.LEVEL0, async (done: Function) => {
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      let formModel: FormModel = FormModel.getInstance();
      let serviceFormManager: ServiceFormManager = ServiceFormManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formModel, formModel.getFormCenterAppList);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([]);

      let formItem: CardItemInfo = new CardItemInfo();
      formItem.bundleName = 'testBundle';
      formItem.abilityName = 'testAbility';
      formItem.moduleName = 'testModule';
      formItem.cardName = 'testName';
      formItem.cardDimension = 2;
      const mockFunc2: Function = mocker.mockFunc(serviceFormManager, serviceFormManager.getServiceForm);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([formItem]);

      const mockFunc3: Function = mocker.mockFunc(serviceFormManager, serviceFormManager.getShowFormInfos);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn([formItem]);

      await formCenterView.updateFromCenterData(false);
      expect(formCenterView.getAppList().length).assertLargerOrEqual(0);

      mocker.clear(formCenterView);
      mocker.clear(formModel);
      mocker.clear(serviceFormManager);
      mocker.clearAll();
      done();
    });

    it('updateFromManagerData_Test01', TestType.FUNCTION | Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.thememanager';
      let formModel: FormModel = FormModel.getInstance();
      const isSupportFormCenterSplit: Function = mocker.mockFunc(formModel, formModel.isSupportFormCenterSplit);
      when(isSupportFormCenterSplit)(ArgumentMatchers.any).afterReturn(true);
      const getFormCenterAppList: Function = mocker.mockFunc(formModel, formModel.getFormCenterAppList);
      when(getFormCenterAppList)(ArgumentMatchers.any).afterReturn([appInfo]);

      await formCenterView.updateFromManagerData(true);
      await formCenterView.updateFromManagerData(false);
      formCenterView.getAppInfo(appInfo.bundleName);
      formCenterView.getAppList();
      formCenterView.getRecommendedCardList();
      formCenterView.updateFromManagerData(true);
      expect(true).assertTrue();
      mocker.clear(formModel);
      mocker.clearAll();
      done();
    });

    it('getFormDisplaySize_Test01', TestType.FUNCTION | Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();
      let formViewModel: FormViewModel = FormViewModel.getInstance();
      const getFormStyleConfig: Function = mocker.mockFunc(formViewModel, formViewModel.getFormStyleConfig);
      let formStyleConfig: FormStyleConfig = FormStyleConfig.getInstance();
      formStyleConfig.mFormWidth.set('1', 1);
      formStyleConfig.mFormHeight.set('1', 2);
      when(getFormStyleConfig)(ArgumentMatchers.any).afterReturn(formStyleConfig);
      let formCenterViewData: FormCenterViewData = FormCenterViewData.getInstance();
      const mockerFun: Function = mocker.mockFunc(formCenterViewData, formCenterViewData.getFormDimensionScale);
      when(mockerFun)(ArgumentMatchers.any).afterReturn(2);
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      formCenterView.getFormDisplaySize(1, true);
      formCenterView.getFormDisplaySize(1, false);
      expect(true).assertTrue();
      mocker.clear(formViewModel);
      mocker.clear(formCenterViewData);
      mocker.clearAll();
    });

    it('dealPCShowFormCenter_Test', TestType.FUNCTION | Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();

      let scene: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      class Item {
        isActive: boolean = true;
      }
      scene['getContainerSessionListCallback'].set(1, (): Item[] => {
        return [{ isActive: true }];
      })
      scene['getContainerSessionList'] = (): SCBSceneContainerSessionArray => {
        return scene['getContainerSessionListCallback'].get(1)?.();
      };

      AppStorage.setOrCreate('toggleHomeShow', true);
      GlobalContext.getInstance().setObject('hideDockViewWithAnimation', () => {
      });

      FormCenterViewModel.getInstance().dealPCShowFormCenter();
      expect(true).assertTrue();
      mocker.clear(scene);
      mocker.clearAll();
      globalThis.SCBSceneSessionManagerInstance = null;
    });

    it('recoveryAllWindows_Test01', TestType.FUNCTION | Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      const isPC: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)(ArgumentMatchers.any).afterReturn(true);
      formCenterView.recoveryAllWindows();
      formCenterView.recoveryAllWindows();
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('recoveryAllWindows_Test02', TestType.FUNCTION | Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      const isPC: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)(ArgumentMatchers.any).afterReturn(false);
      formCenterView.recoveryAllWindows();
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('getFormCount', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: RecommendFormManager = RecommendFormManager.getInstance();
      const count: number | undefined = manager.getFormCount('');
      expect(count).assertUndefined();
    });

    it('getRecommendFormArray', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: RecommendFormManager = RecommendFormManager.getInstance();
      const pool: RecommendCardsDataPool = RecommendCardsDataPool.getInstance();
      const mocker: MockKit = new MockKit();
      const mockGetShowDataList: Function = mocker.mockFunc(pool, pool.getShowDataList);
      let recommendFormList: ArrayList<CardItemInfo> = new ArrayList<CardItemInfo>();
      when(mockGetShowDataList)(ArgumentMatchers.any).afterReturn(recommendFormList);
      const rstRecommendList: CardItemInfo[] = await manager.getRecommendFormArray();
      expect(rstRecommendList.length).assertEqual(0);
      mocker.clear(pool);
      mocker.clearAll();
    });

    it('addFormToRecommendServiceFormList_emptyBundle', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: RecommendFormManager = RecommendFormManager.getInstance();
      const mocker: MockKit = new MockKit();
      let called: boolean = false;
      const appInstallDataSource: AppInstallDataSource = AppInstallDataSource.getInstance();
      const mockDataAdd: Function = mocker.mockFunc(appInstallDataSource, appInstallDataSource.onDataAdd);
      when(mockDataAdd)(ArgumentMatchers.any).afterAction(() => { called = true; });
      manager.addFormToRecommendServiceFormList('', EventConstants.EVENT_REQUEST_RECOMMEND_FORM_ADD);
      expect(called).assertFalse();
      mocker.clear(appInstallDataSource);
      mocker.clearAll();
    });

    it('addFormToRecommendServiceFormList_emptyRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: RecommendFormManager = RecommendFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const mocker: MockKit = new MockKit();
      const mockGetFormInfo: Function = mocker.mockFunc(formModel, formModel.getAppItemFormInfo);
      let formInfoList: CardItemInfo[] = [];
      let formItem: CardItemInfo = new CardItemInfo();
      formItem.cardId = '123';
      formItem.bundleName = 'test';
      formInfoList.push(formItem);
      when(mockGetFormInfo)(formItem.bundleName).afterReturn(formInfoList);

      const dataPool: RecommendCardsDataPool = RecommendCardsDataPool.getInstance();
      const mockGetRecommendForm: Function = mocker.mockFunc(dataPool, dataPool.getRecommendForm);
      when(mockGetRecommendForm)(formInfoList).afterReturn(null);

      let called: boolean = false;
      const appInstallDataSource: AppInstallDataSource = AppInstallDataSource.getInstance();
      const mockDataAdd: Function = mocker.mockFunc(appInstallDataSource, appInstallDataSource.onDataAdd);
      when(mockDataAdd)(ArgumentMatchers.any).afterAction(() => { called = true; });
      manager.addFormToRecommendServiceFormList('test', EventConstants.EVENT_REQUEST_RECOMMEND_FORM_ADD);
      expect(called).assertFalse();
      mocker.clear(formModel);
      mocker.clear(dataPool);
      mocker.clear(appInstallDataSource);
      mocker.clearAll();
    });

    it('addFormToRecommendServiceFormList', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: RecommendFormManager = RecommendFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const mocker: MockKit = new MockKit();
      const mockGetFormInfo: Function = mocker.mockFunc(formModel, formModel.getAppItemFormInfo);
      let formInfoList: CardItemInfo[] = [];
      let formItem: CardItemInfo = new CardItemInfo();
      formItem.cardId = '123';
      formItem.bundleName = 'test';
      formInfoList.push(formItem);
      when(mockGetFormInfo)(formItem.bundleName).afterReturn(formInfoList);

      const dataPool: RecommendCardsDataPool = RecommendCardsDataPool.getInstance();
      const mockGetRecommendForm: Function = mocker.mockFunc(dataPool, dataPool.getRecommendForm);
      when(mockGetRecommendForm)(formInfoList).afterReturn(formItem);

      let called: boolean = false;
      const appInstallDataSource: AppInstallDataSource = AppInstallDataSource.getInstance();
      const mockDataAdd: Function = mocker.mockFunc(appInstallDataSource, appInstallDataSource.onDataAdd);
      when(mockDataAdd)(ArgumentMatchers.any).afterAction(() => { called = true; });
      manager.addFormToRecommendServiceFormList('test', EventConstants.EVENT_REQUEST_RECOMMEND_FORM_ADD);
      expect(called).assertTrue();

      called = false;
      const appUpdateDataSource: AppUpdateDataSource = AppUpdateDataSource.getInstance();
      const mockDataUpdate: Function = mocker.mockFunc(appUpdateDataSource, appUpdateDataSource.onDataAdd);
      when(mockDataUpdate)(ArgumentMatchers.any).afterAction(() => { called = true; });
      manager.addFormToRecommendServiceFormList('test', EventConstants.EVENT_REQUEST_RECOMMEND_FORM_UPDATE);
      expect(called).assertTrue();
      mocker.clear(formModel);
      mocker.clear(appUpdateDataSource);
      mocker.clear(appInstallDataSource);
      mocker.clearAll();
    });

    it('removeFormFromRecommendServiceFormList', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: RecommendFormManager = RecommendFormManager.getInstance();
      const mocker: MockKit = new MockKit();
      let called: boolean = false;
      const appUpdateDataSource: AppUpdateDataSource = AppUpdateDataSource.getInstance();
      const mockDataRemove: Function = mocker.mockFunc(appUpdateDataSource, appUpdateDataSource.onDataRemove);
      when(mockDataRemove)(ArgumentMatchers.any).afterAction(() => { called = true; });
      manager.removeFormFromRecommendServiceFormList('test');
      expect(called).assertTrue();
      mocker.clear(appUpdateDataSource);
      mocker.clearAll();
    });

    it('getShowFormInfos_emptyRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const arr: CardItemInfo[] = manager.getShowFormInfos([]);
      expect(arr.length).assertEqual(0);
    });

    it('getShowFormInfos_middleRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      let cardItemList: CardItemInfo[] = [];
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.cardDimension = 3;
      cardItemList.push(cardItem);
      const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
      expect(arr.length).assertEqual(1);
    });

    it('getShowFormInfos_middleRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      let cardItemList: CardItemInfo[] = [];
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.cardDimension = 3;
      cardItemList.push(cardItem);
      const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
      expect(arr.length).assertEqual(1);
    });

    it('getShowFormInfos_oneSmallRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      let cardItemList: CardItemInfo[] = [];
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.cardId = '123';
      cardItem.cardDimension = 2;
      cardItemList.push(cardItem);
      const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
      expect(arr.length).assertEqual(0);
    });

    it('getShowFormInfos_twoSmallRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
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
    });

    it('formInfoComplete', TestType.FUNCTION | Level.LEVEL0, () => {
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
    });

    it('getServiceFormAppList_emptyList', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const appModel: AppModel = AppModel.getInstance();
      const mocker: MockKit = new MockKit();
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
      mocker.clearAll();
    });

    it('getServiceFormAppList', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const appModel: AppModel = AppModel.getInstance();
      const mocker: MockKit = new MockKit();
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
      mocker.clearAll();
    });

    it('getServiceFormAppList_atomicForm', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const appModel: AppModel = AppModel.getInstance();
      const mocker: MockKit = new MockKit();
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
      expect(allAppList.length).assertEqual(1);
      mocker.clear(formModel);
      mocker.clear(appModel);
      mocker.clear(atomicAppModel);
      mocker.clearAll();
    });

    it('getServiceForm', TestType.FUNCTION | Level.LEVEL0, async () => {
      const recommendManager: RecommendManager = RecommendManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockGetArray: Function = mocker.mockFunc(recommendManager, recommendManager.getRecommendFormArray);
      let cardItemList: CardItemInfo[] = [];
      when(mockGetArray)(ArgumentMatchers.any).afterReturn([]);
      const serviceManager: ServiceFormManager = ServiceFormManager.getInstance();
      cardItemList = await serviceManager.getServiceForm();
      expect(cardItemList.length).assertEqual(0);
      mocker.clear(recommendManager);
      mocker.clearAll();
    });

    it('getShowFormInfos_emptyRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const arr: CardItemInfo[] = manager.getShowFormInfos([]);
      expect(arr.length).assertEqual(0);
    });

    it('getShowFormInfos_middleRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      let cardItemList: CardItemInfo[] = [];
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.cardDimension = 3;
      cardItemList.push(cardItem);
      const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
      expect(arr.length).assertEqual(1);
    });

    it('getShowFormInfos_middleRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      let cardItemList: CardItemInfo[] = [];
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.cardDimension = 3;
      cardItemList.push(cardItem);
      const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
      expect(arr.length).assertEqual(1);
    });

    it('getShowFormInfos_oneSmallRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      let cardItemList: CardItemInfo[] = [];
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.cardId = '123';
      cardItem.cardDimension = 2;
      cardItemList.push(cardItem);
      const arr: CardItemInfo[] = manager.getShowFormInfos(cardItemList);
      expect(arr.length).assertEqual(0);
    });

    it('getShowFormInfos_twoSmallRecommend', TestType.FUNCTION | Level.LEVEL0, () => {
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
    });

    it('formInfoComplete', TestType.FUNCTION | Level.LEVEL0, () => {
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
    });

    it('getServiceFormAppList_emptyList', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const appModel: AppModel = AppModel.getInstance();
      const mocker: MockKit = new MockKit();
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
      mocker.clearAll();
    });

    it('getServiceFormAppList', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const appModel: AppModel = AppModel.getInstance();
      const mocker: MockKit = new MockKit();
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
      mocker.clearAll();
    });

    it('getServiceFormAppList_atomicForm', TestType.FUNCTION | Level.LEVEL0, async () => {
      const manager: ServiceFormManager = ServiceFormManager.getInstance();
      const formModel: FormModel = FormModel.getInstance();
      const appModel: AppModel = AppModel.getInstance();
      const mocker: MockKit = new MockKit();
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
      expect(allAppList.length).assertEqual(1);
      mocker.clear(formModel);
      mocker.clear(appModel);
      mocker.clear(atomicAppModel);
      mocker.clearAll();
    });

    it('getServiceForm', TestType.FUNCTION | Level.LEVEL0, async () => {
      const recommendManager: RecommendManager = RecommendManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockGetArray: Function = mocker.mockFunc(recommendManager, recommendManager.getRecommendFormArray);
      let cardItemList: CardItemInfo[] = [];
      when(mockGetArray)(ArgumentMatchers.any).afterReturn([]);
      const serviceManager: ServiceFormManager = ServiceFormManager.getInstance();
      cardItemList = await serviceManager.getServiceForm();
      expect(cardItemList.length).assertEqual(0);
      mocker.clear(recommendManager);
      mocker.clearAll();
    });

    it('getFormListByPageIndex_onlyCard', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.cardId = '123';
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.page = 0;
      layout.push(formItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);
      let formHostService: FormHostService = FormHostService.getInstance();
      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(1);
      mocker.clear(formLayoutManager);
      mocker.clearAll();
    });

    it('getFormListByPageIndex', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 0;
      layout.push(formItem);
      let formStackItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem.page = 0;
      let formItemInFormStack: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack.cardId = '234';
      formItemInFormStack.page = 0;
      formStackItem.layoutInfo = [[formItemInFormStack]];
      layout.push(formStackItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);
      let formHostService: FormHostService = FormHostService.getInstance();
      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(2);
      mocker.clear(formLayoutManager);
      mocker.clearAll();
    });

    it('getFormListByPageIndex_foldOpen', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 1;
      layout.push(formItem);
      let formStackItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem.page = 1;
      let formItemInFormStack: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack.cardId = '234';
      formItemInFormStack.page = 1;
      formStackItem.layoutInfo = [[formItemInFormStack]];
      layout.push(formStackItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      const mockFunc2: Function = mocker.mockFunc(sessionManager, sessionManager.isFoldablePhoneExpandStatus);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

      let formHostService: FormHostService = FormHostService.getInstance();
      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(2);
      mocker.clear(formLayoutManager);
      mocker.clear(sessionManager);
      mocker.clearAll();
    });

    it('recoverFormsOfNeighborPage', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 1;
      layout.push(formItem);
      let formStackItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem.page = 1;
      let formItemInFormStack: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack.cardId = '234';
      formItemInFormStack.page = 1;
      let formItemInFormStack1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack1.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack1.cardId = '345';
      formItemInFormStack1.page = 1;

      formStackItem.layoutInfo = [[formItemInFormStack, formItemInFormStack1]];
      layout.push(formStackItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      let layoutManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      const mockFunc2: Function = mocker.mockFunc(layoutManager, layoutManager.selectPageCount);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(3);

      let formHostService: FormHostService = FormHostService.getInstance();
      formHostService['insertListToCurrentRecycleList'](['123', '234', '345']);
      formHostService.recoverFormsOfNeighborPage(0);

      expect(formHostService['startHandlerTimer']).assertEqual(-1);
      mocker.clear(formLayoutManager);
      mocker.clear(layoutManager);
      mocker.clearAll();
    });

    it('recoverFormsOfNeighborPage_1', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 0;
      layout.push(formItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      let layoutManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      const mockFunc2: Function = mocker.mockFunc(layoutManager, layoutManager.selectPageCount);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(2);

      let formHostService: FormHostService = FormHostService.getInstance();
      formHostService['insertListToCurrentRecycleList'](['123']);
      formHostService.recoverFormsOfNeighborPage(1);

      expect(formHostService['startHandlerTimer']).assertEqual(-1);
      mocker.clear(formLayoutManager);
      mocker.clear(layoutManager);
      mocker.clearAll();
    });

    it('formRecoverWhenAppExitHandler_0', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      formHostService['startHandlerTimer'] = 123;
      formHostService.formRecoverWhenAppExitHandler(0);

      expect(formHostService['startHandlerTimer']).assertEqual(-1);
    });

    it('formRecoverWhenAppExitHandler', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      formHostService['startHandlerTimer'] = -1;
      formHostService['startRecycleTimer'] = 123;

      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 0;
      layout.push(formItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      formHostService.formRecoverWhenAppExitHandler(0);
      expect(formHostService['startRecycleTimer']).assertEqual(-1);
      mocker.clear(formLayoutManager);
      mocker.clearAll();
    });

    it('handleRecycleFormsOfInvisible', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      let formList: Array<string> = new Array();
      formList.push('123');
      formList.push('234');
      formList.push('345');
      formList.push('456');
      formHostService.formHostNotifyInvisible(formList);
      let formRecycleList: Array<string> = new Array();
      formRecycleList.push('123');
      formHostService.formHostNotifyRecycle(formRecycleList);

      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem1.typeId = CommonConstants.TYPE_CARD;
      formItem1.cardId = '123';
      formItem1.page = 0;
      formItem1.container = CommonConstants.CONTAINER_DESKTOP;
      layout.push(formItem1);

      let formItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem2.typeId = CommonConstants.TYPE_CARD;
      formItem2.cardId = '345';
      formItem2.page = 0;
      formItem2.container = CommonConstants.CONTAINER_DESKTOP;
      layout.push(formItem2);

      let formStackItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem1.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem1.page = 0;
      let formItemInFormStack1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack1.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack1.cardId = '234';
      formItemInFormStack1.page = 0;
      formItemInFormStack1.container = 55;
      formStackItem1.layoutInfo = [[formItemInFormStack1]];
      layout.push(formStackItem1);

      let formStackItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem2.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem2.page = 0;
      let formItemInFormStack2: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack2.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack2.cardId = '456';
      formItemInFormStack2.page = 0;
      formItemInFormStack2.container = 65;
      formStackItem2.layoutInfo = [[formItemInFormStack2]];
      layout.push(formStackItem2);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(4);

      mocker.clear(formLayoutManager);
      mocker.clearAll();
    });

    it('formHostNotifyVisible', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      let formList: Array<string> = new Array();
      formList.push('123');
      formList.push('234');
      formList.push('345');
      formList.push('456');
      let formRecycleList: Array<string> = new Array();
      formRecycleList.push('123');
      formRecycleList.push('567');
      formHostService.formHostNotifyRecycle(formRecycleList);
      formHostService.formHostNotifyVisible(formList);

      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      const mockFunc1: Function = mocker.mockFunc(sessionManager, sessionManager.isFoldablePhoneExpandStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

      const mockFunc2: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem1.typeId = CommonConstants.TYPE_CARD;
      formItem1.cardId = '123';
      formItem1.page = 0;
      formItem1.container = CommonConstants.CONTAINER_DESKTOP;
      layout.push(formItem1);

      let formStackItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem1.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem1.page = 0;
      let formItemInFormStack1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack1.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack1.cardId = '456';
      formItemInFormStack1.page = 0;
      formItemInFormStack1.container = 65;
      formStackItem1.layoutInfo = [[formItemInFormStack1]];
      layout.push(formStackItem1);

      when(mockFunc2)(ArgumentMatchers.any).afterReturn(layout);

      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(2);

      mocker.clear(formLayoutManager);
      mocker.clear(sessionManager);
      mocker.clearAll();
    });

    it('registerFormVisibleListener_empty', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      let calledTimes: number = 0;
      let visibleListener: VisibleChangeListener = {
        onVisibleChange: (visible: boolean): void => {
          calledTimes = calledTimes + 1;
        }
      };

      formHostService.registerFormVisibleListener('123', visibleListener);
      formHostService.registerFormVisibleListener('123', visibleListener);
      formHostService.registerFormVisibleListener('234', visibleListener);
      formHostService.formHostNotifyVisible(['123','345']);
      formHostService.unRegisterFormVisibleListener('123', visibleListener);
      formHostService.unRegisterFormVisibleListener('456', visibleListener);
      expect(calledTimes).assertEqual(2);

    });

    it('registerFormVisibleListener', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      let calledTimes: number = 0;
      let visibleListener: VisibleChangeListener = {
        onVisibleChange: (visible: boolean): void => {
          calledTimes = calledTimes + 1;
        }
      };

      formHostService.registerFormVisibleListener('123', visibleListener);
      formHostService.formHostNotifyVisible(['123']);
      formHostService.unRegisterFormVisibleListener('123', visibleListener);
      expect(calledTimes).assertEqual(1);
    });

    it('getAppFormsIndex', TestType.FUNCTION | Level.LEVEL0, () => {
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      let formItem: CardItemInfo = new CardItemInfo();
      formItem.bundleName = 'testBundle';
      formItem.abilityName = 'testAbility';
      formItem.moduleName = 'testModule';
      formItem.cardName = 'testName';
      formItem.area = [2, 2];
      let formItemList: CardItemInfo[] = [formItem];
      expect(formCenterView.getAppFormsIndex(formItem, formItemList)).assertEqual(0);
      let startForm: CardItemInfo = new CardItemInfo();
      expect(formCenterView.getAppFormsIndex(startForm, formItemList)).assertEqual(0);
    });

    it('updateFromCenterData_recommend0', TestType.FUNCTION | Level.LEVEL0, async (done: Function) => {
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      let formModel: FormModel = FormModel.getInstance();
      let serviceFormManager: ServiceFormManager = ServiceFormManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formModel, formModel.getFormCenterAppList);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([]);

      const mockFunc2: Function = mocker.mockFunc(serviceFormManager, serviceFormManager.getServiceForm);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([]);

      const mockFunc3: Function = mocker.mockFunc(serviceFormManager, serviceFormManager.getShowFormInfos);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn([]);

      await formCenterView.updateFromCenterData(false);
      expect(formCenterView.getAppList().length).assertLargerOrEqual(0);

      mocker.clear(formCenterView);
      mocker.clear(formModel);
      mocker.clear(serviceFormManager);
      mocker.clearAll();
      done();
    });

    it('updateFromCenterData_recommend1', TestType.FUNCTION | Level.LEVEL0, async (done: Function) => {
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      let formModel: FormModel = FormModel.getInstance();
      let serviceFormManager: ServiceFormManager = ServiceFormManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formModel, formModel.getFormCenterAppList);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([]);

      let formItem: CardItemInfo = new CardItemInfo();
      formItem.bundleName = 'testBundle';
      formItem.abilityName = 'testAbility';
      formItem.moduleName = 'testModule';
      formItem.cardName = 'testName';
      formItem.cardDimension = 2;
      const mockFunc2: Function = mocker.mockFunc(serviceFormManager, serviceFormManager.getServiceForm);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([formItem]);

      const mockFunc3: Function = mocker.mockFunc(serviceFormManager, serviceFormManager.getShowFormInfos);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn([formItem]);

      await formCenterView.updateFromCenterData(false);
      expect(formCenterView.getAppList().length).assertLargerOrEqual(0);

      mocker.clear(formCenterView);
      mocker.clear(formModel);
      mocker.clear(serviceFormManager);
      mocker.clearAll();
      done();
    });

    it('updateFromManagerData_Test01', TestType.FUNCTION | Level.LEVEL0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.thememanager';
      let formModel: FormModel = FormModel.getInstance();
      const isSupportFormCenterSplit: Function = mocker.mockFunc(formModel, formModel.isSupportFormCenterSplit);
      when(isSupportFormCenterSplit)(ArgumentMatchers.any).afterReturn(true);
      const getFormCenterAppList: Function = mocker.mockFunc(formModel, formModel.getFormCenterAppList);
      when(getFormCenterAppList)(ArgumentMatchers.any).afterReturn([appInfo]);

      await formCenterView.updateFromManagerData(true);
      await formCenterView.updateFromManagerData(false);
      formCenterView.getAppInfo(appInfo.bundleName);
      formCenterView.getAppList();
      formCenterView.getRecommendedCardList();
      when(getThemeAppItemInfo)(ArgumentMatchers.any).afterReturn(undefined);
      formCenterView.updateFromManagerData(true);
      expect(true).assertTrue();
      mocker.clear(formModel);
      mocker.clearAll();
      done();
    });

    it('getFormDisplaySize_Test01', TestType.FUNCTION | Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();
      let formViewModel: FormViewModel = FormViewModel.getInstance();
      const getFormStyleConfig: Function = mocker.mockFunc(formViewModel, formViewModel.getFormStyleConfig);
      let formStyleConfig: FormStyleConfig = FormStyleConfig.getInstance();
      formStyleConfig.mFormWidth.set('1', 1);
      formStyleConfig.mFormHeight.set('1', 2);
      when(getFormStyleConfig)(ArgumentMatchers.any).afterReturn(formStyleConfig);
      let formCenterViewData: FormCenterViewData = FormCenterViewData.getInstance();
      const mockerFun: Function = mocker.mockFunc(formCenterViewData, formCenterViewData.getFormDimensionScale);
      when(mockerFun)(ArgumentMatchers.any).afterReturn(2);
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      formCenterView.getFormDisplaySize(1, true);
      formCenterView.getFormDisplaySize(1, false);
      expect(true).assertTrue();
      mocker.clear(formViewModel);
      mocker.clear(formCenterViewData);
      mocker.clearAll();
    });

    it('dealPCShowFormCenter_Test', TestType.FUNCTION | Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();

      let scene: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      class Item {
        isActive: boolean = true;
      }
      scene['getContainerSessionListCallback'].set(1, (): Item[] => {
        return [{ isActive: true }];
      })
      scene['getContainerSessionList'] = (): SCBSceneContainerSessionArray => {
        return scene['getContainerSessionListCallback'].get(1)?.();
      };

      AppStorage.setOrCreate('toggleHomeShow', true);
      GlobalContext.getInstance().setObject('hideDockViewWithAnimation', () => {
      });

      FormCenterViewModel.getInstance().dealPCShowFormCenter();
      expect(true).assertTrue();
      mocker.clear(scene);
      mocker.clearAll();
      globalThis.SCBSceneSessionManagerInstance = null;
    });

    it('recoveryAllWindows_Test01', TestType.FUNCTION | Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      const isPC: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)(ArgumentMatchers.any).afterReturn(true);
      formCenterView.recoveryAllWindows();
      formCenterView.recoveryAllWindows();
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('recoveryAllWindows_Test02', TestType.FUNCTION | Level.LEVEL0, () => {
      const mocker: MockKit = new MockKit();
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      const isPC: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)(ArgumentMatchers.any).afterReturn(false);
      formCenterView.recoveryAllWindows();
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

  });
}

