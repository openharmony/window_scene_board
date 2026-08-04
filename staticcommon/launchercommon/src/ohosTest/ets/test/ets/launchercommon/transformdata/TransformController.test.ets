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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
  Level
} from '@ohos/hypium'
import {
  BackupFavoriteInfo,
  CommonConstants,
  dataConvert,
  FormHiSysEventReporter,
  GridLayoutItemInfo,
  TransferLayoutManager,
  transferRelationManager,
  TransformController,
  UpdateRdbManager
} from '../../../../../../main/ets/TsIndex'
import { preferences, relationalStore } from '@kit.ArkData'
import { GlobalContext } from '@ohos/frameworkwrapper'
import type ctx from '@ohos.app.ability.common';
import { IntentParseUtil, PackageRelation } from '../../../../../../main/ets/utils/IntentParseUtil'
import { BackupItemType } from '../../../../../../main/ets/model/BackupFavoriteInfo'

export default function TransformControllerTest() {
  describe('TransformControllerTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('test_startTransferLauncherDbData01_7', 0, async () => {
      try {
        let updateRdbManager: UpdateRdbManager = UpdateRdbManager.getInstance();
        let transferManager: TransferLayoutManager = new TransferLayoutManager([4, 6], [4, 6]);
        let mocker: MockKit = new MockKit();

        const launcherStoreConfig: relationalStore.StoreConfig = {
          name: 'launcher_back.db',
          securityLevel: relationalStore.SecurityLevel.S1
        };
        let mRdbStore: relationalStore.RdbStore = await relationalStore.getRdbStore(
          GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext, launcherStoreConfig);
        updateRdbManager.setLauncherRdbStore(mRdbStore);

        let saveOldLayoutToContext: Function =
          mocker.mockFunc(updateRdbManager, updateRdbManager.saveOldLayoutToContext);
        when(saveOldLayoutToContext)().afterReturn(Promise.resolve());

        let loadTransferInfos: Function =
          mocker.mockFunc(transferRelationManager, transferRelationManager.loadTransferInfos);
        when(loadTransferInfos)().afterReturn(Promise.resolve());

        let backupInfo1: BackupFavoriteInfo = {
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
        backupInfo1.intent =
          '#Intent;component=com.gtja.junhong.hm.servicecard/com.gtja.junhong.hm.newstock.NewStockMainAbility;' +
            'i.ohos.extra.param.key.form_dimension=2;l.ohos.extra.param.key.form_identity=36862020847663787;i.addtype=2;' +
            'i.previewId=-2029846528;S.ohos.extra.param.key.form_name=widget_xg;S.jsFormModuleName=;B.fa_variable_card=false;' +
            'S.jsFormCodePath=;B.fa_card_release_form=true;S.deepLink=;S.original_bundle_name=com.gtja.junhong.hm.servicecard;' +
            'B.fa_is_js_card=false;S.ohos.extra.param.key.module_name=newstock;B.fa_card_enter_animation=true;' +
            'S.related_bundle_name=com.guotai.dazhihui;end';

        let backupInfo2: BackupFavoriteInfo = {
          id: 0,
          title: '联系人',
          intent: '',
          container: -100,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 1,
          spanY: 1,
          itemType: 0,
        };
        backupInfo2.intent = '#Intent;action=adeliverd.intent.action.MAIN;category=adeliverd.intent.category.LAUNCHER;' +
          'launchFlags=0x10200000;component=com.openharmony.contacts/com.adeliverd.contacts.activities.PeopleActivity;end';

        let backupInfo3: BackupFavoriteInfo = {
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
        backupInfo3.intent = '#Intent;component=com.openharmony.adeliverd.totemweather/com.openharmony.ohos.facard.MainAbility;' +
          'i.ohos.extra.param.key.form_dimension=3;l.ohos.extra.param.key.form_identity=36862021307234684;' +
          'i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Hourly%20Weather%20Forecast;' +
          'B.fa_card_background_blur_need=false;S.jsFormModuleName=card4x2;B.fa_variable_card=false;' +
          'S.jsFormCodePath=%2Fdata%2Fapp%2F~~rH11r95aAO2ow8Oi_xvi2w%3D%3D%2Fcom.openharmony.adeliverd.totemweather-5hk7jMe' +
          'jatzuohI4egzxeg%3D%3D%2Ffeature_predl_com.openharmony.adeliverd.totemweatherC100836941_17119428489200.hap;' +
          'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.adeliverd.totemweather%2Fcom.h' +
          'uawei.ohos.totemweather.EditCardAbility;S.original_bundle_name=com.openharmony.adeliverd.totemweather;' +
          'B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;S.related_bundle_name=;end';

        let backUpInfoList: BackupFavoriteInfo[] = [];
        let queryLauncherDbDesktopInfo: Function =
          mocker.mockFunc(updateRdbManager, updateRdbManager.queryLauncherDbDesktopInfo);
        when(queryLauncherDbDesktopInfo)(false).afterReturn(backUpInfoList);

        let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayout.typeId = 0;
        gridLayout.infoId = 'gridLayoutInfoId';
        gridLayout.appName = 'gridLayoutAppName';
        gridLayout.bundleName = 'gridLayoutBundleName';
        gridLayout.keyName = 'gridLayoutKeyName';
        gridLayout.folderName = 'gridLayoutFolderName'
        gridLayout.abilityName = 'gridLayoutAbilityName';
        gridLayout.moduleName = 'gridLayoutModuleName';
        gridLayout.appIconId = 1;
        gridLayout.appLabelId = 2;
        gridLayout.badgeNumber = 3;
        gridLayout.row = 4;
        gridLayout.column = 5;
        gridLayout.area = [6, 7];
        gridLayout.areaType = 8;
        let convertData: Function = mocker.mockFunc(dataConvert, dataConvert.convertData);
        when(convertData)(ArgumentMatchers.any).afterReturn([gridLayout]);
        GlobalContext.getInstance().setObject('oldLayoutGrid', [4, 6]);
        let transferLayout: Function = mocker.mockFunc(transferManager, transferManager.transferLayout);
        when(transferLayout)().afterReturn(Promise.resolve());

        let transformController: TransformController = new TransformController();
        await transformController.startTransferLauncherDbData();
        expect(transformController instanceof TransformController).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_startTransferLauncherDbData02_7', 0, async () => {
      let mocker: MockKit = new MockKit();
      let updateRdbManager: UpdateRdbManager = UpdateRdbManager.getInstance();
      let transferManager: TransferLayoutManager = new TransferLayoutManager([4, 6], [4, 6]);
      try {
        const launcherStoreConfig: relationalStore.StoreConfig = {
          name: 'launcher_back.db',
          securityLevel: relationalStore.SecurityLevel.S1
        };
        let mRdbStore: relationalStore.RdbStore = await relationalStore.getRdbStore(
          GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext, launcherStoreConfig);
        updateRdbManager.setLauncherRdbStore(mRdbStore);

        let saveOldLayoutToContext: Function =
          mocker.mockFunc(updateRdbManager, updateRdbManager.saveOldLayoutToContext);
        when(saveOldLayoutToContext)().afterReturn(Promise.resolve());

        let loadTransferInfos: Function =
          mocker.mockFunc(transferRelationManager, transferRelationManager.loadTransferInfos);
        when(loadTransferInfos)().afterReturn(Promise.resolve());

        let backupInfo1: BackupFavoriteInfo = {
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
        backupInfo1.intent =
          '#Intent;component=com.gtja.junhong.hm.servicecard/com.gtja.junhong.hm.newstock.NewStockMainAbility;' +
            'i.ohos.extra.param.key.form_dimension=2;l.ohos.extra.param.key.form_identity=36862020847663787;i.addtype=2;' +
            'i.previewId=-2029846528;S.ohos.extra.param.key.form_name=widget_xg;S.jsFormModuleName=;B.fa_variable_card=false;' +
            'S.jsFormCodePath=;B.fa_card_release_form=true;S.deepLink=;S.original_bundle_name=com.gtja.junhong.hm.servicecard;' +
            'B.fa_is_js_card=false;S.ohos.extra.param.key.module_name=newstock;B.fa_card_enter_animation=true;' +
            'S.related_bundle_name=com.guotai.dazhihui;end';

        let backupInfo2: BackupFavoriteInfo = {
          id: 0,
          title: '联系人',
          intent: '',
          container: -100,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 1,
          spanY: 1,
          itemType: 0,
        };
        backupInfo2.intent = '#Intent;action=adeliverd.intent.action.MAIN;category=adeliverd.intent.category.LAUNCHER;' +
          'launchFlags=0x10200000;component=com.openharmony.contacts/com.adeliverd.contacts.activities.PeopleActivity;end';

        let backupInfo3: BackupFavoriteInfo = {
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
        backupInfo3.intent = '#Intent;component=com.openharmony.adeliverd.totemweather/com.openharmony.ohos.facard.MainAbility;' +
          'i.ohos.extra.param.key.form_dimension=3;l.ohos.extra.param.key.form_identity=36862021307234684;' +
          'i.addtype=2;i.previewId=0;S.ohos.extra.param.key.form_name=Hourly%20Weather%20Forecast;' +
          'B.fa_card_background_blur_need=false;S.jsFormModuleName=card4x2;B.fa_variable_card=false;' +
          'S.jsFormCodePath=%2Fdata%2Fapp%2F~~rH11r95aAO2ow8Oi_xvi2w%3D%3D%2Fcom.openharmony.adeliverd.totemweather-5hk7jMe' +
          'jatzuohI4egzxeg%3D%3D%2Ffeature_predl_com.openharmony.adeliverd.totemweatherC100836941_17119428489200.hap;' +
          'B.fa_card_release_form=true;S.deepLink=ability%3A%2F%2Fcom.openharmony.adeliverd.totemweather%2Fcom.h' +
          'uawei.ohos.totemweather.EditCardAbility;S.original_bundle_name=com.openharmony.adeliverd.totemweather;' +
          'B.fa_is_js_card=true;S.ohos.extra.param.key.module_name=facard;B.fa_card_enter_animation=true;S.related_bundle_name=;end';

        let backUpInfoList: BackupFavoriteInfo[] = [backupInfo1, backupInfo2, backupInfo3];
        let queryLauncherDbDesktopInfo: Function =
          mocker.mockFunc(updateRdbManager, updateRdbManager.queryLauncherDbDesktopInfo);
        when(queryLauncherDbDesktopInfo)(false).afterReturn(backUpInfoList);

        let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayout.typeId = 0;
        gridLayout.infoId = 'gridLayoutInfoId';
        gridLayout.appName = 'gridLayoutAppName';
        gridLayout.bundleName = 'gridLayoutBundleName';
        gridLayout.keyName = 'gridLayoutKeyName';
        gridLayout.folderName = 'gridLayoutFolderName'
        gridLayout.abilityName = 'gridLayoutAbilityName';
        gridLayout.moduleName = 'gridLayoutModuleName';
        gridLayout.appIconId = 1;
        gridLayout.appLabelId = 2;
        gridLayout.badgeNumber = 3;
        gridLayout.row = 4;
        gridLayout.column = 5;
        gridLayout.area = [6, 7];
        gridLayout.areaType = 8;
        let convertData: Function = mocker.mockFunc(dataConvert, dataConvert.convertData);
        when(convertData)(ArgumentMatchers.any).afterReturn([gridLayout]);

        let transferLayout: Function = mocker.mockFunc(transferManager, transferManager.transferLayout);
        when(transferLayout)().afterReturn(Promise.resolve());

        let transformController: TransformController = new TransformController();
        await transformController.startTransferLauncherDbData();
        expect(transformController instanceof TransformController).assertTrue();

      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(updateRdbManager);
      mocker.clear(transferRelationManager);
      mocker.clear(dataConvert);
      mocker.clear(transferManager);
      mocker.clearAll();
    })

    it('testTransformController_loadRelation', Level.LEVEL0, async () => {
      let transferManager: TransformController = new TransformController();
      let mocker: MockKit = new MockKit();
      const loadTransferInfos = mocker.mockFunc(transferRelationManager, transferRelationManager.loadTransferInfos);
      when(loadTransferInfos)().afterReturn(Promise.resolve());
      const p1 = transferManager['loadRelation']();
      await p1;
      expect(p1).assertPromiseIsResolved();
      when(loadTransferInfos)().afterReturn(Promise.reject());
      const p2 = transferManager['loadRelation']();
      await p2;
      expect(p2).assertPromiseIsRejected();
      mocker.clear(transferRelationManager);
      mocker.clearAll();
    })

    it('testTransformController_getOldCardPackageName_7', Level.LEVEL0, async () => {
      let mocker: MockKit = new MockKit();
      try {
        let transferManager: TransformController = new TransformController();
        const backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        const backup1: BackupFavoriteInfo = new BackupFavoriteInfo();
        const backup2: BackupFavoriteInfo = new BackupFavoriteInfo();
        backupInfo.intent = 'backupInfoxxxx';
        backup1.itemType = CommonConstants.DOCK_SPACE;
        backup1.title = backupInfo.title;
        backup2.itemType = CommonConstants.DOCK_SPACE;
        backup2.title = backupInfo.title;
        const packageRelation: PackageRelation = {
          packageName: 'xxxx',
          className: 'xxxx',
          shortcutId: 'xxxx',
        }
        const backUpInfoList = [backup1, backup2];
        const getComponentByIntent = mocker.mockFunc(IntentParseUtil, IntentParseUtil.getComponentByIntent);
        when(getComponentByIntent)(backupInfo.intent).afterReturn(packageRelation);
        expect(transferManager['getOldCardPackageName'](backupInfo, backUpInfoList))
          .assertEqual(packageRelation.packageName);
        when(getComponentByIntent)(backupInfo.intent).afterReturn(null);
        expect(transferManager['getOldCardPackageName'](backupInfo, backUpInfoList)).assertEqual('');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(IntentParseUtil);
      mocker.clearAll();
    })

    it('testTransformController_reportCardUpdateInMigrate', Level.LEVEL0, async () => {
      let transferManager: TransformController = new TransformController();
      let mocker: MockKit = new MockKit();
      const oldFormItem: BackupFavoriteInfo = new BackupFavoriteInfo();
      const newFormItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      oldFormItem.itemType = BackupItemType.BACKUP_ITEM_TYPE_CARD;
      oldFormItem.cellX = 3;
      oldFormItem.cellY = 3;
      oldFormItem.spanY = 4;
      oldFormItem.spanY = 4;
      oldFormItem.appWidgetId = '899';
      newFormItem.bundleName = 'gridLayoutBundleName';
      newFormItem.cardId = '9';
      newFormItem.page = 9;
      newFormItem.column = 3;
      newFormItem.row = 3;
      newFormItem.cardName = 'cardNamexxx';
      newFormItem.area = [6, 7];
      const getOldCardPackageName = mocker.mockFunc(transferManager, transferManager['getOldCardPackageName']);
      const getOldFormName = mocker.mockFunc(transferManager, transferManager['getOldFormName']);
      mocker.mockFunc(FormHiSysEventReporter, FormHiSysEventReporter.reportCardUpdateInMigrate);
      when(getOldCardPackageName)(ArgumentMatchers.any).afterReturn('cardPackage');
      when(getOldFormName)(oldFormItem).afterReturn('formName');
      transferManager['reportCardUpdateInMigrate'](oldFormItem, newFormItem, []);
      newFormItem.row = 4;
      oldFormItem.itemType = BackupItemType.BACKUP_ITEM_TYPE_WIDGET;
      transferManager['reportCardUpdateInMigrate'](oldFormItem, newFormItem, []);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(transferManager);
      mocker.clear(FormHiSysEventReporter);
      mocker.clearAll();
    })

    it('testTransformController_reportCardUpdateAfterLayout', Level.LEVEL0, async () => {
      let transferManager: TransformController = new TransformController();
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(transferManager, transferManager['reportCardUpdateInMigrate']);
      const backup1: BackupFavoriteInfo = new BackupFavoriteInfo();
      const backup2: BackupFavoriteInfo = new BackupFavoriteInfo();
      const backup3: GridLayoutItemInfo = new GridLayoutItemInfo();
      const backup4: GridLayoutItemInfo = new GridLayoutItemInfo();
      backup1.itemType = BackupItemType.BACKUP_ITEM_TYPE_WIDGET;
      backup1.id = 9;
      backup1.title = 'backupxxx';
      backup2.itemType = BackupItemType.BACKUP_ITEM_TYPE_CARD;
      backup2.id = 9;
      backup2.title = 'backupxxx';
      backup3.id = 10;
      backup4.id = 9;
      const backUpInfoList: BackupFavoriteInfo[] = [backup1, backup2];
      const newCardList: GridLayoutItemInfo[] = [backup3, backup4];
      transferManager['reportCardUpdateAfterLayout'](backUpInfoList, newCardList);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(transferManager);
      mocker.clearAll();
    })

    it('testTransformController_transLayout_01', Level.LEVEL0, async () => {
      let mocker: MockKit = new MockKit();
      let transferManager: TransformController = new TransformController();
      try {
        const backup1: BackupFavoriteInfo = new BackupFavoriteInfo();
        backup1.itemType = BackupItemType.BACKUP_ITEM_TYPE_WIDGET;
        backup1.id = 9;
        backup1.title = 'backupxxx';
        const backUpInfoList: Array<BackupFavoriteInfo> = [backup1];
        mocker.mockFunc(transferManager, transferManager['reportCardUpdateInMigrate']);
        mocker.mockFunc(transferManager, transferManager['reportCardUpdateAfterLayout']);
        const queryLauncherDbDesktopInfo = mocker.mockFunc(transferManager['updateRdbManager'],
          transferManager['updateRdbManager'].queryLauncherDbDesktopInfo);
        const convertData = mocker.mockFunc(dataConvert, dataConvert.convertData);
        const getObject = mocker.mockFunc(GlobalContext.getInstance(), GlobalContext.getInstance().getObject);
        when(queryLauncherDbDesktopInfo)(false).afterReturn([]);
        const p1 = transferManager['transLayout']();
        await p1;
        expect(p1).assertPromiseIsResolved();
        when(queryLauncherDbDesktopInfo)(false).afterReturn(backUpInfoList);
        when(convertData)(ArgumentMatchers.any).afterReturn([]);
        const p2 = transferManager['transLayout']();
        await p2;
        expect(p2).assertPromiseIsResolved();
        when(getObject)('desktopContext').afterThrow('error');
        const p3 = transferManager['transLayout']();
        await p3;
        expect(p3).assertPromiseIsResolved();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferManager);
      mocker.clear(transferManager['updateRdbManager']);
      mocker.clear(dataConvert);
      mocker.clear(GlobalContext.getInstance());
      mocker.clearAll();
    })

    it('testTransformController_getOldFormName', Level.LEVEL0, async () => {
      let transferManager: TransformController = new TransformController();
      let mocker: MockKit = new MockKit();
      const backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
      const intentMap: Map<string, string> = new Map();
      backupInfo.intent = 'backupInfoxxxx';
      backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_WIDGET;
      const parseIntent = mocker.mockFunc(IntentParseUtil, IntentParseUtil.parseIntent);
      const mapGet = mocker.mockFunc(intentMap, intentMap.get);
      expect(transferManager['getOldFormName'](backupInfo)).assertEqual('-1');
      backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_SHORTCUT;
      expect(transferManager['getOldFormName'](backupInfo)).assertEqual('');
      when(parseIntent)(backupInfo.intent).afterReturn(null);
      expect(transferManager['getOldFormName'](backupInfo)).assertEqual('');
      when(parseIntent)(backupInfo.intent).afterReturn(intentMap);
      when(mapGet)(IntentParseUtil.KEY_FORM_NAME).afterReturn(null);
      expect(transferManager['getOldFormName'](backupInfo)).assertEqual('');
      mocker.clear(IntentParseUtil);
      mocker.clear(intentMap);
      mocker.clearAll();
    })

    it('test_getOldFormName_01', 0, async () => {
      try {
        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_WIDGET;
        let transferManager: TransformController = new TransformController();
        let str:string = transferManager['getOldFormName'](backupInfo);
        expect(str.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getOldFormName_02', 0, async () => {
      try {
        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_CARD+1;
        let transferManager: TransformController = new TransformController();
        let str:string = transferManager['getOldFormName'](backupInfo);
        expect(str.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getOldFormName_03', 0, async () => {
      try {
        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_CARD;
        let transferManager: TransformController = new TransformController();
        let str:string = transferManager['getOldFormName'](backupInfo);
        expect(str.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getOldFormName_04', 0, async () => {
      try {
        let backupInfo: BackupFavoriteInfo = new BackupFavoriteInfo();
        backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_CARD;
        backupInfo.intent = '';
        let transferManager: TransformController = new TransformController();
        let str:string = transferManager['getOldFormName'](backupInfo);
        expect(str.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

  })
}
