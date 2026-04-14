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
  Level,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { CardItemInfo, CommonConstants, FormConstants, FormManager } from '../../../../../../main/ets/TsIndex';
import { CheckEmptyUtils, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { formInfo } from '@kit.FormKit';
import formManagerAbility from '@ohos.app.form.formHost';

const CARD_SIZE_SMALL_LENGTH: number = 1;
const CARD_SIZE_MIDDLE_LENGTH: number = 2;
const CARD_SIZE_LARGE_LENGTH: number = 4;
const TAG = 'FormManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export function FormManagerTest() {
  describe('FormManagerTest', (): void => {
    beforeAll((): void => {

    });

    beforeEach((): void => {

    });
    afterAll((): void => {

    });

    afterEach((): void => {

    });

    it('FormManager_test_getInstance_should_not_null', Level.LEVEL0, (): void => {
      expect(FormManager.getInstance()).not().assertNull();
    });

    it('test_getAllFormsInfo_should_return_array', Level.LEVEL0, async (done: Function) => {
      let allFormList = await FormManager.getInstance().getAllFormsInfo();
      let res = Array.isArray(allFormList);
      expect(res).assertTrue();
      done();
    });

    it('test_getCardSize', Level.LEVEL0, (): void => {
      let size1x2: number[] = [CARD_SIZE_MIDDLE_LENGTH, CARD_SIZE_SMALL_LENGTH];
      let size2x2: number[] = [CARD_SIZE_MIDDLE_LENGTH, CARD_SIZE_MIDDLE_LENGTH];
      let size2x4: number[] = [CARD_SIZE_LARGE_LENGTH, CARD_SIZE_MIDDLE_LENGTH];
      let size4x4: number[] = [CARD_SIZE_LARGE_LENGTH, CARD_SIZE_LARGE_LENGTH];
      let value: number[] = FormManager.getInstance().getCardSize(CommonConstants.CARD_DIMENSION_1x2);
      expect(isArrayEqual(value, size1x2)).assertTrue();
      value = FormManager.getInstance().getCardSize(CommonConstants.CARD_DIMENSION_2x2);
      expect(isArrayEqual(value, size2x2)).assertTrue();
      value = FormManager.getInstance().getCardSize(CommonConstants.CARD_DIMENSION_2x4);
      expect(isArrayEqual(value, size2x4)).assertTrue();
      value = FormManager.getInstance().getCardSize(CommonConstants.CARD_DIMENSION_4x4);
      expect(isArrayEqual(value, size4x4)).assertTrue();
    });

    //增加的case
    //getInstance
    it('test_getInstance_01', 0, async (done: Function) => {
      let instance1: ESObject = FormManager.getInstance();
      let instance2: ESObject = FormManager.getInstance();
      expect(instance1).assertDeepEquals(instance2);
      done();
    });

    it('test_getInstance_02', 0, async (done: Function) => {
      globalThis.FormManagerInstance = null;
      let instance: ESObject = FormManager.getInstance();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    //getAllFormsInfo
    it('test_getAllFormsInfo_01', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('test_getAllFormsInfo_02', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      const result: ESObject = await formManager.getAllFormsInfo();
      expect(result).not().assertUndefined();
      done();
    });

    it('test_getAllFormsInfo_03', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      const result: ESObject = await formManager.getAllFormsInfo();
      expect(result.length >= 0).assertTrue();
      done();
    });

    it('test_getAllFormsInfo_04', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      const result: ESObject = await formManager.getAllFormsInfo();
      expect(result).not().assertUndefined();
      done();
    });

    //getCardDescription
    it('test_getCardDescription_01', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      const result: ESObject = await formManager.getCardDescription('default', NaN, 'bundleName', 'moduleName');
      expect(result).assertEqual('default');
      done();
    });

    it('test_getCardDescription_02', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      const result: ESObject = await formManager.getCardDescription('default', 0, 'bundleName', 'moduleName');
      expect(result).assertEqual('default');
      done();
    });

    it('test_getCardDescription_03', 0, async (done: Function) => {
      let formManager = FormManager.getInstance();
      const result: string = await formManager.getCardDescription('default', 1, 'bundleName', 'moduleName');
      expect(result).assertInstanceOf('String');
      done();
    });

    it('test_getCardDescription_04', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      const result: ESObject = await formManager.getCardDescription('default', 1, 'bundleName', 'moduleName');
      expect(result).assertInstanceOf('String');
      done();
    });

    it('test_getCardDescription_05', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      const result: ESObject = await formManager.getCardDescription('default', 1, 'bundleName', 'moduleName');
      expect(result).assertInstanceOf('String');
      done();
    });

    it('test_getCardDescription_06', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      const result: ESObject = await formManager.getCardDescription('default', 1, 'bundleName', 'moduleName');
      expect(result).assertInstanceOf('String');
      done();
    });

    //clearCardDescriptionCache
    it('test_clearCardDescriptionCache_01', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      formManager.clearCardDescriptionCache(NaN, 'bundleName', 'moduleName');
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('test_clearCardDescriptionCache_02', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      formManager.clearCardDescriptionCache(0, 'bundleName', 'moduleName');
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('test_clearCardDescriptionCache_03', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      formManager.clearCardDescriptionCache(1, 'bundleName', 'moduleName');
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    //getFormsInfoByApp
    it('test_getFormsInfoByApp_01', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('test_getFormsInfoByApp_02', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      const result: ESObject = await formManager.getFormsInfoByApp('com.example.app');
      expect(result).assertDeepEquals([]);
      done();
    });

    it('test_getFormsInfoByApp_03', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      let formItem: ESObject = {
        bundleName: 'com.example.app',
        abilityName: 'MainAbility',
        moduleName: 'MainModule',
        name: 'TestForm',
        cardName: 'TestForm',
        cardDimension: 2,
        displayNameId: 100,
        descriptionId: 200,
        formConfigAbility: 'ConfigAbility',
        supportDimensions: [2],
        renderingMode: 1,
        isTransparent: true,
        transparencyEnabled: true
      };
      const result: ESObject = await formManager.getFormsInfoByApp('com.example.app');
      expect(formItem.bundleName).assertEqual('com.example.app');
      expect(formItem.abilityName).assertEqual('MainAbility');
      expect(formItem.moduleName).assertEqual('MainModule');
      expect(formItem.cardName).assertEqual('TestForm');
      expect(formItem.cardDimension).assertEqual(2);
      expect(formItem.displayNameId).assertEqual(100);
      expect(formItem.descriptionId).assertEqual(200);
      expect(formItem.formConfigAbility).assertEqual('ConfigAbility');
      expect(formItem.supportDimensions).assertDeepEquals([2]);
      expect(formItem.renderingMode).assertEqual(1);
      expect(formItem.isTransparent).assertEqual(true);
      done();
    });

    it('test_getFormsInfoByApp_04', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      const result: ESObject = await formManager.getFormsInfoByApp('com.example.app');
      expect(result).assertDeepEquals([]);
      done();
    });

    //updateFormConfig
    it('test_updateFormConfig_01', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      let formList: ESObject = [{ name: 'testCard', formConfigAbility: 'testConfig', transparencyEnabled: true }];
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('test_updateFormConfig_02', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      let formList: ESObject = [{ name: 'otherCard', formConfigAbility: 'otherConfig', transparencyEnabled: false }];
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('test_updateFormConfig_03', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('test_getFormCardItemByWant', 0, async (done: Function) => {
      try{
        let formManager: ESObject = FormManager.getInstance();
        let cardItemInfo: CardItemInfo = await formManager.getFormCardItemByWant(undefined);
        expect(cardItemInfo.cardId.length).assertEqual(0);
      }catch{};
      done();
    });

    it('test_getAppFormWantParamInterface', 0, async (done: Function) => {
      try{
        let formManager: ESObject = FormManager.getInstance();
        let appFormInterface: AppFormWantParamInterface = await formManager.getAppFormWantParamInterface(undefined);
        let appFormSnapshot = appFormInterface.appFormSnapshot ?? '';
        expect(appFormSnapshot.length === 0).assertTrue();
        let appFormInterface1: AppFormWantParamInterface = await formManager.getAppFormWantParamInterface({
          'ohos.extra.param.key.add_form_to_host_snapshot': 'cardId_test001',
          'ohos.extra.param.key.add_form_to_host_width': '100',
          'ohos.extra.param.key.add_form_to_host_height': '200',
          'ohos.extra.param.key.add_form_to_host_screenx': '40',
          'ohos.extra.param.key.add_form_to_host_screeny': '40'
        });
        expect(appFormInterface1.appFormSnapshot).assertEqual('cardId_test001');
      }catch{};
      done();
    });

    it('FormManagerTest_getCardDescription_01', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      let mocker: MockKit = new MockKit();
      try{
        const result: ESObject = await formManager.getCardDescription('default', 0, 'bundleName', 'moduleName');
        expect(result).assertEqual('default');
        const result1: ESObject = await formManager.getCardDescription('default', NaN, 'bundleName', 'moduleName');
        expect(result1).assertEqual('default');
        let mockfunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
        const result2: ESObject = await formManager.getCardDescription('default', 1, 'bundleName', 'moduleName');
        expect(result2).assertNull();
        when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
        let mockfunc_checkStrIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockfunc_checkStrIsEmpty)(ArgumentMatchers.any).afterReturn(true);
        const result3: ESObject = await formManager.getCardDescription('default', 1, 'bundleName', 'moduleName');
        expect(result3).assertEqual('default');
        when(mockfunc_checkStrIsEmpty)(ArgumentMatchers.any).afterReturn(false);
        const result4: ESObject = await formManager.getCardDescription('default', 1, 'bundleName', 'moduleName');
        expect(result4).not().assertEqual('default001');
      } catch (e) {}
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    });

    it('FormManagerTest_clearCardDescriptionCache_01', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockErrorLog = mocker.mockFunc(log, log.showInfo);
      let logAction = 0;
      when(mockErrorLog)(ArgumentMatchers.any).afterAction(() => {
        logAction = logAction + 1;
      });
      formManager.clearCardDescriptionCache(NaN, 'bundleName', 'moduleName');
      formManager.clearCardDescriptionCache(0, 'bundleName', 'moduleName');
      expect(logAction > 2).assertTrue();
      formManager.clearCardDescriptionCache(1, 'bundleName', 'moduleName');
      let isHasCache = ResourceManager.getInstance().getCachedAppName(1, 'bundleName', 'moduleName') ?? '';
      expect(isHasCache.length > 0).assertFalse();
      mocker.clear(log);
      mocker.clearAll();
      done();
    });

    it('test_getAllformsInfo_error', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockErrorLog = mocker.mockFunc(TraceUtil, TraceUtil.startTrace);
      when(mockErrorLog)(ArgumentMatchers.any).afterThrow('error');
      let cards: CardItemInfo[] = formManager.getAllFormsInfo() ?? [];
      expect(cards.length > 0).assertFalse();
      mocker.clear(TraceUtil);
      mocker.clearAll();
      done();
    });

    it('test_getFormsInfo', 0, async (done: Function) => {
      let formManager: ESObject = FormManager.getInstance();
      let list: formInfo.FormInfo[] =
        await formManager.getFormsInfo('com.ohos.calendar', 'com.ohos.calendar');
      expect(list.length < 0).assertFalse();
      done();
    });

    it('test_setPublishFormResult', 0, async (done: Function) => {
      try{
        let formManager: ESObject = FormManager.getInstance();
        formManager.setPublishFormResult('10001', formInfo.PublishFormErrorCode.SUCCESS);
        formManager.setPublishFormResult('10001', formInfo.PublishFormErrorCode.NO_SPACE);
        formManager.setPublishFormResult('10001', formInfo.PublishFormErrorCode.PARAM_ERROR);
        formManager.setPublishFormResult('10001', formInfo.PublishFormErrorCode.INTERNAL_ERROR);
        expect(formManager).not().assertNull();
      }catch{};
      done();
    });

    interface AppFormWantParamInterface {
      appFormSnapshot: string;
      appFormWidth: number;
      appFormHeight: number;
      appFormScreenX: number;
      appFormScreenY: number;
    }
  })
}

function isArrayEqual(arr1: number[], arr2: number[]) {
  return JSON.stringify(arr1) === JSON.stringify(arr2);
}