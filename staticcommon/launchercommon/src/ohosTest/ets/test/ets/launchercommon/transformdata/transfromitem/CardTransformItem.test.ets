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

import { CheckEmptyUtils } from '@ohos/basicutils'
import { afterAll, afterEach,
  ArgumentMatchers,
  beforeAll, beforeEach, describe, expect, it, MockKit,
  when } from '@ohos/hypium'
import { TransferFormRelationModel } from '../../../../../../../main/ets/transformdata/TransferFormRelationModel'
import { BaseTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/BaseTransformItem'
import { CardTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/CardTransformItem'
import {
  AppItemInfo,
  BackupFavoriteInfo,
  BackupSceneBundleVersionName,
  CommonConstants,
  dataConvert,
  FormRelationManager,
  GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex'
import { IntentParseUtil } from '../../../../../../../main/ets/utils/IntentParseUtil'

export default function CardTransformItemTest() {
  describe('CardTransformItemTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('assert_isSupportInohos', 0, () => {
      let cardTransformItem: CardTransformItem = new CardTransformItem(new BackupFavoriteInfo());
      let result: boolean = cardTransformItem.isSupportInohos();
      expect(result).assertFalse();
    })

    it('test_transformBackupInfoToGridInfo_01', 0, async () => {
      let cardTransformItem: CardTransformItem = new CardTransformItem(new BackupFavoriteInfo());
      let gridLayoutInfo: GridLayoutItemInfo[] = await cardTransformItem.transformBackupInfoToGridInfo([cardTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('test_transformBackupInfoToGridInfo_02', 0, async () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.totemweather';
      appInfo.abilityName = 'FormAbility';
      appInfo.moduleName = 'product';
      appInfo.typeId = CommonConstants.TYPE_CARD;
      appInfo.badgeNumber = 0;
      appInfo.appIconId = 100663798;
      appInfo.appLabelId = 1;
      appInfo.appStatus = 0;
      appInfo.iconResource = '';
      appInfo.callerName = '';
      dataConvert.setAppItemInfoList([appInfo]);

      let config: string = '\[{"sourceBundleName":"com.openharmony.adeliverd.totemweather","sourceModuleName":"facard","sourceAbilityName":' +
        '"com.openharmony.ohos.facard.MainAbility","sourceFormName":"Hourly Weather Forecast","sourceFormDimension":3,"targetBundleName":' +
        '"com.ohos.totemweather","targetModuleName":"product","targetAbilityName":"FormAbility","targetFormName": ' +
        '"weather","targetFormDimension":3}\]';
      let jsonArray = JSON.parse(config) as TransferFormRelationModel[];
      for (const jsonEle of jsonArray) {
        let formRelationModel: TransferFormRelationModel = new TransferFormRelationModel(jsonEle);
        FormRelationManager.getInstance().setFormRelation(formRelationModel.fromString, formRelationModel);
      }

      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '天气',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 1,
      };
      backupInfo.intent = '#Intent;component=com.openharmony.adeliverd.totemweather/com.openharmony.ohos.facard.MainAbility;'+
        'i.ohos.extra.param.key.form_dimension=3;l.ohos.extra.param.key.form_identity=36862021307234684;'+
        'i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Hourly%20Weather%20Forecast;'+
        'B.fa_card_background_blur_need=false;S.jsFormModuleName=card4x2;B.fa_variable_card=false;'+
        'S.jsFormCodePath=%2Fdata%2Fapp%2F~~rH11r95aAO2ow8Oi_xvi2w%3D%3D%2Fcom.openharmony.adeliverd.totemweather-5hk7jMe'+
        'jatzuohI4egzxeg%3D%3D%2Ffeature_predl_com.openharmony.adeliverd.totemweatherC100836941_17119428489200.hap;'+
        'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.adeliverd.totemweather%2Fcom.h'+
        'uawei.ohos.totemweather.EditCardAbility;S.original_bundle_name=com.openharmony.adeliverd.totemweather;'+
        'B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;S.related_bundle_name=;end';
      let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await cardTransformItem.transformBackupInfoToGridInfo([cardTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('test_transformBackupInfoToGridInfo_03', 0, async () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.photos';
      appInfo.abilityName = 'com.ohos.photos.FormAbility';
      appInfo.moduleName = 'phone_photos';
      appInfo.typeId = CommonConstants.TYPE_CARD;
      appInfo.badgeNumber = 0;
      appInfo.appIconId = 100663799;
      appInfo.appLabelId = 1;
      appInfo.appStatus = 0;
      appInfo.iconResource = '';
      appInfo.callerName = '';
      dataConvert.setAppItemInfoList([appInfo]);

      let config: string = '\[{"sourceBundleName":"com.openharmony.adeliverd.totemweather","sourceModuleName":"facard","sourceAbilityName":' +
        '"com.openharmony.ohos.facard.MainAbility","sourceFormName":"Hourly Weather Forecast","sourceFormDimension":3,"targetBundleName":' +
        '"com.ohos.totemweather","targetModuleName":"product","targetAbilityName":"FormAbility","targetFormName": ' +
        '"weather","targetFormDimension":3}\]';
      let jsonArray = JSON.parse(config) as TransferFormRelationModel[];
      for (const jsonEle of jsonArray) {
        let formRelationModel: TransferFormRelationModel = new TransferFormRelationModel(jsonEle);
        FormRelationManager.getInstance().setFormRelation(formRelationModel.fromString, formRelationModel);
      }

      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '天气',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 1,
      };
      backupInfo.intent = '#Intent;component=com.openharmony.adeliverd.totemweather/com.openharmony.ohos.facard.MainAbility;'+
        'i.ohos.extra.param.key.form_dimension=3;l.ohos.extra.param.key.form_identity=36862021307234684;'+
        'i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Hourly%20Weather%20Forecast;'+
        'B.fa_card_background_blur_need=false;S.jsFormModuleName=card4x2;B.fa_variable_card=false;'+
        'S.jsFormCodePath=%2Fdata%2Fapp%2F~~rH11r95aAO2ow8Oi_xvi2w%3D%3D%2Fcom.openharmony.adeliverd.totemweather-5hk7jMe'+
        'jatzuohI4egzxeg%3D%3D%2Ffeature_predl_com.openharmony.adeliverd.totemweatherC100836941_17119428489200.hap;'+
        'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.adeliverd.totemweather%2Fcom.h'+
        'uawei.ohos.totemweather.EditCardAbility;S.original_bundle_name=com.openharmony.adeliverd.totemweather;'+
        'B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;S.related_bundle_name=;end';
      let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await cardTransformItem.transformBackupInfoToGridInfo([cardTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('test_transformBackupInfoToGridInfo_04', 0, async () => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.totemweather';
      appInfo.abilityName = 'FormAbility';
      appInfo.moduleName = 'product';
      appInfo.typeId = CommonConstants.TYPE_CARD;
      appInfo.badgeNumber = 0;
      appInfo.appIconId = 100663798;
      appInfo.appLabelId = 1;
      appInfo.appStatus = 0;
      appInfo.iconResource = '';
      appInfo.callerName = '';
      dataConvert.setAppItemInfoList([appInfo]);

      let config: string = '\[{"sourceBundleName":"com.openharmony.adeliverd.totemweather","sourceModuleName":"facard","sourceAbilityName":' +
        '"com.openharmony.ohos.facard.MainAbility","sourceFormName":"Hourly Weather Forecast","sourceFormDimension":3,"targetBundleName":' +
        '"com.ohos.totemweather","targetModuleName":"product","targetAbilityName":"FormAbility","targetFormName": ' +
        '"weather","targetFormDimension":3}\]';
      let jsonArray = JSON.parse(config) as TransferFormRelationModel[];
      for (const jsonEle of jsonArray) {
        let formRelationModel: TransferFormRelationModel = new TransferFormRelationModel(jsonEle);
        FormRelationManager.getInstance().setFormRelation(formRelationModel.fromString, formRelationModel);
      }

      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '天气',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 1,
      };
      backupInfo.intent = '#Intent;component=com.openharmony.adeliverd.totemweather/com.openharmony.ohos.facard.MainAbility;'+
        'i.ohos.extra.param.key.form_dimension=3;l.ohos.extra.param.key.form_identity=36862021307234684;'+
        'i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Hourly%20Weather%20Forecast;'+
        'B.fa_card_background_blur_need=false;S.jsFormModuleName=card4x2;B.fa_variable_card=false;'+
        'S.jsFormCodePath=%2Fdata%2Fapp%2F~~rH11r95aAO2ow8Oi_xvi2w%3D%3D%2Fcom.openharmony.adeliverd.totemweather-5hk7jMe'+
        'jatzuohI4egzxeg%3D%3D%2Ffeature_predl_com.openharmony.adeliverd.totemweatherC100836941_17119428489200.hap;'+
        'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.adeliverd.totemweather%2Fcom.h'+
        'uawei.ohos.totemweather.EditCardAbility;S.original_bundle_name=com.openharmony.adeliverd.totemweather;'+
        'B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;S.related_bundle_name=;end';
      let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await cardTransformItem.transformBackupInfoToGridInfo([cardTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('test_transformBackupInfoToGridInfo_05', 0, async () => {
      let mock = new MockKit();
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '天气',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 1,
      };
      backupInfo.intent = '#Intent;component=com.openharmony.adeliverd.totemweather/com.openharmony.ohos.facard.MainAbility;' +
        'i.ohos.extra.param.key.form_dimension=3;l.ohos.extra.param.key.form_identity=36862021307234684;' +
        'i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Hourly%20Weather%20Forecast;' +
        'B.fa_card_background_blur_need=false;S.jsFormModuleName=card4x2;B.fa_variable_card=false;' +
        'S.jsFormCodePath=%2Fdata%2Fapp%2F~~rH11r95aAO2ow8Oi_xvi2w%3D%3D%2Fcom.openharmony.adeliverd.totemweather-5hk7jMe' +
        'jatzuohI4egzxeg%3D%3D%2Ffeature_predl_com.openharmony.adeliverd.totemweatherC100836941_17119428489200.hap;' +
        'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.adeliverd.totemweather%2Fcom.h' +
        'uawei.ohos.totemweather.EditCardAbility;S.original_bundle_name=com.openharmony.adeliverd.totemweather;' +
        'B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;S.related_bundle_name=;end';
      let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
      try {
        let mockFunc: Function = mock.mockFunc(cardTransformItem, cardTransformItem['getPortfolioId']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn('1');

        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.totemweather';
        appInfo.abilityName = 'FormAbility';
        appInfo.moduleName = 'product';
        appInfo.typeId = CommonConstants.TYPE_CARD;
        appInfo.badgeNumber = 0;
        appInfo.appIconId = 100663798;
        appInfo.appLabelId = 1;
        appInfo.appStatus = 0;
        appInfo.iconResource = '';
        appInfo.callerName = '';
        dataConvert.setAppItemInfoList([appInfo]);

        let config: string =
          '\[{"sourceBundleName":"com.openharmony.adeliverd.totemweather","sourceModuleName":"facard","sourceAbilityName":' +
            '"com.openharmony.ohos.facard.MainAbility","sourceFormName":"Hourly Weather Forecast","sourceFormDimension":3,"targetBundleName":' +
            '"com.ohos.totemweather","targetModuleName":"product","targetAbilityName":"FormAbility","targetFormName": ' +
            '"weather","targetFormDimension":3}\]';
        let jsonArray = JSON.parse(config) as TransferFormRelationModel[];
        for (const jsonEle of jsonArray) {
          let formRelationModel: TransferFormRelationModel = new TransferFormRelationModel(jsonEle);
          FormRelationManager.getInstance().setFormRelation(formRelationModel.fromString, formRelationModel);
        }

        let gridLayoutInfo: GridLayoutItemInfo[] =
          await cardTransformItem.transformBackupInfoToGridInfo([cardTransformItem],
            BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(cardTransformItem);
      mock.clearAll();
    })

    it('test_transformBackupInfoToGridInfo_06', 0, async () => {
      let mock = new MockKit();
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '天气',
        intent: '',
        container: -100,
        screen: 1,
        cellX: -1,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 1,
      };
      backupInfo.intent = '#Intent;component=com.openharmony.adeliverd.totemweather/com.openharmony.ohos.facard.MainAbility;' +
        'i.ohos.extra.param.key.form_dimension=3;l.ohos.extra.param.key.form_identity=36862021307234684;' +
        'i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Hourly%20Weather%20Forecast;' +
        'B.fa_card_background_blur_need=false;S.jsFormModuleName=card4x2;B.fa_variable_card=false;' +
        'S.jsFormCodePath=%2Fdata%2Fapp%2F~~rH11r95aAO2ow8Oi_xvi2w%3D%3D%2Fcom.openharmony.adeliverd.totemweather-5hk7jMe' +
        'jatzuohI4egzxeg%3D%3D%2Ffeature_predl_com.openharmony.adeliverd.totemweatherC100836941_17119428489200.hap;' +
        'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.adeliverd.totemweather%2Fcom.h' +
        'uawei.ohos.totemweather.EditCardAbility;S.original_bundle_name=com.openharmony.adeliverd.totemweather;' +
        'B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;S.related_bundle_name=;end';
      let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
      try {
        let mockFunc: Function = mock.mockFunc(cardTransformItem, cardTransformItem['getPortfolioId']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.totemweather';
        appInfo.abilityName = 'FormAbility';
        appInfo.moduleName = 'product';
        appInfo.typeId = CommonConstants.TYPE_CARD;
        appInfo.badgeNumber = 0;
        appInfo.appIconId = 100663798;
        appInfo.appLabelId = 1;
        appInfo.appStatus = 0;
        appInfo.iconResource = '';
        appInfo.callerName = '';
        dataConvert.setAppItemInfoList([appInfo]);

        let config: string =
          '\[{"sourceBundleName":"com.openharmony.adeliverd.totemweather","sourceModuleName":"facard","sourceAbilityName":' +
            '"com.openharmony.ohos.facard.MainAbility","sourceFormName":"Hourly Weather Forecast","sourceFormDimension":3,"targetBundleName":' +
            '"com.ohos.totemweather","targetModuleName":"product","targetAbilityName":"FormAbility","targetFormName": ' +
            '"weather","targetFormDimension":3}\]';
        let jsonArray = JSON.parse(config) as TransferFormRelationModel[];
        for (const jsonEle of jsonArray) {
          let formRelationModel: TransferFormRelationModel = new TransferFormRelationModel(jsonEle);
          FormRelationManager.getInstance().setFormRelation(formRelationModel.fromString, formRelationModel);
        }


        let gridLayoutInfo: GridLayoutItemInfo[] =
          await cardTransformItem.transformBackupInfoToGridInfo([cardTransformItem],
            BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(cardTransformItem);
      mock.clearAll();
    })

    it('test_transformBackupInfoToGridInfo_07', 0, async () => {
      let mock = new MockKit();
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '天气',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: -1,
        spanX: 1,
        spanY: 1,
        itemType: 1,
      };
      backupInfo.intent = '#Intent;component=com.openharmony.adeliverd.totemweather/com.openharmony.ohos.facard.MainAbility;' +
        'i.ohos.extra.param.key.form_dimension=3;l.ohos.extra.param.key.form_identity=36862021307234684;' +
        'i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Hourly%20Weather%20Forecast;' +
        'B.fa_card_background_blur_need=false;S.jsFormModuleName=card4x2;B.fa_variable_card=false;' +
        'S.jsFormCodePath=%2Fdata%2Fapp%2F~~rH11r95aAO2ow8Oi_xvi2w%3D%3D%2Fcom.openharmony.adeliverd.totemweather-5hk7jMe' +
        'jatzuohI4egzxeg%3D%3D%2Ffeature_predl_com.openharmony.adeliverd.totemweatherC100836941_17119428489200.hap;' +
        'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.adeliverd.totemweather%2Fcom.h' +
        'uawei.ohos.totemweather.EditCardAbility;S.original_bundle_name=com.openharmony.adeliverd.totemweather;' +
        'B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;S.related_bundle_name=;end';
      let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
      try {
        let mockFunc: Function = mock.mockFunc(cardTransformItem, cardTransformItem['getPortfolioId']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.totemweather';
        appInfo.abilityName = 'FormAbility';
        appInfo.moduleName = 'product';
        appInfo.typeId = CommonConstants.TYPE_CARD;
        appInfo.badgeNumber = 0;
        appInfo.appIconId = 100663798;
        appInfo.appLabelId = 1;
        appInfo.appStatus = 0;
        appInfo.iconResource = '';
        appInfo.callerName = '';
        dataConvert.setAppItemInfoList([appInfo]);

        let config: string =
          '\[{"sourceBundleName":"com.openharmony.adeliverd.totemweather","sourceModuleName":"facard","sourceAbilityName":' +
            '"com.openharmony.ohos.facard.MainAbility","sourceFormName":"Hourly Weather Forecast","sourceFormDimension":3,"targetBundleName":' +
            '"com.ohos.totemweather","targetModuleName":"product","targetAbilityName":"FormAbility","targetFormName": ' +
            '"weather","targetFormDimension":3}\]';
        let jsonArray = JSON.parse(config) as TransferFormRelationModel[];
        for (const jsonEle of jsonArray) {
          let formRelationModel: TransferFormRelationModel = new TransferFormRelationModel(jsonEle);
          FormRelationManager.getInstance().setFormRelation(formRelationModel.fromString, formRelationModel);
        }


        let gridLayoutInfo: GridLayoutItemInfo[] =
          await cardTransformItem.transformBackupInfoToGridInfo([cardTransformItem],
            BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(cardTransformItem);
      mock.clearAll();
    })

    it('test_transformBackupInfoToGridInfo_08', 0, async () => {
      let config: string = '\[{"sourceBundleName":"com.gtja.junhong.hm.servicecard","sourceModuleName":"newstock","sourceAbilityName":' +
        '"com.gtja.junhong.hm.newstock.NewStockMainAbility","sourceFormName":"widget_xg","sourceFormDimension":2,"targetBundleName":' +
        '"com.gtja.junhong.hm.next","targetModuleName":"default","targetAbilityName":"EntryFormAbility","targetFormName":' +
        '"newstockwidget","targetFormDimension":2}\]';
      let jsonArray = JSON.parse(config) as TransferFormRelationModel[];
      for (const jsonEle of jsonArray) {
        let formRelationModel: TransferFormRelationModel = new TransferFormRelationModel(jsonEle);
        FormRelationManager.getInstance().setFormRelation(formRelationModel.fromString, formRelationModel);
      }

      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '国泰君安君弘',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 1,
      };
      backupInfo.intent = '#Intent;component=com.gtja.junhong.hm.servicecard/com.gtja.junhong.hm.newstock.NewStockMainAbility;' +
        'i.ohos.extra.param.key.form_dimension=2;l.ohos.extra.param.key.form_identity=36862020847663787;i.addtype=2;' +
        'i.previewId=-2029846528;S.ohos.extra.param.key.form_name=widget_xg;S.jsFormModuleName=;B.fa_variable_card=false;' +
        'S.jsFormCodePath=;B.fa_card_release_form=true;S.deepLink=;S.original_bundle_name=com.gtja.junhong.hm.servicecard;' +
        'B.fa_is_js_card=false;S.ohos.extra.param.key.module_name=newstock;B.fa_card_enter_animation=true;' +
        'S.related_bundle_name=com.guotai.dazhihui;end';
      let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
      try {
        let gridLayoutInfo: GridLayoutItemInfo[] = await cardTransformItem.transformBackupInfoToGridInfo([cardTransformItem],
          BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
      } catch (e) {}
    })

    it('test_transformBackupInfoToGridInfo_09', 0, async () => {
      let config: string = '\[{"sourceBundleName":"com.gtja.junhong.hm.servicecard","sourceModuleName":"newstock","sourceAbilityName":' +
        '"com.gtja.junhong.hm.newstock.NewStockMainAbility","sourceFormName":"widget_xg","sourceFormDimension":2,"targetBundleName":' +
        '"com.gtja.junhong.hm.next","targetModuleName":"default","targetAbilityName":"EntryFormAbility","targetFormName":' +
        '"newstockwidget","targetFormDimension":2}\]';
      let jsonArray = JSON.parse(config) as TransferFormRelationModel[];
      for (const jsonEle of jsonArray) {
        let formRelationModel: TransferFormRelationModel = new TransferFormRelationModel(jsonEle);
        FormRelationManager.getInstance().setFormRelation(formRelationModel.fromString, formRelationModel);
      }

      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '国泰君安君弘',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 1,
      };
      backupInfo.intent = '#Intent;component=com.gtja.junhong.hm.servicecard/com.gtja.junhong.hm.newstock.NewStockMainAbility;' +
        'i.ohos.extra.param.key.form_dimension=2;l.ohos.extra.param.key.form_identity=36862020847663787;i.addtype=2;' +
        'i.previewId=-2029846528;S.ohos.extra.param.key.form_name=widget_xg;S.jsFormModuleName=;B.fa_variable_card=false;' +
        'S.jsFormCodePath=;B.fa_card_release_form=true;S.deepLink=;S.original_bundle_name=com.gtja.junhong.hm.servicecard;' +
        'B.fa_is_js_card=false;S.ohos.extra.param.key.module_name=newstock;B.fa_card_enter_animation=true;' +
        'S.related_bundle_name=com.guotai.dazhihui;end';
      let cardTransformItem: CardTransformItem = new CardTransformItem(new BackupFavoriteInfo());
      let gridLayoutInfo: GridLayoutItemInfo[] = await cardTransformItem.transformBackupInfoToGridInfo([cardTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('test_transformBackupInfoToGridInfo_10', 0, async () => {
      let config: string = '\[{"sourceBundleName":"com.gtja.junhong.hm.servicecard","sourceModuleName":"newstock","sourceAbilityName":' +
        '"com.gtja.junhong.hm.newstock.NewStockMainAbility","sourceFormName":"widget_xg","sourceFormDimension":2,"targetBundleName":' +
        '"com.gtja.junhong.hm.next","targetModuleName":"default","targetAbilityName":"EntryFormAbility","targetFormName":' +
        '"newstockwidget","targetFormDimension":2}\]';
      let jsonArray = JSON.parse(config) as TransferFormRelationModel[];
      for (const jsonEle of jsonArray) {
        let formRelationModel: TransferFormRelationModel = new TransferFormRelationModel(jsonEle);
        FormRelationManager.getInstance().setFormRelation(formRelationModel.fromString, formRelationModel);
      }

      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 2,
        spanY: 2,
        itemType: 1,
      };
      backupInfo.intent = '#Intent;component=com.gtja.junhong.hm.servicecard/com.gtja.junhong.hm.newstock.NewStockMainAbility;' +
        'i.ohos.extra.param.key.form_dimension=2;l.ohos.extra.param.key.form_identity=36862020847663787;i.addtype=2;' +
        'i.previewId=-2029846528;S.ohos.extra.param.key.form_name=widget_xg;S.jsFormModuleName=;B.fa_variable_card=false;' +
        'S.jsFormCodePath=;B.fa_card_release_form=true;S.deepLink=;S.original_bundle_name=com.gtja.junhong.hm.servicecard;' +
        'B.fa_is_js_card=false;S.ohos.extra.param.key.module_name=newstock;B.fa_card_enter_animation=true;' +
        'S.related_bundle_name=com.guotai.dazhihui;end';

      let cardTransformItem: CardTransformItem = new CardTransformItem(new BackupFavoriteInfo());
      let gridLayoutInfo: GridLayoutItemInfo[] = await cardTransformItem.transformBackupInfoToGridInfo([cardTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('test_createRelationModel_01', 0, async (done: Function) => {
      try {
        let formRelationModel: TransferFormRelationModel = getTransferFormRelationModel();
        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        let placeholderCardId: string = '';
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
        cardTransformItem['createRelationModel'](formRelationModel, backupInfo, placeholderCardId);
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_saveFormRelation_01', 0, async (done: Function) => {
      try {
        let formRelationModel: TransferFormRelationModel = getTransferFormRelationModel();
        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        let placeholderCardId: string = '';
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
        cardTransformItem['saveFormRelation'](formRelationModel, backupInfo, placeholderCardId);
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_buildSceneBoardDefaultCard_01', 0, async (done: Function) => {
      try {
        let formRelationModel: TransferFormRelationModel = getTransferFormRelationModel();
        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        let placeholderCardId: string = '';
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
        cardTransformItem['buildSceneBoardDefaultCard'](formRelationModel, placeholderCardId);
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getPortfolioId_01', 0, async (done: Function) => {
      try {
        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
        cardTransformItem['getPortfolioId']('');
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getPortfolioId_02', 0, async (done: Function) => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(IntentParseUtil, IntentParseUtil.parseIntent);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
        cardTransformItem['getPortfolioId']('');
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(IntentParseUtil);
      mock.clearAll();
    })

    it('test_setBackupTitle_01', 0, async (done: Function) => {
      try {
        let backupTransformItemList: BaseTransformItem [] = [];
        let sourceBundleName: string = '';
        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        backupInfo.title = 'not_empty';
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
        cardTransformItem['setBackupTitle'](backupInfo, backupTransformItemList, sourceBundleName);
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_setBackupTitle_02', 0, async (done: Function) => {
      try {
        let backupTransformItemList: BaseTransformItem [] = [];
        let sourceBundleName: string = '';
        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        backupInfo.title = '';
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
        cardTransformItem['setBackupTitle'](backupInfo, backupTransformItemList, sourceBundleName);
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_setBackupTitle_03', 0, async (done: Function) => {
      try {
        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        backupInfo.itemType === CommonConstants.TYPE_APP;
        backupInfo.intent = 'sourceBundleName';
        backupInfo.title = '';
        let backupTransformItemList: BaseTransformItem [] = [];
        let item: BaseTransformItem = new BaseTransformItem(backupInfo);

        backupTransformItemList.push(item);
        let sourceBundleName: string = 'sourceBundleName';

        backupInfo.title = '';
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
        cardTransformItem['setBackupTitle'](backupInfo, backupTransformItemList, sourceBundleName);
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getFormRelationParamsFromIntent_01', 0, () => {
      try {
        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
        cardTransformItem['getFormRelationParamsFromIntent']('');
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getFormRelationParamsFromIntent_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(IntentParseUtil, IntentParseUtil.parseIntent);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
        cardTransformItem['getFormRelationParamsFromIntent']('');
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(IntentParseUtil);
      mock.clearAll();
    })

    it('test_getAppPackageName_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
        cardTransformItem['getAppPackageName'](backupInfo, []);
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_getAppPackageName_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
        cardTransformItem['getAppPackageName'](backupInfo, []);
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_getAppPackageName_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let backupInfo: BackupFavoriteInfo = {
          id: 1,
          title: '天气',
          intent: '',
          container: -100,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 1,
          spanY: 1,
          itemType: 1,
        };
        backupInfo.intent = '#Intent;component=com.openharmony.adeliverd.totemweather/com.openharmony.ohos.facard.MainAbility;' +
          'i.ohos.extra.param.key.form_dimension=3;l.ohos.extra.param.key.form_identity=36862021307234684;' +
          'i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Hourly%20Weather%20Forecast;' +
          'B.fa_card_background_blur_need=false;S.jsFormModuleName=card4x2;B.fa_variable_card=false;' +
          'S.jsFormCodePath=%2Fdata%2Fapp%2F~~rH11r95aAO2ow8Oi_xvi2w%3D%3D%2Fcom.openharmony.adeliverd.totemweather-5hk7jMe' +
          'jatzuohI4egzxeg%3D%3D%2Ffeature_predl_com.openharmony.adeliverd.totemweatherC100836941_17119428489200.hap;' +
          'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.adeliverd.totemweather%2Fcom.h' +
          'uawei.ohos.totemweather.EditCardAbility;S.original_bundle_name=com.openharmony.adeliverd.totemweather;' +
          'B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;S.related_bundle_name=;end';
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);
        cardTransformItem['getAppPackageName'](backupInfo, []);
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_getAppPackageName_04', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let backupInfo: BackupFavoriteInfo = {
          id: 1,
          title: '天气',
          intent: '',
          container: -100,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 1,
          spanY: 1,
          itemType: CommonConstants.TYPE_APP,
        };
        backupInfo.intent = '#Intent;component=com.openharmony.adeliverd.totemweather/com.openharmony.ohos.facard.MainAbility;' +
          'i.ohos.extra.param.key.form_dimension=3;l.ohos.extra.param.key.form_identity=36862021307234684;' +
          'i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Hourly%20Weather%20Forecast;' +
          'B.fa_card_background_blur_need=false;S.jsFormModuleName=card4x2;B.fa_variable_card=false;' +
          'S.jsFormCodePath=%2Fdata%2Fapp%2F~~rH11r95aAO2ow8Oi_xvi2w%3D%3D%2Fcom.openharmony.adeliverd.totemweather-5hk7jMe' +
          'jatzuohI4egzxeg%3D%3D%2Ffeature_predl_com.openharmony.adeliverd.totemweatherC100836941_17119428489200.hap;' +
          'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.adeliverd.totemweather%2Fcom.h' +
          'uawei.ohos.totemweather.EditCardAbility;S.original_bundle_name=com.openharmony.adeliverd.totemweather;' +
          'B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;S.related_bundle_name=;end';
        let cardTransformItem: CardTransformItem = new CardTransformItem(backupInfo);

        let backupTransformItemList: BaseTransformItem [] = [];
        let item: BaseTransformItem = new BaseTransformItem(backupInfo);
        backupTransformItemList.push(item);

        cardTransformItem['getAppPackageName'](backupInfo, backupTransformItemList);
        expect(cardTransformItem instanceof CardTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })


  })
}

function getTransferFormRelationModel(): TransferFormRelationModel {
  let config: string =
    '\[{"sourceBundleName":"com.gtja.junhong.hm.servicecard","sourceModuleName":"newstock","sourceAbilityName":' +
      '"com.gtja.junhong.hm.newstock.NewStockMainAbility","sourceFormName":"widget_xg","sourceFormDimension":2,"targetBundleName":' +
      '"com.gtja.junhong.hm.next","targetModuleName":"default","targetAbilityName":"EntryFormAbility","targetFormName":' +
      '"newstockwidget","targetFormDimension":2}\]';
  let jsonArray = JSON.parse(config) as TransferFormRelationModel[];
  let formRelationModel: TransferFormRelationModel = new TransferFormRelationModel(jsonArray[0]);
  return formRelationModel;
}