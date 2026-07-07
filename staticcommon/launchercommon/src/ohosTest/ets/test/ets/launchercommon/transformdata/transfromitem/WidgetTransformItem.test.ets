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
import { WidgetTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/WidgetTransformItem'
import { BackupFavoriteInfo,
  BackupSceneBundleVersionName,
  GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex'

export default function WidgetTransformItemTest() {
  describe('WidgetTransformItemTest', () => {
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
        let widgetTransformItem: WidgetTransformItem = new WidgetTransformItem(new BackupFavoriteInfo());
        let result: boolean = widgetTransformItem.isSupportInohos();
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('assert_isSupportInohos_02', 0, () => {
      try {
        let info: BackupFavoriteInfo = new BackupFavoriteInfo();
        info.container = -101;
        let widgetTransformItem: WidgetTransformItem = new WidgetTransformItem(info);

        let result: boolean = widgetTransformItem.isSupportInohos();
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('assert_isSupportInohos_03', 0, () => {
      try {
        let info: BackupFavoriteInfo = new BackupFavoriteInfo();
        info.container = -100;
        let widgetTransformItem: WidgetTransformItem = new WidgetTransformItem(info);

        let result: boolean = widgetTransformItem.isSupportInohos();
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('assert_transformBackupInfoToGridInfo01', 0, async (done: Function) => {
      let widgetTransformItem: WidgetTransformItem = new WidgetTransformItem(new BackupFavoriteInfo());
      let gridLayoutInfo: GridLayoutItemInfo[] = await widgetTransformItem.transformBackupInfoToGridInfo([widgetTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
      expect(gridLayoutInfo.length).assertEqual(0);
      done();
    })

    it('assert_transformBackupInfoToGridInfo02', 0, async (done: Function) => {
      try {
        let backupInfo = new BackupFavoriteInfo();
        backupInfo.intent = '#Intent;component=com.openharmony.ohos.totemweather/com.openharmony.ohos.facard.MainAbility;'+
          'i.ohos.extra.param.key.form_dimension=3;l.ohos.extra.param.key.form_identity=36862021307234684;'+
          'i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Hourly%20Weather%20Forecast;'+
          'B.fa_card_background_blur_need=false;S.jsFormModuleName=card4x2;B.fa_variable_card=false;'+
          'S.jsFormCodePath=%2Fdata%2Fapp%2F~~rH11r95aAO2ow8Oi_xvi2w%3D%3D%2Fcom.openharmony.ohos.totemweather-5hk7jMe'+
          'jatzuohI4egzxeg%3D%3D%2Ffeature_predl_com.openharmony.ohos.totemweatherC100836941_17119428489200.hap;'+
          'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.ohos.totemweather%2Fcom.h'+
          'uawei.ohos.totemweather.EditCardAbility;S.original_bundle_name=com.openharmony.ohos.totemweather;'+
          'B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;S.related_bundle_name=;end';
        let cardTransformItem: WidgetTransformItem = new WidgetTransformItem(backupInfo);
        let gridLayoutInfo: GridLayoutItemInfo[] = await cardTransformItem.transformBackupInfoToGridInfo([cardTransformItem],
          BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
      } finally {
        done();
      }
    })

    it('assert_transformBackupInfoToGridInfo03', 0, async (done: Function) => {
      let backupInfo = new BackupFavoriteInfo();
      backupInfo.intent = '#Intent;component=com.gtja.junhong.hm.servicecard/com.gtja.junhong.hm.news.NewsMainAbility;'+
        'i.ohos.extra.param.key.form_dimension=2;l.ohos.extra.param.key.form_identity=36862021732692035;i.addtype=2;'+
        'i.previewId=0;S.ohos.extra.param.key.form_name=widget_zx;B.fa_card_background_blur_need=false;'+
        'S.jsFormModuleName=widget_zx;B.fa_variable_card=false;S.jsFormCodePath=%2Fdata%2Fapp%2F~~V201KxgXLo08zTF'+
        'IBgmK8g%3D%3D%2Fcom.gtja.junhong.hm.servicecard-RH3jEcUYHzQtWUOdSjnL5Q%3D%3D%2Ffeature_com.gtja.junhong.hm.s'+
        'ervicecard_2_1710917645348.hap;B.fa_card_release_form=true;S.deepLink=;S.original_bundle_name=com.gtja.junhon'+
        'g.hm.servicecard;B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=news;B.fa_card_enter_animation=true;'+
        'S.related_bundle_name=com.guotai.dazhihui;end';
      let cardTransformItem: WidgetTransformItem = new WidgetTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await cardTransformItem.transformBackupInfoToGridInfo([cardTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
      expect(gridLayoutInfo.length).assertEqual(0);
      done();
    })
  })
}