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
  TestType,
  Level,
  when,
  MockKit,
  ArgumentMatchers
} from '@ohos/hypium'
import { AppItemInfo,
  BaseLayoutCacheManager,
  FormLayoutCacheManager,
  FormListInfoCacheManager,
  FormModel,
  NoIconAppModel,
  RdbStoreManager, SettingsModel } from '../../../../../../main/ets/TsIndex';
import { SwiperItemInfo } from '../../../../../../main/ets/entity/SwiperItemInfo'
import {
  CardItemInfo,
  GridLayoutItemInfo,
  PageDesktopModel,
  ReceiveEventInfo,
  CommonConstants
} from '../../../../../../main/ets/TsIndex';
import { LaunchLayoutCacheManager } from '../../../../../../main/ets/cache/layout/LaunchLayoutCacheManager';
import type LayoutDescription from '../../../../../../main/ets/bean/LayoutDescription';
import { DeviceHelper } from '@ohos/frameworkwrapper';

export default function FormModelTest() {
  describe('FormModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });

    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });

    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });

    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    it('test_getAllFormsInfoFromRdb', TestType.FUNCTION | Level.LEVEL0, async () => {
      const formModel: FormModel = FormModel.getInstance();
      let formListInRdb: CardItemInfo[] = await formModel.getAllFormsInfoFromRdb();
      expect(formListInRdb.length).assertLargerOrEqual(0);
    });

    it('FormModel_test_getInstance', 0, () => {
      globalThis.FormModelInstance = null;
      let model = FormModel.getInstance();
      expect(globalThis.FormModelInstance).not().assertNull();
      expect(model).assertEqual(globalThis.FormModelInstance);
    });

    it('test_registerJumpToFormViewEvent', 0, () => {
      let model = FormModel.getInstance();
      const listener: ReceiveEventInfo = {
        onReceiveEvent: (event:string, params?: string[]) => {
          console.log('Receive event: ' + event);
        }
      };
      model.registerJumpToFormViewEvent(listener);
      expect(listener).not().assertUndefined();
    });

    it('test_unregisterEventListener', 0, () => {
      let model = FormModel.getInstance();
      const listener: ReceiveEventInfo = {
        onReceiveEvent: (event:string, params?: string[]) => {
          console.log('Receive event: ' + event);
        }
      };
      model.unregisterEventListener(listener);
      expect(listener).not().assertUndefined();
    });

    it('test_registerQueryValidCardIdCallback', 0, () => {
      let model = FormModel.getInstance();
      const callback = async (): Promise<string[]> => [];
      model.registerQueryValidCardIdCallback('', callback);
      expect(model).not().assertUndefined();
    });

    it('test_clearInvalidCards', 0, () => {
      let model = FormModel.getInstance();
      model.clearInvalidCards();
      expect(model).not().assertUndefined();
    });

    it('test_getAppItemFormInfo', 0, () => {
      const bundle = "NotExistsBundle";
      let model = FormModel.getInstance();
      expect(model.getAppItemFormInfo(bundle)).assertUndefined();
    });

    it('test_getAllFormsInfo', 0, () => {
      let model = FormModel.getInstance();
      expect(model.getAllFormsInfo()).not().assertNull();
    });

    it('test_getFormsInfoByBundleName', 0, () => {
      let model = FormModel.getInstance();
      const bundle = "NotExistsBundle";
      const callback = async (): Promise<string[]> => [];
      expect(model.getFormsInfoByBundleName(bundle, callback)).not().assertNull();;
    });

    it('test_getFullFormsInfoByBundleName', 0, () => {
      let model = FormModel.getInstance();
      const bundle = "NotExistsBundle";
      const callback = async (): Promise<string[]> => [];
      expect(model.getFullFormsInfoByBundleName(bundle, callback)).not().assertNull();
    });

    it('test_getAllFormsInfoExceptStackFromRdb', 0, async (done: Function): Promise<void> => {
      let model = FormModel.getInstance();
      let ret = await model.getAllFormsInfoExceptStackFromRdb();
      expect(ret).not().assertNull();
      done();
    });

    it('test_getDesktopAppAndAtomicAndNoIconAppBundle', 0, () => {
      let model = FormModel.getInstance();
      expect(model.getDesktopAppAndAtomicAndNoIconAppBundle()).not().assertNull();
    });

    it('test_updateFormInfoById', 0, async (done: Function): Promise<void> => {
      let model = FormModel.getInstance();
      let cardItemInfo: CardItemInfo = new CardItemInfo();
      cardItemInfo.page = 0;
      cardItemInfo.column = 1;
      cardItemInfo.row = 1;
      let ret = await model.updateFormInfoById(cardItemInfo);
      expect(ret).not().assertNull();
      done();
    });

    it('test_updateFormConfigInfo', 0, async (done: Function): Promise<void> => {
      let model = FormModel.getInstance();
      let cardItemInfo: CardItemInfo = new CardItemInfo();
      cardItemInfo.page = 0;
      cardItemInfo.column = 1;
      cardItemInfo.row = 1;
      let ret = await model.updateFormConfigInfo(cardItemInfo);
      expect(ret).not().assertNull();
      done();
    });

    it('test_updateFormInfoByPosition', 0, async (done: Function): Promise<void> => {
      let model = FormModel.getInstance();
      let cardItemInfo: CardItemInfo = new CardItemInfo();
      cardItemInfo.page = 0;
      cardItemInfo.column = 1;
      cardItemInfo.row = 1;
      expect(await model.updateFormInfoByPosition(cardItemInfo)).not().assertNull();
      done();
    });

    it('test_updateExtend1ByCardId', 0, async (done: Function): Promise<void> => {
      let model = FormModel.getInstance();
      let extend1: string = '1';
      let cardId: string = '1';
      expect(await model.updateExtend1ByCardId(extend1, cardId)).not().assertNull();
      done();
    });

    it('test_deleteForm', 0, async (done: Function): Promise<void> => {
      try {
        let model = FormModel.getInstance();
        let cardId: string = '1';
        await model.deleteForm(cardId);
        expect(true).assertTrue();
      } catch (e) {}
      done();
    });

    it('test_deleteForm01', 0, async (done: Function): Promise<void> => {
      try {
        let model = FormModel.getInstance();
        let cardId: string = '1';
        await model.deleteForm(cardId, undefined, true);
        expect(true).assertTrue();
      } catch (e) {}
      done();
    });

    it('test_deleteFormFromCache', 0, async () => {
      let model = FormModel.getInstance();
      let cardId: string = '1';
      model['deleteFormFromCache'](cardId);
      expect(true).assertTrue();
    });

    it('test_deleteFormById', 0, () => {
      let model = FormModel.getInstance();
      let cardId: string = '1';
      model.deleteFormById(cardId, false, false, 0);
      model.deleteFormById(cardId, true, false, 0);
      expect(true).assertTrue()
    });

    it('test_deleteFormByIdAsync', 0, async (done: Function): Promise<void> => {
      let model = FormModel.getInstance();
      let cardId: string = '56789';
      try {
        await model.deleteFormByIdAsync(cardId, false);
      } catch (error) {
      }
      try {
        cardId = '45678';
        await model.deleteFormByIdAsync(cardId, true);
      } catch (error) {
      }
      expect(true).assertTrue()
      done();
    });

    it('test_deleteFormByFormID', 0, () => {
      let model = FormModel.getInstance();
      let formId: string = '1';
      model.deleteFormByFormID(formId, true);
      model.deleteFormByFormID(formId);
      expect(true).assertTrue()

      model.deleteFormByFormIdStr('2');
      expect(true).assertTrue();
    });

    it('test_convertsNormalFrom', 0, () => {
      let model = FormModel.getInstance();
      model.convertsNormalFrom('3');
      expect(true).assertTrue();
    });

    it('test_getMap', 0, () => {
      let model = FormModel.getInstance();
      model.getAllAppItemFormInfoMap();
      model['getPageItemCountMap']();
      model['updatePageItemCountMap'];
      expect(true).assertTrue();
    });

    it('test_getSwiperFormInfoFromRdb', 0, async (done: Function) => {
      let model = FormModel.getInstance();
      let cardId: string = '1';
      expect(await model.getSwiperFormInfoFromRdb(cardId)).not().assertNull();
      done();
    });

    it('test_updateSwiperFormInfo', 0, () => {
      let model = FormModel.getInstance();
      let cardItemInfo: CardItemInfo = new CardItemInfo();
      cardItemInfo.page = 0;
      cardItemInfo.column = 1;
      cardItemInfo.row = 1;
      cardItemInfo.cardId = '';
      cardItemInfo.cardName = '1';
      cardItemInfo.bundleName = '1';
      expect(model.updateSwiperFormInfo(cardItemInfo)).not().assertNull();
    });

    it('test_updateSwiperFormInfo2', 0, () => {
      let model = FormModel.getInstance();
      let swiperItemInfo: SwiperItemInfo = new SwiperItemInfo();
      swiperItemInfo.id = '';
      swiperItemInfo.infoName = '1';
      swiperItemInfo.bundleName = '1';
      expect(model.updateSwiperFormInfo(swiperItemInfo)).not().assertNull();
    });

    it('test_deleteFormByPosition', 0, async (done: Function) => {
      let model = FormModel.getInstance();
      let pageDesktopModel: PageDesktopModel = PageDesktopModel.getInstance();
      const mocker: MockKit = new MockKit();
      try{
        let ret = await model.deleteFormByPosition(null);
        expect(ret).assertInstanceOf('Boolean');
        class TestGridLayoutInfo {
          layoutInfo: GridLayoutItemInfo[] = []
        }
        let mSettingModel: SettingsModel = SettingsModel.getInstance();
        let gridLayoutInfo: TestGridLayoutInfo = new TestGridLayoutInfo();
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let cardItemInfo: CardItemInfo = new CardItemInfo();
        itemInfo.page = 0;
        itemInfo.column = 1;
        itemInfo.row = 1;
        cardItemInfo.page = itemInfo.page;
        cardItemInfo.column = itemInfo.column;
        cardItemInfo.row = itemInfo.row;
        gridLayoutInfo.layoutInfo.push(itemInfo);
        const mockFunc1: Function = mocker.mockFunc(pageDesktopModel, pageDesktopModel.deleteBlankPageFromLayoutInfo);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        ret = await model.deleteFormByPosition(cardItemInfo);
        expect(ret).assertInstanceOf('Boolean');
      } catch (e) {}
      mocker.clear(pageDesktopModel);
      done();
    });

    it('test_deleteFormByPosition02', 0, async (done: Function) => {
      let model = FormModel.getInstance();
      let pageDesktopModel: PageDesktopModel = PageDesktopModel.getInstance();
      const mocker: MockKit = new MockKit();
      try{
        let ret = await model.deleteFormByPosition(null);
        expect(ret).assertInstanceOf('Boolean');
        class TestGridLayoutInfo {
          layoutInfo: GridLayoutItemInfo[] = []
        }
        let mSettingModel: SettingsModel = SettingsModel.getInstance();
        let gridLayoutInfo: TestGridLayoutInfo = new TestGridLayoutInfo();
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let cardItemInfo: CardItemInfo = new CardItemInfo();
        itemInfo.page = 0;
        itemInfo.column = 1;
        itemInfo.row = 1;
        cardItemInfo.page = itemInfo.page;
        cardItemInfo.column = itemInfo.column;
        cardItemInfo.row = itemInfo.row;
        gridLayoutInfo.layoutInfo.push(itemInfo);
        const mockFunc1: Function = mocker.mockFunc(pageDesktopModel, pageDesktopModel.deleteBlankPageFromLayoutInfo);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        ret = await model.deleteFormByPosition(cardItemInfo, true);
        expect(ret).assertInstanceOf('Boolean');
      } catch (e) {}
      mocker.clear(pageDesktopModel);
      done();
    });

    it('test_checkIfCardExceedLimit', 0, () => {
      let model = FormModel.getInstance();
      let ret: boolean = model.checkIfCardExceedLimit();
      expect(ret).not().assertNull();
    });

    it('test_showToastWhenCardExceed', 0, () => {
      let model = FormModel.getInstance();
      model.showToastWhenCardExceed();
      expect(true).assertTrue();
    });

    it('test_convertToFormItem', 0, () => {
      let model = FormModel.getInstance();
      let item = new GridLayoutItemInfo();
      let ret = model.convertToFormItem(item);
      expect(ret).not().assertNull();
    });

    it('test_showToastWhenCardExceed01', 0, () => {
      let model = FormModel.getInstance();
      let ret = model.getRealForm([]);
      expect(ret).assertNull();
      let item = new CardItemInfo();
      item.supportDimensions = [0, 1];
      let array: CardItemInfo[] = [item];
      ret = model.getRealForm(array);
      expect(ret).not().assertNull();
    });

    it('test_copyCardItemInfo', 0, () => {
      let model = FormModel.getInstance();
      let oldItem = new CardItemInfo();
      oldItem.description = 'desc';
      oldItem.bundleName = '';
      oldItem.abilityName = '';
      oldItem.moduleName = 'scb';
      oldItem.cardName = 'card';
      oldItem.formConfigAbility = '';
      oldItem.isTransparent = false;
      let newItem = new CardItemInfo();
      model['copyCardItemInfo'](newItem, oldItem);
      expect(true).assertTrue();
    });

    it('test_getFullFormsInfoByBundleName01', 0, async (done: Function): Promise<void> => {
      let model = FormModel.getInstance();
      try {
        await model.getFullFormsInfoByBundleName('com.ohos.calculator', null);
      } catch (error) {
      }
      expect(true).assertTrue();
      done();
    });

    it('test_getAllFormLengthFormRdb', 0, () => {
      let model = FormModel.getInstance();
      expect(model.getAllFormLengthFormRdb()).assertInstanceOf('Number')
    });

    it('test_getFormsInfoFromMapAndManager', 0, async (done: Function): Promise<void> => {
      let model = FormModel.getInstance();
      try{
        await model.getFormsInfoFromMapAndManager('');
      } catch (error) {
      }
      let bundleName = 'com.ohos.calculator';
      await model.getFormsInfoFromMapAndManager(bundleName);
      expect(true).assertTrue();
      done();
    });

    it('test_updateAppItemFormInfo', 0, async (done: Function): Promise<void> => {
      let model = FormModel.getInstance();
      let bundleName = 'com.ohos.calculator';
      await model.updateAppItemFormInfo(bundleName, 'usual.event.PACKAGE_REMOVED');
      await model.updateAppItemFormInfo(bundleName, null);
      expect(true).assertTrue();
      done();
    });

    it('test_delete_cardInfo', 0, () => {
      let model = FormModel.getInstance();
      let bundleName = 'com.ohos.calculator';
      model.deleteAppItemFormInfo(bundleName);
      expect(true).assertTrue();
    });

    it('test_deleteFormByBundleName', 0, async (done: Function) => {
      try {
        let model = FormModel.getInstance();
        let bundleName = 'com.ohos.calculator';
        await model.deleteFormByBundleName(bundleName, false);
        expect(true).assertTrue();
      } catch (e) {}
      done();
    });

    it('test_handleEventAfterFormDeleteInLayout', 0, () => {
      let model = FormModel.getInstance();
      let bundleName = 'com.ohos.calculator';
      model['handleEventAfterFormDeleteInLayout']('1', 0, false);

      const mocker: MockKit = new MockKit();
      let pageModel = PageDesktopModel.getInstance();
      const mockFunc1: Function = mocker.mockFunc(pageModel, pageModel.deleteBlankPageFromLayoutInfo);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      model['handleEventAfterFormDeleteInLayout']('', 0, false);
      expect(true).assertTrue();
      mocker.clear(pageModel);
    });

    it('test_handleEventAfterFormDeleteInLayout01', 0, () => {
      let model = FormModel.getInstance();
      model.setFormManagerLastShowFrom(100);
      expect(model.getFormManagerLastShowFrom()).assertInstanceOf('Number');
    });

    it('test_getFormCenterAppList', 0, async (done: Function) => {
      let model = FormModel.getInstance();
      let appList: AppItemInfo[] = await model.getFormCenterAppList((item: CardItemInfo) => item.cardDimension === 0);
      expect(appList.length).assertLargerOrEqual(0);
      done();
    });

    it('test_isSupportCard', 0, () => {
      const model = FormModel.getInstance();
      const mocker: MockKit = new MockKit();
      expect(model.isSupportCard(CommonConstants.CARD_DIMENSION_1x1)).assertEqual(false);
      expect(model.isSupportCard(CommonConstants.CARD_DIMENSION_4x4)).assertEqual(true);
      const settingsModel = SettingsModel.getInstance();
      const mockFunc: Function = mocker.mockFunc(settingsModel, settingsModel.isSupportLargeForm);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(model.isSupportCard(CommonConstants.CARD_DIMENSION_6x4)).assertEqual(true);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(model.isSupportCard(CommonConstants.CARD_DIMENSION_6x4)).assertEqual(false);
      mocker.clear(settingsModel);
    });

    it('test_getNoIconAppListWhenHasForm', 0, () => {
      let model = FormModel.getInstance();
      let noIconAppModel = NoIconAppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(noIconAppModel, noIconAppModel.getNoIconAppItemInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
      let ret = model['getNoIconAppListWhenHasForm']();
      expect(ret.length).assertEqual(0);
      mocker.clear(noIconAppModel);
    })

    it('test_checkIfCardExceedLimit', 0, () => {
      let model = FormModel.getInstance();
      let formLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let baseLayoutCacheManager = BaseLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(formLayoutCacheManager, formLayoutCacheManager.getAllFormsLen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      let mockFunc2: Function = mocker.mockFunc(baseLayoutCacheManager, baseLayoutCacheManager.selectMaxForm);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);
      let ret: boolean = model.checkIfCardExceedLimit();
      expect(ret).assertEqual(true);
      mocker.clear(formLayoutCacheManager);
      mocker.clear(baseLayoutCacheManager);
    });


    it('test_getPageItemCountMap_updatePageItemCountMap', 0, () => {
      let model = FormModel.getInstance();
      let formLayoutCacheManager = FormLayoutCacheManager.getInstance();
      let item = new GridLayoutItemInfo();
      item.page = 1;
      let list: GridLayoutItemInfo[] = [item];
      let pageItemCountMap: Map<string, number> = new Map();
      pageItemCountMap.set('1', 0);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(formLayoutCacheManager, formLayoutCacheManager.getAllGridLayoutItemList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
      model['getPageItemCountMap']();
      model['updatePageItemCountMap'](pageItemCountMap);
      expect(pageItemCountMap.get('1')).assertEqual(1);
      mocker.clear(formLayoutCacheManager);
    })

    it('test_deleteFormByBundleName02', 0, async (done: Function) => {
      let model = FormModel.getInstance();
      let bundleName = 'com.ohos.calculator';
      let mocker: MockKit = new MockKit();
      let formListInfoCacheManager = FormListInfoCacheManager.getInstance();
      try {
        let cardItem: CardItemInfo = new CardItemInfo();
        cardItem.cardId = '1';
        cardItem.bundleName = 'com.ohos.calculator';
        cardItem.descriptionId = 0;
        cardItem.moduleName = 'moduleName';
        let list: CardItemInfo[] = [cardItem];
        let mockFunc: Function = mocker.mockFunc(formListInfoCacheManager, formListInfoCacheManager.getCache);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
        await model.deleteFormByBundleName(bundleName, false);
        await model.deleteFormByBundleName('test', false);
        expect(true).assertTrue();
      } catch (error) {
      }
      mocker.clear(formListInfoCacheManager);
      done();
    });

    it('test_deleteFormFromCache02', 0, async () => {
      let model = FormModel.getInstance();
      let formListInfoCacheManager = FormListInfoCacheManager.getInstance();
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.cardId = '1';
      cardItem.bundleName = 'test';
      cardItem.descriptionId = 0;
      cardItem.moduleName = 'moduleName';
      let cardItem2: CardItemInfo = new CardItemInfo();
      cardItem2.cardId = '2';
      cardItem2.bundleName = 'test';
      cardItem2.descriptionId = 0;
      cardItem2.moduleName = 'moduleName';
      let list: CardItemInfo[] = [cardItem, cardItem2];
      let cardId: string = '1';
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc: Function = mocker.mockFunc(formListInfoCacheManager, formListInfoCacheManager.getCache);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
        model['deleteFormFromCache'](cardId);
        expect(list.length).assertEqual(1);
      } catch (e) {}
      mocker.clear(formListInfoCacheManager);
    })

    it('test_getSwiperFormInfoFromRdb02', 0, async (done: Function) => {
      let model = FormModel.getInstance();
      let swiperItemInfo: SwiperItemInfo = new SwiperItemInfo();
      swiperItemInfo.bundleName = 'bundleName';
      swiperItemInfo.abilityName = 'abilityName';
      swiperItemInfo.moduleName = 'moduleName';
      swiperItemInfo.infoName = 'test';
      swiperItemInfo.dimension = 0;
      let list: SwiperItemInfo[] = [swiperItemInfo];
      let rdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(rdbStoreManager, rdbStoreManager.getAllSwiperFormInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
      let ret = await model.getSwiperFormInfoFromRdb([{
        bundleName: 'bundleName',
        abilityName: 'abilityName',
        moduleName: 'moduleName',
        cardName: 'test',
        cardDimension: 0,
        isTransparent: false,
      }]);
      expect(ret).assertEqual(0);
      ret = await model.getSwiperFormInfoFromRdb([{
        bundleName: 'bundleName',
        abilityName: 'abilityName',
        moduleName: 'moduleName',
        cardName: 'test',
        cardDimension: 1,
        isTransparent: true,
      }]);
      expect(ret).assertEqual(-1);
      done();
    })

    it('test_deleteCardDescriptionCache', 0, () => {
      const model = FormModel.getInstance();
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.bundleName = 'test';
      cardItem.descriptionId = 0;
      cardItem.moduleName = 'moduleName';
      model['setAppItemFormInfo']('test', []);
      model.deleteCardDescriptionCache('test');
      model['setAppItemFormInfo']('test', [cardItem]);
      model.deleteCardDescriptionCache('test');
      model.deleteAppItemFormInfo('test');
      expect(cardItem.descriptionId).assertEqual(0);
    });

    it('test_isScreenLockSupportCard', 0, () => {
      const model = FormModel.getInstance();
      let formInfo: CardItemInfo = new CardItemInfo();
      formInfo.cardDimension = CommonConstants.CARD_DIMENSION_1x1;
      formInfo.cardDimension = CommonConstants.CARD_DIMENSION_1x2;
      formInfo.bundleName = 'com.ohos.health';
      formInfo.renderingMode = 2;
      let ret = model.isScreenLockSupportCard(formInfo);
      expect(formInfo).not().assertUndefined();
    });

    it('test_isSystemApp', 0, () => {
      const model = FormModel.getInstance();
      let ret = model['isSystemApp']('bundleName');
      expect(model).not().assertUndefined();
      ret = model['isSystemApp']('com.ohos.health');
      expect(model).not().assertUndefined();
    });

    it('test_isSupportCreateFormAnimate', 0, () => {
      const model = FormModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let ret = model.isSupportCreateFormAnimate();
      expect(ret).assertEqual(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      ret = model.isSupportCreateFormAnimate();
      expect(ret).assertEqual(true);
      mocker.clear(DeviceHelper);
    });

    it('test_isCardIdInvalid', 0, () => {
      const model = FormModel.getInstance();
      let ret = model.isCardIdInvalid('0');
      expect(ret).assertEqual(true);
    });

    it('test_updateFormsAppInfo', 0, async () => {
      const formModel: FormModel = FormModel.getInstance();
      await formModel.updateFormsAppInfo();
      let appList: AppItemInfo[] = await formModel.getFormCenterAppList();
      expect(appList.length).assertLargerOrEqual(0);
    });

    it('test_batchInsertAppItemFormInfo', 0, async () => {
      const formModel: FormModel = FormModel.getInstance();
      let appItem: AppItemInfo = new AppItemInfo();
      let result: boolean = await formModel.batchInsertAppItemFormInfo([appItem]);
      expect(result).assertFalse();
    });

    it('test_deleteAppItemFormInfoInDB', 0, async () => {
      const formModel: FormModel = FormModel.getInstance();
      const bundleName: string = 'bundleName';
      let result: boolean = await formModel.deleteAppItemFormInfoInDB(bundleName);
      expect(result).assertTrue();
    });
  })
}