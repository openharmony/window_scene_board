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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { BackupItemType } from '../../../../../../../main/ets/model/BackupFavoriteInfo'
import { BaseTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/BaseTransformItem'
import { CardTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/CardTransformItem'
import {
  StackCardTransformItem
} from '../../../../../../../main/ets/transformdata/transfromitem/StackCardTransformItem'
import {
  BackupFavoriteInfo,
  BackupSceneBundleVersionName,
  GridLayoutItemInfo
} from '../../../../../../../main/ets/TsIndex'

export default function StackCardTransformItemTest() {
  describe('StackCardTransformItemTest', () => {
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
        let stackCardTransformItem: StackCardTransformItem = new StackCardTransformItem(new BackupFavoriteInfo());
        let result: boolean = stackCardTransformItem.isSupportInohos();
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('assert_transformBackupInfoToGridInfo_01', 0, async (done: Function) => {
      try {
        let stackCardTransformItem: StackCardTransformItem = new StackCardTransformItem(new BackupFavoriteInfo());
        let gridLayoutInfo: GridLayoutItemInfo[] =
          await stackCardTransformItem.transformBackupInfoToGridInfo([stackCardTransformItem],
            BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('assert_transformBackupInfoToGridInfo_02', 0, async (done: Function) => {
      try {
        let backupInfo: BackupFavoriteInfo = {
          id: 1,
          title: '@string/folder_tools++++实用工具',
          intent: '#Intent;action=adeliverd.intent.action.MAIN;category=adeliverd.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.adeliverd.view/ctrip.business.splash.CtripSplashActivity;end',
          container: -100,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 4,
          spanY: 4,
          itemType: 6,
        };
        let stackCardTransformItem: StackCardTransformItem = new StackCardTransformItem(backupInfo);
        let gridLayoutInfo: GridLayoutItemInfo[] =
          await stackCardTransformItem.transformBackupInfoToGridInfo([stackCardTransformItem],
            BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('assert_transformBackupInfoToGridInfo_03', 0, async (done: Function) => {
      try {
        let backupInfo: BackupFavoriteInfo = {
          id: 1,
          title: '@string/folder_tools++++实用工具',
          intent: '#Intent;action=adeliverd.intent.action.MAIN;category=adeliverd.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.adeliverd.view/ctrip.business.splash.CtripSplashActivity;end',
          container: -100,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 3,
          spanY: 3,
          itemType: 6,
        };
        let stackCardTransformItem: StackCardTransformItem = new StackCardTransformItem(backupInfo);
        let gridLayoutInfo: GridLayoutItemInfo[] =
          await stackCardTransformItem.transformBackupInfoToGridInfo([stackCardTransformItem],
            BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('assert_transformBackupInfoToGridInfo_04', 0, async (done: Function) => {
      try {
        let backupInfo: BackupFavoriteInfo = {
          id: 1,
          title: '@string/folder_tools++++实用工具',
          intent: '#Intent;action=adeliverd.intent.action.MAIN;category=adeliverd.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.adeliverd.view/ctrip.business.splash.CtripSplashActivity;end',
          container: -100,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 0,
          spanY: 3,
          itemType: 6,
        };
        let stackCardTransformItem: StackCardTransformItem = new StackCardTransformItem(backupInfo);
        let gridLayoutInfo: GridLayoutItemInfo[] =
          await stackCardTransformItem.transformBackupInfoToGridInfo([stackCardTransformItem],
            BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('assert_transformBackupInfoToGridInfo_05', 0, async (done: Function) => {
      try {
        let sameId: number = 1;
        let backupInfo: BackupFavoriteInfo = {
          id: sameId,
          title: '@string/folder_tools++++实用工具',
          intent: '#Intent;action=adeliverd.intent.action.MAIN;category=adeliverd.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.adeliverd.view/ctrip.business.splash.CtripSplashActivity;end',
          container: sameId,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 0,
          spanY: 3,
          itemType: BackupItemType.BACKUP_ITEM_TYPE_CARD,
        };
        let stackCardTransformItem: StackCardTransformItem = new StackCardTransformItem(backupInfo);
        stackCardTransformItem.transformBackupInfoToGridInfo([stackCardTransformItem],
          BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
        expect(stackCardTransformItem instanceof StackCardTransformItem).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('assert_transformBackupInfoToGridInfo_06', 0, async (done: Function) => {
      try {
        let sameId: number = 1;
        let backupInfo: BackupFavoriteInfo = {
          id: sameId,
          title: '@string/folder_tools++++实用工具',
          intent: '#Intent;action=adeliverd.intent.action.MAIN;category=adeliverd.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.adeliverd.view/ctrip.business.splash.CtripSplashActivity;end',
          container: -100,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 0,
          spanY: 3,
          itemType: BackupItemType.BACKUP_ITEM_TYPE_CARD,
        };
        let stackCardTransformItem: StackCardTransformItem = new StackCardTransformItem(backupInfo);

        let backupInfo1: BackupFavoriteInfo = {
          id: 1,
          title: '天气',
          intent: '',
          container: sameId,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 1,
          spanY: 1,
          itemType: 1,
        };
        backupInfo1.intent = '#Intent;component=com.openharmony.adeliverd.totemweather/com.openharmony.ohos.facard.MainAbility;' +
          'i.ohos.extra.param.key.form_dimension=3;l.ohos.extra.param.key.form_identity=36862021307234684;' +
          'i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Hourly%20Weather%20Forecast;' +
          'B.fa_card_background_blur_need=false;S.jsFormModuleName=card4x2;B.fa_variable_card=false;' +
          'S.jsFormCodePath=%2Fdata%2Fapp%2F~~rH11r95aAO2ow8Oi_xvi2w%3D%3D%2Fcom.openharmony.adeliverd.totemweather-5hk7jMe' +
          'jatzuohI4egzxeg%3D%3D%2Ffeature_predl_com.openharmony.adeliverd.totemweatherC100836941_17119428489200.hap;' +
          'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.adeliverd.totemweather%2Fcom.h' +
          'uawei.ohos.totemweather.EditCardAbility;S.original_bundle_name=com.openharmony.adeliverd.totemweather;' +
          'B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;S.related_bundle_name=;end';
        let cardTransformItem1: CardTransformItem = new CardTransformItem(backupInfo1);

        let backupInfo2: BackupFavoriteInfo = {
          id: 1,
          title: '天气',
          intent: '',
          container: sameId,
          screen: 1,
          cellX: 3,
          cellY: 4,
          spanX: 1,
          spanY: 1,
          itemType: 1,
        };
        backupInfo2.intent = '#Intent;component=com.openharmony.adeliverd.totemweather/com.openharmony.ohos.facard.MainAbility;' +
          'i.ohos.extra.param.key.form_dimension=3;l.ohos.extra.param.key.form_identity=36862021307234684;' +
          'i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Hourly%20Weather%20Forecast;' +
          'B.fa_card_background_blur_need=false;S.jsFormModuleName=card4x2;B.fa_variable_card=false;' +
          'S.jsFormCodePath=%2Fdata%2Fapp%2F~~rH11r95aAO2ow8Oi_xvi2w%3D%3D%2Fcom.openharmony.adeliverd.totemweather-5hk7jMe' +
          'jatzuohI4egzxeg%3D%3D%2Ffeature_predl_com.openharmony.adeliverd.totemweatherC100836941_17119428489200.hap;' +
          'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.adeliverd.totemweather%2Fcom.h' +
          'uawei.ohos.totemweather.EditCardAbility;S.original_bundle_name=com.openharmony.adeliverd.totemweather;' +
          'B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;S.related_bundle_name=;end';
        let cardTransformItem2: CardTransformItem = new CardTransformItem(backupInfo2);
        let backupTransformItemList: BaseTransformItem[] =
          [stackCardTransformItem, cardTransformItem1, cardTransformItem2];

        stackCardTransformItem.transformBackupInfoToGridInfo(backupTransformItemList,
          BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
        expect(stackCardTransformItem instanceof StackCardTransformItem).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
  })
}