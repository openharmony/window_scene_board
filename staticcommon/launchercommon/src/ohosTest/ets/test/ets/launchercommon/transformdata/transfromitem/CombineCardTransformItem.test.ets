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
  beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium'
import { CardTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/CardTransformItem'
import {
  CombineCardTransformItem
} from '../../../../../../../main/ets/transformdata/transfromitem/CombineCardTransformItem'
import { BackupFavoriteInfo,
  BackupSceneBundleVersionName,
  GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex'

export default function CombineCardTransformItemTest() {
  describe('CombineCardTransformItemTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('assert_isSupportInohos_01', 0, () => {
      try {
        let combineCardTransformItem: CombineCardTransformItem = new CombineCardTransformItem(new BackupFavoriteInfo());
        let result: boolean = combineCardTransformItem.isSupportInohos();
        expect(result).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_transformBackupInfoToGridInfo_01_7', 0, async () => {
      try {
        let backupInfo: BackupFavoriteInfo = {
          id: 657,
          title: 'form_combination_title=1',
          intent: '',
          container: -100,
          screen: 1,
          cellX: 0,
          cellY: 4,
          spanX: 4,
          spanY: 2,
          itemType: 12,
        };
        let combineCardTransformItem: CombineCardTransformItem = new CombineCardTransformItem(backupInfo);

        let cardInfo1: BackupFavoriteInfo = {
          id: 651,
          title: '国泰君安君弘',
          intent: '#Intent;component=com.gtja.junhong.hm.servicecard/com.gtja.junhong.hm.market.MarketMainAbility;' +
            'i.ohos.extra.param.key.form_dimension=2;l.ohos.extra.param.key.form_identity=36862020871357090;i.addtype=2;' +
            'i.previewId=0;S.ohos.extra.param.key.form_name=widget_market;S.jsFormModuleName=widget_market;' +
            'B.fa_variable_card=false;S.jsFormCodePath=%2Fdata%2Fapp%2F~~_SBkbhn3L6X81jQ5FTfSMg%3D%3D%2Fcom.gtja.junhong.' +
            'hm.servicecard-_D2o7aE2whdeYlQkC-yj3g%3D%3D%2Ffeature_predl_com.gtja.junhong.' +
            'hm.servicecardC651848335694506880_17157463593340.hap;B.fa_card_release_form=true;S.deepLink=;' +
            'S.original_bundle_name=com.gtja.junhong.hm.servicecard;B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=market;' +
            'B.fa_card_enter_animation=true;S.related_bundle_name=com.guotai.dazhihui;end',
          container: 657,
          screen: 11,
          cellX: 0,
          cellY: 0,
          spanX: 2,
          spanY: 2,
          itemType: 9,
        };
        let cardTransformItem1: CardTransformItem = new CardTransformItem(cardInfo1);

        let cardInfo2: BackupFavoriteInfo = {
          id: 652,
          title: '天气',
          intent: '#Intent;component=com.openharmony.ohos.totemweather/com.openharmony.ohos.facard.MainAbility;i.ohos.extra.param.key.form_dimension=1;' +
            'l.ohos.extra.param.key.form_identity=36862022634844071;i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Real-time%20weather2x1;' +
            'S.jsFormModuleName=card2x1Td;B.fa_variable_card=false;S.jsFormCodePath=%2Fdata%2Fapp%2F~~fhErCArCrn5BfZIE6rxCaQ%3D%3D%2Fcom.ohos' +
            '.totemweather-G6-cx526nhh-V17qXwJGVg%3D%3D%2Ffeature_predl_com.openharmony.ohos.totemweatherC100836941_17152384045441.hap;' +
            'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.ohos.totemweather%2Fcom.openharmony.ohos.totemweather.EditCardAbility;' +
            'S.original_bundle_name=com.openharmony.ohos.totemweather;B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;' +
            'B.fa_card_enter_animation=true;S.related_bundle_name=;end',
          container: 657,
          screen: 11,
          cellX: 2,
          cellY: 0,
          spanX: 2,
          spanY: 1,
          itemType: 9,
        };
        let cardTransformItem2: CardTransformItem = new CardTransformItem(cardInfo2);

        let cardInfo3: BackupFavoriteInfo = {
          id: 653,
          title: '天气',
          intent: '#Intent;component=com.openharmony.ohos.totemweather/com.openharmony.ohos.facard.MainAbility;i.ohos.extra.param.key.form_dimension=1;' +
            'l.ohos.extra.param.key.form_identity=36862022641858826;i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Tomorrow%20weather2x1;' +
            'S.jsFormModuleName=card2x1Tm;B.fa_variable_card=false;S.jsFormCodePath=%2Fdata%2Fapp%2F~~fhErCArCrn5BfZIE6rxCaQ%3D%3D%2Fcom.openharmony.' +
            'ohos.totemweather-G6-cx526nhh-V17qXwJGVg%3D%3D%2Ffeature_predl_com.openharmony.ohos.totemweatherC100836941_17152384045441.hap;' +
            'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.ohos.totemweather%2Fcom.openharmony.ohos.totemweather.EditCardAbility;' +
            'S.original_bundle_name=com.openharmony.ohos.totemweather;B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;' +
            'B.fa_card_enter_animation=true;S.related_bundle_name=;end',
          container: 657,
          screen: 11,
          cellX: 2,
          cellY: 1,
          spanX: 2,
          spanY: 1,
          itemType: 9,
        };
        let cardTransformItem3: CardTransformItem = new CardTransformItem(cardInfo3);
        let gridLayoutInfo: GridLayoutItemInfo[] = await combineCardTransformItem.transformBackupInfoToGridInfo(
          [combineCardTransformItem, cardTransformItem1, cardTransformItem2, cardTransformItem3],
          BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_transformBackupInfoToGridInfo_02_7', 0, async () => {
      try {
        let backupInfo: BackupFavoriteInfo = {
          id: 1,
          title: '',
          intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
          container: -100,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 1,
          spanY: 1,
          itemType: 12,
        };
        let combineCardTransformItem: CombineCardTransformItem = new CombineCardTransformItem(backupInfo);
        let gridLayoutInfo: GridLayoutItemInfo[] =
          await combineCardTransformItem.transformBackupInfoToGridInfo([combineCardTransformItem],
            BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_transformBackupInfoToGridInfo_03_7', 0, async () => {
      try {
        let backupInfo: BackupFavoriteInfo = {
          id: 1,
          title: '',
          intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
          container: -100,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 3,
          spanY: 3,
          itemType: 12,
        };
        let combineCardTransformItem: CombineCardTransformItem = new CombineCardTransformItem(backupInfo);
        let gridLayoutInfo: GridLayoutItemInfo[] =
          await combineCardTransformItem.transformBackupInfoToGridInfo([combineCardTransformItem],
            BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_transformBackupInfoToGridInfo_04_7', 0, async () => {
      let mock = new MockKit();
      try {
        let sameId: number = 1;
        let backupInfo: BackupFavoriteInfo = {
          id: sameId,
          title: '',
          intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
          container: sameId,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 3,
          spanY: 3,
          itemType: 12,
        };
        let combineCardTransformItem: CombineCardTransformItem = new CombineCardTransformItem(backupInfo);
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        await combineCardTransformItem.transformBackupInfoToGridInfo([combineCardTransformItem],
          BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
        expect(combineCardTransformItem instanceof CombineCardTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })
  })
}