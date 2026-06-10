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
import ArrayList from '@ohos.util.ArrayList';
import { CardItemInfo, EventConstants, FormModel } from '@ohos/launchercommon';
import RecommendFormManager from '../../../../../../main/ets/default/manager/RecommendFormManager';
import AppInstallDataSource from '../../../../../../main/ets/default/datasource/AppInstallDataSource';
import RecommendCardsDataPool from '../../../../../../main/ets/default/datapool/RecommendCardsDataPool';
import AppUpdateDataSource from '../../../../../../main/ets/default/datasource/AppUpdateDataSource';

export function RecommendFormManagerTest() {
  describe('RecommendFormManagerTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
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
  })
}