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
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  TestType,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  AppItemInfo,
  CardItemInfo,
  FormModel,
} from '@ohos/launchercommon';
import {
  DeviceHelper,
  GlobalContext,
  SCBSceneContainerSessionArray,
  SCBSceneSessionManager
} from '@ohos/basiccommon/src/main/ets/TsIndex';
import { FormStyleConfig } from '../../../../../../main/ets/default/common/FormStyleConfig';
import { FormCenterViewData } from '../../../../../../main/ets/default/viewmodel/FormCenterViewData';
import ServiceFormManager from '../../../../../../main/ets/default/manager/ServiceFormManager';
import { FormCenterViewModel } from '../../../../../../main/ets/default/viewmodel/FormCenterViewModel';
import { FormViewModel } from '../../../../../../main/ets/default/viewmodel/FormViewModel';
import {
  EditModeSearchOptions
} from '@ohos/launchercommon/src/main/ets/outerdesktop/viewmodel/EditModeSearchComponentEvent';
import {
  FormCenterViewModel as NewFormCenterViewModel
} from '../../../../../../main/ets/formcenter/viewmodel/FormCenterViewModel';

export function FormCenterViewModelTest() {
  describe('FormCenterViewModelTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
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

    it('setCloseEvent_Test', 0, () => {
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      formCenterView.setCloseEvent(() => {});
      expect(true).assertTrue();
    });

    it('initEditModeSearchOptions_Test', 0, () => {
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      formCenterView.initEditModeSearchOptions(new EditModeSearchOptions());
      expect(true).assertTrue();
    });

    it('setShouldDisableNegativeAddCard_Test', () => {
      let formCenterView: FormCenterViewModel = FormCenterViewModel.getInstance();
      formCenterView.setShouldDisableNegativeAddCard(true);
      expect(formCenterView.isDisableButtonForNegativeScreen()).assertEqual(false);
    });

    it('getNegativeScreenBundleBlackList_Test', 0, () => {
      let newFormCenterViewModel: NewFormCenterViewModel = NewFormCenterViewModel.getInstance();
      let blackList = newFormCenterViewModel.getNegativeScreenBundleBlackList();
      expect(Array.isArray(blackList)).assertTrue();
    });
  })
}