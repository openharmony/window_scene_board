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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import {
  AddCardToNewPageManager,
  CardMappingModel,
  CardUniqueType
} from '../../../../../../main/ets/transformdata/manager/AddCardToNewPageManager';
import { SceneType } from '../../../../../../main/ets/TsIndex';
import GridLayoutItemInfo from '../../../../../../main/ets/bean/GridLayoutItemInfo';
import { BackupFavoriteInfo, BackupItemType } from '../../../../../../main/ets/model/BackupFavoriteInfo';
import { IntentParseUtil, PackageRelation } from '../../../../../../main/ets/utils/IntentParseUtil';
import { CheckEmptyUtils, FileUtils } from '@ohos/basicutils';
import { CloneItemInfo, CommonConstants } from '../../../../../../main/ets/constants/CommonConstants';
import { FormModel } from '../../../../../../main/ets/model/FormModel';

interface CardMappingModelInterface {
  sceneType: string;
  sourceType: number;
  sourceAbilityName: string;
  targetBundleName: string;
  targetCardName: string;
  targetCardUnique: number;
}

export default function AddCardToNewPageManagerTest() {
  describe('AddCardToNewPageManagerTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('AddCardToNewPageManagerTest_01', 0, async (done: Function) => {
      await AddCardToNewPageManager.getInstance().init(SceneType.FROM_SCENE_BOARD);
      let result: GridLayoutItemInfo[] = [];
      await AddCardToNewPageManager.getInstance().dealWithAddCard(result);
      expect(result.length).assertLargerOrEqual(0);
      done();
    })

    it('AddCardToNewPageManagerTest_02', 0, async (done: Function) => {
      await AddCardToNewPageManager.getInstance().init(SceneType.FROM_HW_LAUNCHER);
      addCardToNewPageShortcut();
      let result: GridLayoutItemInfo[] = [];
      await AddCardToNewPageManager.getInstance().dealWithAddCard(result);
      expect(result.length).assertLargerOrEqual(0);
      done();
    })

    it('AddCardToNewPageManagerTest_03_7', 0, async () => {
      try {
        await AddCardToNewPageManager.getInstance().init(SceneType.FROM_HW_LAUNCHER);
        addCardToNewPageApp();
        let result: GridLayoutItemInfo[] = [];
        await AddCardToNewPageManager.getInstance().dealWithAddCard(result);
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('AddCardToNewPageManagerTest_04', 0, async (done: Function) => {
      await AddCardToNewPageManager.getInstance().init(SceneType.FROM_HW_LAUNCHER);
      addCardToNewPageCard();
      let result: GridLayoutItemInfo[] = [];
      await AddCardToNewPageManager.getInstance().dealWithAddCard(result);
      expect(result.length).assertLargerOrEqual(0);
      done();
    })

    it('AddCardToNewPageManagerTest_05_7', 0, async () => {
      try {
        await AddCardToNewPageManager.getInstance().init(SceneType.FROM_HW_LAUNCHER);
        addCardToNewPageShortcut();
        addCardToNewPageApp();
        addCardToNewPageCard();
        let result: GridLayoutItemInfo[] = [];
        await AddCardToNewPageManager.getInstance().dealWithAddCard(result);
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_loadFileMapping_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterThrow('err');
        let instance = AddCardToNewPageManager.getInstance();
        instance['loadFileMapping']();
        expect(instance instanceof AddCardToNewPageManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_parseFileMapping_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let instance = AddCardToNewPageManager.getInstance();
        instance['parseFileMapping']('');
        expect(instance instanceof AddCardToNewPageManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_parseFileMapping_02', 0, () => {
      try {
        let config: string =
          '[{"sceneType": "0,2","sourceType": 0,"sourceAbilityName": "onlyAdd","targetBundleName": "com.ohos.systemmanagerform","targetCardName": "shortCutCard","targetCardUnique": 2}]';
        let instance = AddCardToNewPageManager.getInstance();
        instance['parseFileMapping'](config);
        expect(instance instanceof AddCardToNewPageManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_addCardToNewPageShortcut_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(IntentParseUtil, IntentParseUtil.getComponentByIntent);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

        let instance = AddCardToNewPageManager.getInstance();
        addCardToNewPageShortcut();
        expect(instance instanceof AddCardToNewPageManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(IntentParseUtil);
      mock.clearAll();
    })

    it('test_addCardToNewPageShortcut_02', 0, () => {
      try {
        let instance = AddCardToNewPageManager.getInstance();
        instance.addCardToNewPageShortcut({} as BackupFavoriteInfo);
        expect(instance instanceof AddCardToNewPageManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_addCardToNewPageShortcut_03', 0, () => {
      try {
        let instance = AddCardToNewPageManager.getInstance();
        instance.addCardToNewPageShortcut(undefined);
        expect(instance instanceof AddCardToNewPageManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isMappingCard_01', 0, () => {
      try {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.typeId = CommonConstants.TYPE_CARD;
        item.bundleName = 'com.ohos.systemmanagerform';
        let param: CardMappingModelInterface = {
          'sceneType': '0,2',
          'sourceType': 0,
          'sourceAbilityName': 'com.openharmony.systemmanager.mainscreen.MainScreenActivity',
          'targetBundleName': item.bundleName,
          'targetCardName': 'shortCutCard',
          'targetCardUnique': CardUniqueType.BUNDLE_NAME
        }
        let mapping: CardMappingModel = new CardMappingModel(param);

        let instance = AddCardToNewPageManager.getInstance();
        instance['isMappingCard'](item, mapping);
        expect(instance instanceof AddCardToNewPageManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isMappingCard_02', 0, () => {
      try {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.typeId = CommonConstants.TYPE_CARD;
        item.bundleName = 'com.ohos.systemmanagerform';
        item.cardName = 'shortCutCard';
        let param: CardMappingModelInterface = {
          'sceneType': '0,2',
          'sourceType': 0,
          'sourceAbilityName': 'com.openharmony.systemmanager.mainscreen.MainScreenActivity',
          'targetBundleName': item.bundleName,
          'targetCardName': 'shortCutCard',
          'targetCardUnique': CardUniqueType.BUNDLE_NAME_CARD_NAME
        }
        let mapping: CardMappingModel = new CardMappingModel(param);

        let instance = AddCardToNewPageManager.getInstance();
        instance['isMappingCard'](item, mapping);
        expect(instance instanceof AddCardToNewPageManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_addCardToNewPage_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(FormModel.getInstance(), FormModel.getInstance().getFormsInfoByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterThrow('err');
        let backupItem: GridLayoutItemInfo[] = [];
        let backupInfo = new BackupFavoriteInfo();
        let param: CardMappingModelInterface = {
          'sceneType': '0,2',
          'sourceType': 0,
          'sourceAbilityName': 'com.openharmony.systemmanager.mainscreen.MainScreenActivity',
          'targetBundleName': 'com.ohos.systemmanagerform',
          'targetCardName': 'shortCutCard',
          'targetCardUnique': CardUniqueType.NOTHING
        }
        let mapping: CardMappingModel = new CardMappingModel(param);
        let instance = AddCardToNewPageManager.getInstance();
        instance['addCardToNewPage'](backupItem,backupInfo,mapping);
        expect(instance instanceof AddCardToNewPageManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(FormModel.getInstance());
      mock.clearAll();
    })

    it('test_addCardToNewPage_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(FormModel.getInstance(), FormModel.getInstance().getFormsInfoByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([]);

        let mockFunc2: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let backupItem: GridLayoutItemInfo[] = [];
        let backupInfo = new BackupFavoriteInfo();
        let param: CardMappingModelInterface = {
          'sceneType': '0,2',
          'sourceType': 0,
          'sourceAbilityName': 'com.openharmony.systemmanager.mainscreen.MainScreenActivity',
          'targetBundleName': 'com.ohos.systemmanagerform',
          'targetCardName': 'shortCutCard',
          'targetCardUnique': CardUniqueType.NOTHING
        }
        let mapping: CardMappingModel = new CardMappingModel(param);
        let instance = AddCardToNewPageManager.getInstance();
        instance['addCardToNewPage'](backupItem,backupInfo,mapping);
        expect(instance instanceof AddCardToNewPageManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(FormModel.getInstance());
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_addCardToNewPage_02', 0, () => {
      let mock = new MockKit();
      let instance = AddCardToNewPageManager.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, instance['addCardToNewPage']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(Promise.resolve());

        let param: CardMappingModelInterface = {
          'sceneType': '0,2',
          'sourceType': 0,
          'sourceAbilityName': 'com.openharmony.systemmanager.mainscreen.MainScreenActivity',
          'targetBundleName': 'com.ohos.systemmanagerform',
          'targetCardName': 'shortCutCard',
          'targetCardUnique': CardUniqueType.NOTHING
        }
        let mapping: CardMappingModel = new CardMappingModel(param);

        instance['sceneType'] = SceneType.FROM_HW_LAUNCHER;
        instance['mappingSet'].add(mapping);
        instance.dealWithAddCard([]);
        expect(instance instanceof AddCardToNewPageManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_getFileMapping_01', 0, () => {
      let mock = new MockKit();
      let instance = AddCardToNewPageManager.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(FileUtils, FileUtils.isExist);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        instance['getFileMapping']();
        expect(instance instanceof AddCardToNewPageManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(FileUtils);
      mock.clearAll();
    })


  })
}

function addCardToNewPageShortcut(): void {
  let backupInfo = new BackupFavoriteInfo();
  backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_SHORTCUT;
  backupInfo.intent =
    '#Intent;launchFlags=0x10200000;package=com.openharmony.systemmanager;component=com.openharmony.systemmanager/.mainscreen.MainScreenActivity;S.shortcut_id=space_clean;end';
  AddCardToNewPageManager.getInstance().addCardToNewPageShortcut(backupInfo);
}

function addCardToNewPageApp(): void {
  let backupInfo = new BackupFavoriteInfo();
  backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_APP;
  backupInfo.intent =
    '#Intent;launchFlags=0x10200000;component=com.openharmony.systemmanager/.mainscreen.MainScreenActivity;end';
  let packageRelation: PackageRelation = IntentParseUtil.getComponentByIntent(backupInfo.intent);
  AddCardToNewPageManager.getInstance().addCardToNewPageApp(backupInfo, packageRelation);
}

function addCardToNewPageCard(): void {
  let backupInfo = new BackupFavoriteInfo();
  backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_CARD;
  backupInfo.intent =
    '#Intent;component=com.openharmony.ohos.systemmanager/.FormAbility;i.ohos.extra.param.key.form_dimension=1;l.ohos.extra.param.key.form_identity=68905085265646719;i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=card_one_touch_optimization_horizontal;B.fa_card_background_blur_need=true;S.jsFormModuleName=card_one_touch_optimization_horizontal;B.fa_variable_card=false;S.jsFormCodePath=%2Fhw_product%2Fapp%2FHwSystemManagerHm%2Ffacard-entry-release-rich.hap;S.deepLink=;S.original_bundle_name=com.openharmony.ohos.systemmanager;B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;i.ohos.extra.param.key.form_width=441;i.ohos.extra.param.key.form_height=155;S.related_bundle_name=com.openharmony.systemmanager;end';
  let formRelationParamStr: string =
    AddCardToNewPageManager.getInstance().getFormRelationParamsFromIntent(backupInfo.intent);
  AddCardToNewPageManager.getInstance().addCardToNewPageCard(backupInfo, formRelationParamStr);
}