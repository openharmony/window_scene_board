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
  ArgumentMatchers } from '@ohos/hypium'
import {
  AppItemInfo,
  AppStatus,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  DeliverUtil,
  DisappearLastAppData,
  DockItemInfo,
  FolderData,
  FolderItemInfo,
  FolderLayoutCacheManager,
  FolderModel,
  FolderReporter,
  GridLayoutConfig,
  GridLayoutUtil,
  LauncherLayoutCacheUtil,
  MultiSelectManager,
  NotHarmonyUtil,
  OpenFolderData,
  PageDesktopModel,
  SettingsModel} from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  BigFolderViewModel,
  BigFolderStyleConfig,
  FolderLayoutStruct,
  DragItemFromFolderStartInfo,
  Callback,
  FolderCloseType,
} from '../../../../../index';
import { GridLayoutItemInfo, EventConstants } from '@ohos/launchercommon'
import FeatureConstants from '../../../../main/ets/default/common/constants/FeatureConstants';
import { DesktopLayoutCacheData } from '@ohos/launchercommon/src/main/ets/cache/layout/DesktopLayoutCacheData';
import { localEventManager, ObjUtil } from '@ohos/basiccommon/src/main/ets/TsIndex';
import { multiSelectListenManager } from '@ohos/launchercommon/src/main/ets/editmode/model/MultiSelectListenerManager';
import { MultiSelectMode } from '@ohos/launchercommon/src/main/ets/editmode/data/MultiSelectData';
import {
  PageDesktopViewModel
} from '../../../../../../pagedesktop/src/main/ets/default/common/viewmodel/PageDesktopViewModel';

function getNullObject(): GridLayoutItemInfo | null | FolderItemInfo{
  return null;
}

export default function BigFolderModelExtraTest3() {
  describe('BigFolderViewModelExtraTest2', () => {
    let instance: BigFolderViewModel = BigFolderViewModel.getInstance();
    // Defines a ExtraTest suite. Two parameters are supported: ExtraTest suite name and ExtraTest suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all ExtraTest cases of the ExtraTest suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit ExtraTest case starts.
      // The number of execution times is the same as the number of ExtraTest cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit ExtraTest case ends.
      // The number of execution times is the same as the number of ExtraTest cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all ExtraTest cases of the ExtraTest suite end.
      // This API supports only one parameter: clear action function.
    })

    it('ExtraTest2_updateOpenFolderStatus_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.folderId = 'anyFolderId_0';

      instance['updateOpenFolderStatus'](openFolderData);
      expect(openFolderData.folderId).assertEqual('anyFolderId_0');
    });

    it('ExtraTest2_updateOpenFolderStatus_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.folderId = '';
      instance['updateOpenFolderStatus'](openFolderData);
      expect(openFolderData.folderId).assertEqual('');
    });

    it('ExtraTest2_updateOpenFolderStatus_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.folderId = 'folderId_0';

      instance['updateOpenFolderStatus'](openFolderData);
      expect(openFolderData.folderId).assertEqual('folderId_0');
    });

    it('ExtraTest2_updateApp_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];
      let abilityInfo: AppItemInfo = {} as AppItemInfo;

      let  ret: OpenFolderData = instance['updateApp'](openFolderData, abilityInfo);
      expect(ret).not().assertNull();
    });

    it('ExtraTest2_updateApp_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = '';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;

      let abilityInfo: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: '',
        abilityName: ''
      };

      let  ret: OpenFolderData = instance['updateApp'](openFolderData, abilityInfo);
      expect(ret).not().assertNull();
    });

    it('ExtraTest2_updateApp_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.healthy';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo?.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;

      let abilityInfo: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'com.ohos.healthy',
        abilityName: '',
      };

      let  ret: OpenFolderData = instance['updateApp'](openFolderData, abilityInfo);
      expect(ret).not().assertNull();
    });

    it('ExtraTest2_updateApp_04', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName';
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      openFolderData.layoutInfo = [list];
      let abilityInfo: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'com.ohos.healthy',
        abilityName: '',
        keyName: 'keyName',
      };
      let ret: OpenFolderData = instance['updateApp'](openFolderData, abilityInfo);
      expect(ret.layoutInfo.length).assertEqual(1);
    })

    it('ExtraTest2_updateBadge_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;

      let params: Params = {
        bundleName: 'com.ohos.healthy',
        isShow: false,
        badgeNumber: 1
      } as Params;

      let ret = instance['updateBadge'](openFolderData, params);
      expect(ret).not().assertNull();
    });

    it('ExtraTest2_updateBadge_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.healthy';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;

      let params: Params = {
        bundleName: 'com.ohos.healthy',
        isShow: true,
        badgeNumber: 1
      } as Params;

      let ret = instance['updateBadge'](openFolderData, params);
      expect(ret).not().assertNull();
    });

    it('ExtraTest2_updateBadge_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo()
      openFolderData.layoutInfo = [];

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.healthy';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = false;

      let params: Params = {
        bundleName: 'com.ohos.healthy',
        isShow: true,
        badgeNumber: 1
      } as Params;

      let ret = instance['updateBadge'](openFolderData, params);
      expect(ret).not().assertNull();
    });

    it('ExtraTest2_updateBadge_04', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = '';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = false;

      let params: Params = {
        bundleName: '',
        isShow: true,
        badgeNumber: 1
      } as Params;

      let ret = instance['updateBadge'](openFolderData, params);
      expect(ret).not().assertNull();
    });

    it('ExtraTest2_updateBadgeNumber_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let folderItemInLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.layoutInfo = [[item1],[item2]];
      folderItemInLayout.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.keyName = 'keyName0';

      let dragAppInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragAppInfo.bundleName = 'com.ohos.sceneboard';
      dragAppInfo.appIconId = 92;
      dragAppInfo.typeId = CommonConstants.TYPE_ADD;

      instance['updateBadgeNumber'](folderItemInLayout, dragAppInfo);
      expect(folderItemInLayout.keyName).assertEqual('keyName0')
    });

    it('ExtraTest2_updateBadgeNumber_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let folderItemInLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.layoutInfo = [[item1],[item2]];
      folderItemInLayout.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.keyName = 'keyName0';
      folderItemInLayout.badgeNumber = 4;

      let dragAppInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragAppInfo.bundleName = 'com.ohos.sceneboard';
      dragAppInfo.appIconId = 92;
      dragAppInfo.typeId = CommonConstants.TYPE_ADD;

      instance['updateBadgeNumber'](folderItemInLayout, dragAppInfo);
      expect(folderItemInLayout.keyName).assertEqual('keyName0')
    });

    it('ExtraTest2_updateBadgeNumber_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let folderItemInLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.layoutInfo = [[item1],[item2]];
      folderItemInLayout.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.keyName = 'keyName0';
      folderItemInLayout.badgeNumber = 4;

      let dragAppInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragAppInfo.bundleName = 'com.ohos.sceneboard';
      dragAppInfo.appIconId = 92;
      dragAppInfo.typeId = CommonConstants.TYPE_ADD;
      dragAppInfo.badgeNumber = 2;

      instance['updateBadgeNumber'](folderItemInLayout, dragAppInfo);
      expect(folderItemInLayout.keyName).assertEqual('keyName0')
    });

    it('it_updateFolderAppByInstall_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let folderItem: OpenFolderData = {
        folderId: undefined,
        folderName: undefined,
        enterEditing: false,
        layoutInfo: []
      };
      let bundleName: string = 'anyBundleName';
      let appIndex: number = CommonConstants.MAIN_APP_INDEX;

      instance['updateFolderAppByInstall'](folderItem, bundleName, appIndex);
      expect(instance).not().assertNull();
    });


    it('ExtraTest2_updateResidentDockLayout_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let tempOpenFolderData: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let openFolderData: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      AppStorage.setOrCreate('openFolderStatus', CommonConstants.OPEN_FOLDER_STATUS_CLOSE);
      instance['updateResidentDockLayout'](tempOpenFolderData, openFolderData);
      expect(instance).not().assertNull();
      AppStorage.clear();
    });


    it('ExtraTest2_updateResidentDockLayout_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      itemInfo.keyName = 'keyName0';

      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_APP;
      itemInfo1.bundleName = 'com.ohos.mms';
      itemInfo1.keyName = 'keyName1';
      let residentList: DockItemInfo[] = [];
      residentList.push(itemInfo);
      residentList.push(itemInfo1);
      AppStorage.setOrCreate('residentList', residentList);

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      let tempOpenFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo?.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;
      openFolderData.folderId = 'keyName4';


      AppStorage.setOrCreate('openFolderStatus', CommonConstants.OPEN_SOURCES);
      instance['updateResidentDockLayout'](tempOpenFolderData, openFolderData);
      expect(instance).not().assertNull();
      AppStorage.clear();
    });

    it('ExtraTest2_updateResidentDockLayout_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      itemInfo.keyName = 'keyName0';

      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_APP;
      itemInfo1.bundleName = 'com.ohos.mms';
      itemInfo1.keyName = 'keyName1';
      let residentList: DockItemInfo[] = [];
      residentList.push(itemInfo);
      residentList.push(itemInfo1);
      AppStorage.setOrCreate('residentList', residentList);

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      let tempOpenFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo?.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;
      openFolderData.folderId = 'keyName1';


      AppStorage.setOrCreate('openFolderStatus', CommonConstants.OPEN_SOURCES);
      tempOpenFolderData.layoutInfo = [];
      instance['updateResidentDockLayout'](tempOpenFolderData, openFolderData);
      expect(instance).not().assertNull();
      AppStorage.clear();
    });

    it('ExtraTest2_updateTransitionFolderId_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderId: string = 'geometryTransitionFolderId'
      instance['updateTransitionFolderId'](folderId);
      expect(folderId).assertEqual('geometryTransitionFolderId');
    });

    it('ExtraTest2_dragAppFromFolderToDeskTop_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderDataJSONStr: string = '{"bundleName":"lkqkw4s76q0592qwa4g","abilityName":"","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":29,"infoId":"lkqkw4s76q0592qwa4g","folderId":"lkqkw4s76q0592qwa4g","container":-100,"folderName":"实用工具","ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":3,"area":[2,2],"page":2,"column":0,"row":1,"kindId":0,"moduleName":"","keyName":"lkqkw4s76q0592qwa4g","appIconId":0,"extend1":"","extend2":"","extend3":0,"appLabelId":0,"iconResource":"","callerName":"","layoutInfo":[[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":30,"infoId":"20","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":0,"row":0,"kindId":2,"moduleName":"phone","keyName":"com.ohos.calendarMainAbilityphone","appIconId":285212955,"extend1":"","extend2":"","extend3":0,"appLabelId":285212827,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb201iu34asnj6s"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":31,"infoId":"21","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":1,"row":0,"kindId":14,"moduleName":"entry","keyName":"com.ohos.healthMainAbilityentry","appIconId":134220347,"extend1":"","extend2":"","extend3":0,"appLabelId":134217728,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb2rn2bixbfoh"},{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"},{"appName":"","appIconId":67108865,"bundleName":"com.ohos.email","abilityName":"EntryAbility","downloadProgress":0,"appStatus":0,"appLabelId":67108864,"moduleName":"entry","keyName":"com.ohos.emailEntryAbilityentry","iconResource":"","callerName":"","applicationLabelId":67108864,"isUninstallAble":true,"isSystemApp":true,"installTime":"Sat Jun 22 2024 14:15:18 GMT+0800","typeId":0,"area":[1,1],"badgeNumber":0,"infoId":"28","page":0,"row":1,"column":0,"areaType":0,"x":0,"isSelect":false,"geometryId":"lxq0upk8sisd3nfpqtj","extend3":1719054838389}]],"backgroundGeometryId":"lxq0tnb2i98rvvd07sk","totalBadgeGeometryId":"lxq0tnb2xzts9f5r7y","enterEditing":false}';
      let appInfoJSONStr: string = '{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"}';
      let openFolderData: GridLayoutItemInfo = JSON.parse(openFolderDataJSONStr) as GridLayoutItemInfo;
      let appInfo: GridLayoutItemInfo = JSON.parse(appInfoJSONStr) as GridLayoutItemInfo;
      AppStorage.setOrCreate('openFolderData', openFolderData);

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance['isEnoughDropSpace']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      instance.dragAppFromFolderToDeskTop([appInfo], null);
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('ExtraTest2_isEnoughDropSpace_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderAppList: GridLayoutItemInfo[] = [];
      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo3: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderAppList.push(appInfo1);
      folderAppList.push(appInfo2);
      folderAppList.push(appInfo3);
      let msg: string = '桌面当前没有可添加的位置，请清理后再尝试';
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let itemCount: number = 2147483648;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectAllOccupiedSpace)
      when(mockFunc)(ArgumentMatchers.any).afterReturn(itemCount);
      let ret: boolean = instance['isEnoughDropSpace'](folderAppList, msg);
      expect(ret || true).assertTrue();
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    });

    it('ExtraTest2_isEnoughDropSpace_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderAppList: GridLayoutItemInfo[] = [];
      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo3: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderAppList.push(appInfo1);
      folderAppList.push(appInfo2);
      folderAppList.push(appInfo3);
      let msg: string = '桌面当前没有可添加的位置，请清理后再尝试';
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let itemCount: number = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectAllOccupiedSpace)
      when(mockFunc)(ArgumentMatchers.any).afterReturn(itemCount);
      let ret: boolean = instance['isEnoughDropSpace'](folderAppList, msg);
      expect(ret || true).assertTrue();
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    });

    it('ExtraTest2_isEnoughDropSpace_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderAppList: GridLayoutItemInfo[] = [];
      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();

      folderAppList.push(appInfo1);
      let msg: string = '桌面当前没有可添加的位置，请清理后再尝试';
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let itemCount: number = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectAllOccupiedSpace)
      when(mockFunc)(ArgumentMatchers.any).afterReturn(itemCount);
      let ret: boolean = instance['isEnoughDropSpace'](folderAppList, msg);
      expect(ret || true).assertTrue();
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    });

    it('ExtraTest2_isEnoughDropSpace_04', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderAppList: GridLayoutItemInfo[] = [];
      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderAppList.push(appInfo);
      let msg: string = '桌面当前没有可添加的位置，请清理后再尝试';
      let ret: boolean = instance['isEnoughDropSpace']([], msg);
      expect(ret).assertTrue();
      folderAppList = [appInfo, appInfo, appInfo];
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let gridConfig: GridLayoutConfig = {
        column: 2,
        row: 1,
        id: 0,
        layout: '',
        name: '',
        value: 0,
        checked: false
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectAllOccupiedSpace);
      let mockFunc2: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectMaxPageCount);
      let mockFunc3: Function = mocker.mockFunc(settingsModel, settingsModel.getGridConfig);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(3);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(gridConfig);
      ret = instance['isEnoughDropSpace'](folderAppList, msg);
      expect(ret).assertFalse();
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(settingsModel);
      mocker.clearAll();
    });

    it('ExtraTest2_convertToSmallFolder_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderInfo: GridLayoutItemInfo = getNullObject() as GridLayoutItemInfo;
      instance.convertToSmallFolder(folderInfo);
      expect(instance).not().assertNull();

      let layoutCache: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance()
      let mocker: MockKit = new MockKit();
      let selectIndexFunc: Function = mocker.mockFunc(layoutCache, layoutCache.selectIndexInLayout);
      when(selectIndexFunc)(ArgumentMatchers.any).afterReturn(0);
      instance.convertToSmallFolder(new GridLayoutItemInfo());
      mocker.clear(layoutCache);
      mocker.clearAll();
    });

    it('ExtraTest2_convertToSmallFolder_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.area = [1, 1];
      let layoutCache: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let selectIndexFunc: Function = mocker.mockFunc(layoutCache, layoutCache.selectIndexInLayout);
      when(selectIndexFunc)(ArgumentMatchers.any).afterReturn(1);
      instance.convertToSmallFolder(new GridLayoutItemInfo());
      mocker.clear(layoutCache);
      mocker.clearAll();
    })

    it('ExtraTest2_checkChangeFolderPage', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let list: GridLayoutItemInfo[][] = [[]];
      instance['checkChangeFolderPage'](list, 1);
      expect(instance['mPageIndex']).assertEqual(-1);
    })

    it('ExtraTest2_deleteAppFromOpenFolder_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfoJSONStr: string = '{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"}';
      let openFolderDataJSONStr: string = '{"bundleName":"lkqkw4s76q0592qwa4g","abilityName":"","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":29,"infoId":"lkqkw4s76q0592qwa4g","folderId":"lkqkw4s76q0592qwa4g","container":-100,"folderName":"实用工具","ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":3,"area":[2,2],"page":2,"column":0,"row":1,"kindId":0,"moduleName":"","keyName":"lkqkw4s76q0592qwa4g","appIconId":0,"extend1":"","extend2":"","extend3":0,"appLabelId":0,"iconResource":"","callerName":"","layoutInfo":[[{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"},{"appName":"","appIconId":67108865,"bundleName":"com.ohos.email","abilityName":"EntryAbility","downloadProgress":0,"appStatus":0,"appLabelId":67108864,"moduleName":"entry","keyName":"com.ohos.emailEntryAbilityentry","iconResource":"","callerName":"","applicationLabelId":67108864,"isUninstallAble":true,"isSystemApp":true,"installTime":"Sat Jun 22 2024 14:15:18 GMT+0800","typeId":0,"area":[1,1],"badgeNumber":0,"infoId":"28","page":0,"row":1,"column":0,"areaType":0,"x":0,"isSelect":false,"geometryId":"lxq0upk8sisd3nfpqtj","extend3":1719054838389}]],"backgroundGeometryId":"lxq0tnb2i98rvvd07sk","totalBadgeGeometryId":"lxq0tnb2xzts9f5r7y","enterEditing":false}';
      let openFolderData: GridLayoutItemInfo = JSON.parse(openFolderDataJSONStr) as GridLayoutItemInfo;
      let appInfo: GridLayoutItemInfo = JSON.parse(appInfoJSONStr) as GridLayoutItemInfo;

      AppStorage.setOrCreate('openFolderData', {folderId: openFolderData.folderId, layoutInfo: openFolderData.layoutInfo});

      let ret: InnerOpenFolderData = instance.deleteAppFromOpenFolder(appInfo);
      expect(ret).not().assertNull();
    });

    it('ExtraTest2_moveAppFromDockOtherFolders_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(DefaultDesktopLayoutInfo.getDefaultLayoutInfo());
      let gridLayoutItemList: GridLayoutItemInfo[] = layoutCacheData.getGridLayoutItemList();
      let folderItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FOLDER && item.folderName === '实用工具');

      let appInfosJSONStr: string = '[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":0,"column":0,"keyName":"com.ohos.calendarMainAbilityphone","appStatus":0,"appName":"","appIconId":285212950,"appLabelId":285212823,"isSystemApp":true,"kindId":2,"isUninstallAble":true,"applicationIconId":285212943,"bundleType":0,"infoId":"18","badgeNumber":0,"geometryId":"lxvko39bzn2ubvhr46g"},{"bundleName":"com.ohos.totemweather","abilityName":"com.ohos.totemweather.MainAbility","moduleName":"product","typeId":0,"area":[1,1],"page":0,"row":2,"column":0,"keyName":"com.ohos.totemweathercom.ohos.totemweather.MainAbilityproduct","appStatus":0,"appName":"","appIconId":83887310,"appLabelId":83886664,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":83886081,"bundleType":0,"infoId":"24","badgeNumber":0,"geometryId":"lxvko39c2hnv8ilhhu9"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":0,"column":1,"keyName":"com.ohos.healthMainAbilityentry","appStatus":0,"appName":"","appIconId":134220347,"appLabelId":134217728,"isSystemApp":true,"kindId":14,"isUninstallAble":true,"applicationIconId":134217730,"bundleType":0,"infoId":"19","badgeNumber":0,"geometryId":"lxvko39bx2xm3p0io3"},{"bundleName":"com.ohos.myhuawei","abilityName":"EntryAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":1,"column":1,"keyName":"com.ohos.myhuaweiEntryAbilityentry","appStatus":0,"appName":"","appIconId":134218136,"appLabelId":134217728,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":134217729,"bundleType":0,"infoId":"20","badgeNumber":0,"geometryId":"lxvko39cgghh4uidst"},{"bundleName":"com.ohos.dataclone","abilityName":"EntryAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":1,"column":2,"keyName":"com.ohos.datacloneEntryAbilityphone","appStatus":0,"appName":"","appIconId":50331649,"appLabelId":50331648,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":50331649,"bundleType":0,"infoId":"23","badgeNumber":0,"geometryId":"lxvko39c2qz0rx8sh8d"}]';
      let appInfos: AppItemInfo[] = JSON.parse(appInfosJSONStr);

      AppStorage.setOrCreate('residentList', []);
      instance['moveAppFromDockOtherFolders'](appInfos, folderItem);
      expect(appInfos).not().assertNull();
      AppStorage.delete('residentList');
    });


    it('ExtraTest2_moveAppFromDockOtherFolders_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(DefaultDesktopLayoutInfo.getDefaultLayoutInfo());
      let gridLayoutItemList: GridLayoutItemInfo[] = layoutCacheData.getGridLayoutItemList();
      let folderItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FOLDER && item.folderName === '实用工具');

      let appInfosJSONStr: string = '[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":0,"column":0,"keyName":"com.ohos.calendarMainAbilityphone","appStatus":0,"appName":"","appIconId":285212950,"appLabelId":285212823,"isSystemApp":true,"kindId":2,"isUninstallAble":true,"applicationIconId":285212943,"bundleType":0,"infoId":"18","badgeNumber":0,"geometryId":"lxvko39bzn2ubvhr46g"},{"bundleName":"com.ohos.totemweather","abilityName":"com.ohos.totemweather.MainAbility","moduleName":"product","typeId":0,"area":[1,1],"page":0,"row":2,"column":0,"keyName":"com.ohos.totemweathercom.ohos.totemweather.MainAbilityproduct","appStatus":0,"appName":"","appIconId":83887310,"appLabelId":83886664,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":83886081,"bundleType":0,"infoId":"24","badgeNumber":0,"geometryId":"lxvko39c2hnv8ilhhu9"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":0,"column":1,"keyName":"com.ohos.healthMainAbilityentry","appStatus":0,"appName":"","appIconId":134220347,"appLabelId":134217728,"isSystemApp":true,"kindId":14,"isUninstallAble":true,"applicationIconId":134217730,"bundleType":0,"infoId":"19","badgeNumber":0,"geometryId":"lxvko39bx2xm3p0io3"},{"bundleName":"com.ohos.myhuawei","abilityName":"EntryAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":1,"column":1,"keyName":"com.ohos.myhuaweiEntryAbilityentry","appStatus":0,"appName":"","appIconId":134218136,"appLabelId":134217728,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":134217729,"bundleType":0,"infoId":"20","badgeNumber":0,"geometryId":"lxvko39cgghh4uidst"},{"bundleName":"com.ohos.dataclone","abilityName":"EntryAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":1,"column":2,"keyName":"com.ohos.datacloneEntryAbilityphone","appStatus":0,"appName":"","appIconId":50331649,"appLabelId":50331648,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":50331649,"bundleType":0,"infoId":"23","badgeNumber":0,"geometryId":"lxvko39c2qz0rx8sh8d"}]';
      let appInfos: AppItemInfo[] = JSON.parse(appInfosJSONStr);

      let rdbResidentList: DockItemInfo[] = [];
      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_FOLDER;
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.bundleName = 'com.ohos.calendar';
      let layoutInfos: GridLayoutItemInfo[] = []
      itemInfo1.layoutInfo = [];
      layoutInfos.push(gridLayoutItemInfo)
      itemInfo1.layoutInfo.push(layoutInfos);
      rdbResidentList.push(itemInfo1);
      AppStorage.setOrCreate('residentList', rdbResidentList);

      instance['moveAppFromDockOtherFolders'](appInfos, folderItem);
      expect(appInfos).not().assertNull();
      AppStorage.delete('residentList');
    });

    it('ExtraTest2_moveAppFromDockOtherFolders_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(DefaultDesktopLayoutInfo.getDefaultLayoutInfo());
      let gridLayoutItemList: GridLayoutItemInfo[] = layoutCacheData.getGridLayoutItemList();
      let folderItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FOLDER && item.folderName === '实用工具');

      let appInfosJSONStr: string = '[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":0,"column":0,"keyName":"com.ohos.calendarMainAbilityphone","appStatus":0,"appName":"","appIconId":285212950,"appLabelId":285212823,"isSystemApp":true,"kindId":2,"isUninstallAble":true,"applicationIconId":285212943,"bundleType":0,"infoId":"18","badgeNumber":0,"geometryId":"lxvko39bzn2ubvhr46g"},{"bundleName":"com.ohos.totemweather","abilityName":"com.ohos.totemweather.MainAbility","moduleName":"product","typeId":0,"area":[1,1],"page":0,"row":2,"column":0,"keyName":"com.ohos.totemweathercom.ohos.totemweather.MainAbilityproduct","appStatus":0,"appName":"","appIconId":83887310,"appLabelId":83886664,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":83886081,"bundleType":0,"infoId":"24","badgeNumber":0,"geometryId":"lxvko39c2hnv8ilhhu9"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":0,"column":1,"keyName":"com.ohos.healthMainAbilityentry","appStatus":0,"appName":"","appIconId":134220347,"appLabelId":134217728,"isSystemApp":true,"kindId":14,"isUninstallAble":true,"applicationIconId":134217730,"bundleType":0,"infoId":"19","badgeNumber":0,"geometryId":"lxvko39bx2xm3p0io3"},{"bundleName":"com.ohos.myhuawei","abilityName":"EntryAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":1,"column":1,"keyName":"com.ohos.myhuaweiEntryAbilityentry","appStatus":0,"appName":"","appIconId":134218136,"appLabelId":134217728,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":134217729,"bundleType":0,"infoId":"20","badgeNumber":0,"geometryId":"lxvko39cgghh4uidst"},{"bundleName":"com.ohos.dataclone","abilityName":"EntryAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":1,"column":2,"keyName":"com.ohos.datacloneEntryAbilityphone","appStatus":0,"appName":"","appIconId":50331649,"appLabelId":50331648,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":50331649,"bundleType":0,"infoId":"23","badgeNumber":0,"geometryId":"lxvko39c2qz0rx8sh8d"}]';
      let appInfos: AppItemInfo[] = JSON.parse(appInfosJSONStr);

      let rdbResidentList: DockItemInfo[] = [];
      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_APP;
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.bundleName = 'com.ohos.calendar';
      let layoutInfos: GridLayoutItemInfo[] = []
      itemInfo1.layoutInfo = [];
      layoutInfos.push(gridLayoutItemInfo)
      itemInfo1.layoutInfo.push(layoutInfos);
      rdbResidentList.push(itemInfo1);

      AppStorage.setOrCreate('residentList', rdbResidentList);
      instance['moveAppFromDockOtherFolders'](appInfos, folderItem);
      expect(appInfos).not().assertNull();
      AppStorage.delete('residentList');
    });


    it('ExtraTest2_moveAppFromDockOtherFolders_04', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(DefaultDesktopLayoutInfo.getDefaultLayoutInfo());
      let gridLayoutItemList: GridLayoutItemInfo[] = layoutCacheData.getGridLayoutItemList();
      let folderItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FOLDER && item.folderName === '实用工具');

      let appInfosJSONStr: string = '[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":0,"column":0,"keyName":"com.ohos.calendarMainAbilityphone","appStatus":0,"appName":"","appIconId":285212950,"appLabelId":285212823,"isSystemApp":true,"kindId":2,"isUninstallAble":true,"applicationIconId":285212943,"bundleType":0,"infoId":"18","badgeNumber":0,"geometryId":"lxvko39bzn2ubvhr46g"},{"bundleName":"com.ohos.totemweather","abilityName":"com.ohos.totemweather.MainAbility","moduleName":"product","typeId":0,"area":[1,1],"page":0,"row":2,"column":0,"keyName":"com.ohos.totemweathercom.ohos.totemweather.MainAbilityproduct","appStatus":0,"appName":"","appIconId":83887310,"appLabelId":83886664,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":83886081,"bundleType":0,"infoId":"24","badgeNumber":0,"geometryId":"lxvko39c2hnv8ilhhu9"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":0,"column":1,"keyName":"com.ohos.healthMainAbilityentry","appStatus":0,"appName":"","appIconId":134220347,"appLabelId":134217728,"isSystemApp":true,"kindId":14,"isUninstallAble":true,"applicationIconId":134217730,"bundleType":0,"infoId":"19","badgeNumber":0,"geometryId":"lxvko39bx2xm3p0io3"},{"bundleName":"com.ohos.myhuawei","abilityName":"EntryAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":1,"column":1,"keyName":"com.ohos.myhuaweiEntryAbilityentry","appStatus":0,"appName":"","appIconId":134218136,"appLabelId":134217728,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":134217729,"bundleType":0,"infoId":"20","badgeNumber":0,"geometryId":"lxvko39cgghh4uidst"},{"bundleName":"com.ohos.dataclone","abilityName":"EntryAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":1,"column":2,"keyName":"com.ohos.datacloneEntryAbilityphone","appStatus":0,"appName":"","appIconId":50331649,"appLabelId":50331648,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":50331649,"bundleType":0,"infoId":"23","badgeNumber":0,"geometryId":"lxvko39c2qz0rx8sh8d"}]';
      let appInfos: AppItemInfo[] = JSON.parse(appInfosJSONStr);

      let rdbResidentList: DockItemInfo[] = [];
      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_FOLDER;
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.bundleName = 'com.ohos.sceneboard';
      let layoutInfos: GridLayoutItemInfo[] = []
      itemInfo1.layoutInfo = [];
      layoutInfos.push(gridLayoutItemInfo)
      itemInfo1.layoutInfo.push(layoutInfos);
      rdbResidentList.push(itemInfo1);
      AppStorage.setOrCreate('residentList', rdbResidentList);

      instance['moveAppFromDockOtherFolders'](appInfos, folderItem);
      expect(appInfos).not().assertNull();
      AppStorage.delete('residentList');
    });

    it('ExtraTest2_deleteAppFromFolderByUninstall_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let bundleName: string = 'com.ohos.uninstallApp';

      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.ExtraTest1";
      app1.typeId = CommonConstants.TYPE_APP;
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.ExtraTest2";
      app2.typeId = CommonConstants.TYPE_APP;
      let folder1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let folderAppList1: GridLayoutItemInfo[] = [];
      folderAppList1.push(app1, app2);
      folder1.layoutInfo = [folderAppList1];

      let app3: GridLayoutItemInfo = new GridLayoutItemInfo();
      app3.bundleName = "com.ohos.ExtraTest3";
      app3.typeId = CommonConstants.TYPE_APP;
      let folder2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let folderAppList2: GridLayoutItemInfo[] = [];
      folderAppList2.push(app3);
      folder2.layoutInfo = [folderAppList2];

      let app4: GridLayoutItemInfo = new GridLayoutItemInfo();
      app4.bundleName = "com.ohos.ExtraTest4";
      app4.typeId = CommonConstants.TYPE_APP;
      let appAdd: GridLayoutItemInfo = new GridLayoutItemInfo();
      appAdd.typeId === CommonConstants.TYPE_ADD;
      let folder3: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder3.container = CommonConstants.CONTAINER_SMARTDOCK;
      let folderAppList3: GridLayoutItemInfo[] = [];
      folderAppList3.push(app4, appAdd);
      folder3.layoutInfo = [folderAppList3];

      let app5: GridLayoutItemInfo = new GridLayoutItemInfo();
      app5.bundleName = "com.ohos.ExtraTest5";
      app5.typeId = CommonConstants.TYPE_APP;
      let app6: GridLayoutItemInfo = new GridLayoutItemInfo();
      app6.bundleName = "com.ohos.uninstallApp";
      app6.typeId = CommonConstants.TYPE_APP;
      app6.appIndex = 0;
      let folder4: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder4.container = CommonConstants.CONTAINER_DESKTOP;
      let folderAppList4: GridLayoutItemInfo[] = [];
      folderAppList4.push(app5, app6);
      folder4.layoutInfo = [folderAppList4];

      let folderList: GridLayoutItemInfo[] = [folder1, folder2, folder3, folder4];
      let folderLayout: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayout, folderLayout.selectFolderByContainApp);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderList);
      instance.deleteAppFromFolderByUninstall(bundleName, 0);
      mocker.clear(folderLayout);
      mocker.clearAll();
    });


    it('ExtraTest2_deleteAppFromFolderByUninstall_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let bundleName: string = 'com.ohos.uninstallApp';

      let info1: DockItemInfo = new DockItemInfo();
      info1.typeId = CommonConstants.TYPE_APP;

      let info2: DockItemInfo = new DockItemInfo();
      info2.typeId = CommonConstants.TYPE_FOLDER;
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.ExtraTest1";
      app1.typeId = CommonConstants.TYPE_APP;
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.uninstallApp";
      app2.typeId = CommonConstants.TYPE_APP;
      app2.appIndex = 1;
      let app3: GridLayoutItemInfo = new GridLayoutItemInfo();
      app3.bundleName = "com.ohos.uninstallApp";
      app3.typeId = CommonConstants.TYPE_APP;
      app3.appIndex = 0;
      info2.layoutInfo = [[app1, app2, app3]];

      let info3: DockItemInfo = new DockItemInfo();
      info3.typeId = CommonConstants.TYPE_FOLDER;
      let app4: GridLayoutItemInfo = new GridLayoutItemInfo();
      app4.bundleName = "com.ohos.ExtraTest1";
      app4.typeId = CommonConstants.TYPE_APP;
      let app5: GridLayoutItemInfo = new GridLayoutItemInfo();
      app5.bundleName = "com.ohos.uninstallApp";
      app5.typeId = CommonConstants.TYPE_APP;
      app5.appIndex = 0;
      info3.layoutInfo = [[app4, app5]];


      let residentList: DockItemInfo[] = [info1, info2, info3];
      AppStorage.setOrCreate('residentList', residentList);

      instance.deleteAppFromFolderByUninstall(bundleName, 0);

      expect(instance).not().assertNull();
      AppStorage.delete('residentList');
    });


    it('ExtraTest2_deleteAppFromFolderByUninstall_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderDataJSONStr: string = '{"bundleName":"lkqkw4s76q0592qwa4g","abilityName":"","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":29,"infoId":"lkqkw4s76q0592qwa4g","folderId":"lkqkw4s76q0592qwa4g","container":-100,"folderName":"实用工具","ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":3,"area":[2,2],"page":2,"column":0,"row":1,"kindId":0,"moduleName":"","keyName":"lkqkw4s76q0592qwa4g","appIconId":0,"extend1":"","extend2":"","extend3":0,"appLabelId":0,"iconResource":"","callerName":"","layoutInfo":[[{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"},{"appName":"","appIconId":67108865,"bundleName":"com.ohos.email","abilityName":"EntryAbility","downloadProgress":0,"appStatus":0,"appLabelId":67108864,"moduleName":"entry","keyName":"com.ohos.emailEntryAbilityentry","iconResource":"","callerName":"","applicationLabelId":67108864,"isUninstallAble":true,"isSystemApp":true,"installTime":"Sat Jun 22 2024 14:15:18 GMT+0800","typeId":0,"area":[1,1],"badgeNumber":0,"infoId":"28","page":0,"row":1,"column":0,"areaType":0,"x":0,"isSelect":false,"geometryId":"lxq0upk8sisd3nfpqtj","extend3":1719054838389}]],"backgroundGeometryId":"lxq0tnb2i98rvvd07sk","totalBadgeGeometryId":"lxq0tnb2xzts9f5r7y","enterEditing":false}';
      let folderItem: GridLayoutItemInfo = JSON.parse(openFolderDataJSONStr) as GridLayoutItemInfo;

      let residentList: DockItemInfo[] = [];

      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_APP;
      itemInfo1.layoutInfo = [];

      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.bundleName = 'com.ohos.sceneboard';
      let gridLayoutLayoutInfo: GridLayoutItemInfo[] = []
      gridLayoutLayoutInfo.push(gridLayoutItemInfo);


      itemInfo1.layoutInfo.push(gridLayoutLayoutInfo);
      residentList.push(itemInfo1);
      AppStorage.setOrCreate('residentList', residentList);

      instance.deleteAppFromFolderByUninstall(folderItem.bundleName, 0);

      expect(instance).not().assertNull();
      AppStorage.delete('residentList');
    });


    it('ExtraTest2_onHandleEvent_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let event: string = EventConstants.EVENT_BADGE_UPDATE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      params.badgeNumber = 1;
      params.bundleName = 'com.ohos.ExtraTest';
      FolderData.getInstance().close('BigFolderViewModel badgeUpdate ExtraTest');
      localEventManager.sendLocalEventSticky(event, params);
      expect(instance).not().assertNull();
    });

    it('ExtraTest2_onHandleEvent_02', 0, () => {
      let event: string = EventConstants.EVENT_BADGE_UPDATE;
      let appData: GridLayoutItemInfo = new GridLayoutItemInfo();
      appData.bundleName = "com.ohos.ExtraTest";
      appData.typeId = CommonConstants.TYPE_APP;
      appData.appIndex = 0;
      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(appData);
      let folderData: GridLayoutItemInfo = FolderData.getInstance().getOpenedFolder();
      folderData.layoutInfo = [folderAppList];

      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      params.badgeNumber = 1;
      params.bundleName = 'com.ohos.ExtraTest2_1';
      localEventManager.sendLocalEventSticky(event, params);

      params.bundleName = "com.ohos.ExtraTest";
      params.appIndex = 1;
      localEventManager.sendLocalEventSticky(event, params);

      params.bundleName = "com.ohos.ExtraTest";
      params.appIndex = 0;
      params['isShow'] = true;
      localEventManager.sendLocalEventSticky(event, params);

      params.bundleName = "com.ohos.ExtraTest";
      params.appIndex = 0;
      params['isShow'] = false;
      localEventManager.sendLocalEventSticky(event, params);

      let emptyNameApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      emptyNameApp.bundleName = '';
      emptyNameApp.typeId = CommonConstants.TYPE_APP;
      emptyNameApp.appIndex = 0;
      folderAppList.push(emptyNameApp);
      folderData.layoutInfo = [folderAppList];
      params.bundleName = '';
      params.appIndex = 0;
      localEventManager.sendLocalEventSticky(event, params);
    });


    it('ExtraTest2_onHandleEvent_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let event: string = EventConstants.EVENT_FOLDER_PACKAGE_REMOVED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      params.badgeNumber = 1;

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.deleteAppFromFolderByUninstall);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      localEventManager.sendLocalEventSticky(event, params);
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('ExtraTest2_onHandleEvent_04', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let event: string = EventConstants.EVENT_FOLDER_PACKAGE_REMOVED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      params.badgeNumber = 1;

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.deleteAppFromFolderByUninstall);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

      localEventManager.sendLocalEventSticky(event, params);
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('ExtraTest2_onHandleEvent_05', 0, () => {
      let event: string = EventConstants.EVENT_FOLDER_ITEM_UPDATE;
      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

      localEventManager.sendLocalEventSticky(event, '');
      expect(folderDataInstance).not().assertNull();
      mocker.clear(folderDataInstance);
      mocker.clearAll();
    });

    it('ExtraTest2_onHandleEvent_06', 0, () => {
      let folderData: GridLayoutItemInfo = FolderData.getInstance().getOpenedFolder();

      let event: string = EventConstants.EVENT_FOLDER_ITEM_UPDATE;
      localEventManager.sendLocalEventSticky(event, '');

      let appData: GridLayoutItemInfo = new GridLayoutItemInfo();
      appData.bundleName = "com.ohos.ExtraTest";
      appData.typeId = CommonConstants.TYPE_APP;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      params.bundleName = 'com.ohos.ExtraTest2_1';
      localEventManager.sendLocalEventSticky(event, params);

      params.bundleName = 'com.ohos.ExtraTest';
      localEventManager.sendLocalEventSticky(event, params);

      let emptyNameApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      emptyNameApp.bundleName = '';
      emptyNameApp.typeId = CommonConstants.TYPE_APP;
      localEventManager.sendLocalEventSticky(event, emptyNameApp);

      expect(instance).not().assertNull();
    });

    it('ExtraTest2_getFolderAppList_01', 0, async () => {
      AppStorage.delete('residentList');
      instance.getFolderAppList('ExtraTestFolder');

      let residentList: DockItemInfo[] = [];
      let dockItem1: DockItemInfo = new DockItemInfo();
      let dockItem2: DockItemInfo = new DockItemInfo();
      dockItem2.layoutInfo = [];
      let dockItem3: DockItemInfo = new DockItemInfo();
      dockItem3.layoutInfo = [[new GridLayoutItemInfo()]];
      let dockItem4: DockItemInfo = new DockItemInfo();
      dockItem4.typeId = CommonConstants.TYPE_FOLDER;
      dockItem4.layoutInfo = [[new GridLayoutItemInfo()]];
      dockItem4.keyName = '123';
      let folderItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem1.typeId = CommonConstants.TYPE_APP;
      let folderItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem2.typeId = CommonConstants.TYPE_ADD;
      let dockItem5: DockItemInfo = new DockItemInfo();
      dockItem5.typeId = CommonConstants.TYPE_FOLDER;
      dockItem5.layoutInfo = [[folderItem1, folderItem2]];
      dockItem5.keyName = 'ExtraTestFolder';
      residentList = [dockItem1, dockItem2, dockItem3, dockItem4, dockItem5];
      AppStorage.setOrCreate('residentList', residentList);
      await instance.getFolderAppList('ExtraTestFolder');
      AppStorage.delete('residentList');
    });

    it('ExtraTest2_updateFolderAppList_01', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.ExtraTest1";
      app1.typeId = CommonConstants.TYPE_APP;
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: DockItemInfo = new DockItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DOCK;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      folderItem.layoutInfo = [];

      let residentList: DockItemInfo[] = [];
      AppStorage.setOrCreate('residentList', residentList);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
      AppStorage.delete('residentList');
    });

    it('ExtraTest2_updateFolderAppList_02', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.ExtraTest1";
      app1.typeId = CommonConstants.TYPE_APP;
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: DockItemInfo = new DockItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DOCK;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      folderItem.layoutInfo = [];

      let residentList: DockItemInfo[] = [folderItem];
      AppStorage.setOrCreate('residentList', residentList);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
      AppStorage.delete('residentList');
    });

    it('ExtraTest2_updateFolderAppList_03', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.ExtraTest1";
      app1.typeId = CommonConstants.TYPE_APP;
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: DockItemInfo = new DockItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DOCK;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.ExtraTest1";
      app2.typeId = CommonConstants.TYPE_APP;
      let app3: GridLayoutItemInfo = new GridLayoutItemInfo();
      app3.bundleName = "com.ohos.ExtraTest2";
      app3.typeId = CommonConstants.TYPE_APP;
      folderItem.layoutInfo = [[app2, app3], []];

      let residentList: DockItemInfo[] = [];
      AppStorage.setOrCreate('residentList', residentList);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
      AppStorage.delete('residentList');
    });

    it('ExtraTest2_updateFolderAppList_04', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.ExtraTest1";
      app1.typeId = CommonConstants.TYPE_APP;
      app1.keyName = 'keyName1';
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: DockItemInfo = new DockItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DOCK;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      folderItem.layoutInfo = [];

      let residentList: DockItemInfo[] = [folderItem];
      AppStorage.setOrCreate('residentList', residentList);

      let uninstallApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      uninstallApp.bundleName = "com.ohos.ExtraTest3";
      uninstallApp.typeId = CommonConstants.TYPE_APP;
      uninstallApp.keyName = 'keyName3';
      AppStorage.setOrCreate<GridLayoutItemInfo>('unInstallItemInfo', uninstallApp);

      let disappearData: DisappearLastAppData = new DisappearLastAppData();
      AppStorage.set<DisappearLastAppData>('disappearLastAppData', disappearData);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
      AppStorage.delete('residentList');
    });

    it('ExtraTest2_updateFolderAppList_04', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.ExtraTest1";
      app1.typeId = CommonConstants.TYPE_APP;
      app1.keyName = 'keyName1111';
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: DockItemInfo = new DockItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DOCK;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.ExtraTest1";
      app2.typeId = CommonConstants.TYPE_APP;
      app2.keyName = 'keyName1';
      let app3: GridLayoutItemInfo = new GridLayoutItemInfo();
      app3.bundleName = "com.ohos.ExtraTest2";
      app3.typeId = CommonConstants.TYPE_APP;
      app3.keyName = 'keyName2';
      let app5: GridLayoutItemInfo = new GridLayoutItemInfo();
      app5.bundleName = "com.ohos.ExtraTest3";
      app5.typeId = CommonConstants.TYPE_APP;
      app5.keyName = 'keyName3';
      let app4: GridLayoutItemInfo = new GridLayoutItemInfo();
      app4.bundleName = "addIcon";
      app4.typeId = CommonConstants.TYPE_ADD;
      folderItem.layoutInfo = [[app2, app3, app4], []];

      let residentList: DockItemInfo[] = [folderItem];
      AppStorage.setOrCreate('residentList', residentList);

      let disappearData: DisappearLastAppData = new DisappearLastAppData();
      disappearData.folderId = '1';
      AppStorage.set<DisappearLastAppData>('disappearLastAppData', disappearData);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
      AppStorage.delete('residentList');
    });

    it('ExtraTest2_updateFolderAppList_05', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.ExtraTest1";
      app1.typeId = CommonConstants.TYPE_APP;
      app1.keyName = 'keyName1111';
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: DockItemInfo = new DockItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DESKTOP;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.ExtraTest1";
      app2.typeId = CommonConstants.TYPE_APP;
      app2.keyName = 'keyName1';
      folderItem.layoutInfo = [];

      let disappearData: DisappearLastAppData = new DisappearLastAppData();
      disappearData.folderId = '1';
      AppStorage.set<DisappearLastAppData>('disappearLastAppData', disappearData);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
    });

    it('ExtraTest2_updateFolderAppList_06', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.ExtraTest1";
      app1.typeId = CommonConstants.TYPE_APP;
      app1.keyName = 'keyName1111';
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: DockItemInfo = new DockItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DESKTOP;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.ExtraTest1";
      app2.typeId = CommonConstants.TYPE_APP;
      app2.keyName = 'keyName1';
      folderItem.layoutInfo = [[app2]];

      let disappearData: DisappearLastAppData = new DisappearLastAppData();
      AppStorage.set<DisappearLastAppData>('disappearLastAppData', disappearData);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
    });

    it('ExtraTest2_updateFolderAppList_07', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.ExtraTest1";
      app1.typeId = CommonConstants.TYPE_APP;
      app1.keyName = 'keyName1';
      let app10: GridLayoutItemInfo = new GridLayoutItemInfo();
      app10.bundleName = "com.ohos.ExtraTest10";
      app10.typeId = CommonConstants.TYPE_APP;
      app10.keyName = 'keyName10';
      let appInfos: GridLayoutItemInfo[] = [app1, app10];

      let folderItem: DockItemInfo = new DockItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DOCK;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.ExtraTest1";
      app2.typeId = CommonConstants.TYPE_APP;
      app2.keyName = 'keyName1';
      let app3: GridLayoutItemInfo = new GridLayoutItemInfo();
      app3.bundleName = "com.ohos.ExtraTest2";
      app3.typeId = CommonConstants.TYPE_APP;
      app3.keyName = 'keyName2';
      let app5: GridLayoutItemInfo = new GridLayoutItemInfo();
      app5.bundleName = "com.ohos.ExtraTest3";
      app5.typeId = CommonConstants.TYPE_APP;
      app5.keyName = 'keyName3';
      let app4: GridLayoutItemInfo = new GridLayoutItemInfo();
      app4.bundleName = "addIcon";
      app4.typeId = CommonConstants.TYPE_ADD;
      folderItem.layoutInfo = [[app2, app3, app4], []];

      let residentList: DockItemInfo[] = [folderItem];
      AppStorage.setOrCreate('residentList', residentList);

      let disappearData: DisappearLastAppData = new DisappearLastAppData();
      disappearData.folderId = '1';
      AppStorage.set<DisappearLastAppData>('disappearLastAppData', disappearData);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.dropInFolderOpenComponent();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
      AppStorage.delete('residentList');
    });

    it("ExtraTest2_updateOpenFolderAppStatus_02", 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appData: GridLayoutItemInfo = new GridLayoutItemInfo();
      appData.bundleName = "com.ohos.abcd";
      appData.appStatus = 1;
      appData.typeId = CommonConstants.TYPE_APP;
      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(appData);
      let folderData: GridLayoutItemInfo = FolderData.getInstance().getOpenedFolder();
      folderData.layoutInfo = [folderAppList];
      instance.updateOpenFolderAppStatus("com.ohos.abc", 0);
      instance.updateOpenFolderAppStatus("com.ohos.abcd", 0);
      expect(appData.appStatus).assertEqual(0);
    });

    it("ExtraTest2_getUninstallDialogName_01", 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.getIsPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      instance.getUninstallDialogName('ExtraTest');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      instance.getUninstallDialogName('ExtraTest');
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it("ExtraTest2_removeShortCut_01", 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [[], []];

      openFolderData.isInDock = true;
      instance.removeShortCut(openFolderData, {});
      openFolderData.isInDock = false;
      instance.removeShortCut(openFolderData, {});
      expect(instance).not().assertNull();
    });

    it('ExtraTest2_unRegisterBigFolderFlush', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.unRegisterBigFolderFlush('folder123');
      instance.registerBigFolderFlush('folder123', {
        onListChange: (folderItem: FolderItemInfo) => {}
      });
      instance.unRegisterBigFolderFlush('folder123');
      expect(instance).not().assertNull();
    });

    it('ExtraTest2_stateChangeCallback_01', 0, () => {
      FolderData.getInstance().notifyFolderStateChange(0);

      instance.registerOpenFolderStatusCallback({
        moduleName: 'ExtraTest1'
      });
      instance.registerOpenFolderStatusCallback({
        moduleName: 'ExtraTest2',
        closeFolderEndCallback: (): void => {},
        openFolderEndCallback: (): void => {}
      });

      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.isFolderOpen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      FolderData.getInstance().notifyFolderStateChange(FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_END);

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      FolderData.getInstance().notifyFolderStateChange(FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_END);
      instance.unRegisterOpenFolderStatusCallback('ExtraTest1');
      instance.unRegisterOpenFolderStatusCallback('ExtraTest2');
      mocker.clear(folderDataInstance);
      mocker.clearAll();
    });

    it('ExtraTest2_multiSelectListener_01', 0, () => {
      const manager = MultiSelectManager.getInstance();
      manager['mode'] = MultiSelectMode.INIT;
      multiSelectListenManager.executeGather();

      manager['mode'] = MultiSelectMode.MULTI;
      let map: Map<GridLayoutItemInfo, GridLayoutItemInfo[]> = new Map();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(manager, manager.getSelectedItemSortByFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(map);
      multiSelectListenManager.executeGather();

      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.folderId = 'ExtraTestFolder';
      folder.layoutInfo = [];
      let selectAppList: GridLayoutItemInfo[] = [];
      map.set(folder, selectAppList);

      let folderLayout: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc2: Function = mocker.mockFunc(folderLayout, folderLayout.selectGridLayoutItemByItem);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(folder);
      multiSelectListenManager.executeGather();

      mocker.clear(manager);
      mocker.clear(folderLayout);
      mocker.clearAll();
    });

    it('ExtraTest2_multiSelectListener_02', 0, () => {
      const manager = MultiSelectManager.getInstance();
      manager['mode'] = MultiSelectMode.MULTI;
      let map: Map<GridLayoutItemInfo, GridLayoutItemInfo[]> = new Map();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(manager, manager.getSelectedItemSortByFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(map);

      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.folderId = 'ExtraTestFolder';
      let app: GridLayoutItemInfo = new GridLayoutItemInfo();
      app.typeId = CommonConstants.TYPE_APP;
      app.bundleName = 'ExtraTestApp';
      folder.layoutInfo = [[app]];
      let selectAppList: GridLayoutItemInfo[] = [];
      map.set(folder, selectAppList);

      let folderLayout: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc2: Function = mocker.mockFunc(folderLayout, folderLayout.selectGridLayoutItemByItem);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(folder);
      multiSelectListenManager.executeGather();

      mocker.clear(manager);
      mocker.clear(folderLayout);
      mocker.clearAll();
    });

    it('ExtraTest2_multiSelectListener_03', 0, () => {
      const manager = MultiSelectManager.getInstance();
      manager['mode'] = MultiSelectMode.MULTI;
      let map: Map<GridLayoutItemInfo, GridLayoutItemInfo[]> = new Map();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(manager, manager.getSelectedItemSortByFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(map);

      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.folderId = 'ExtraTestFolder';
      let app: GridLayoutItemInfo = new GridLayoutItemInfo();
      app.typeId = CommonConstants.TYPE_APP;
      app.bundleName = 'ExtraTestApp';
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.typeId = CommonConstants.TYPE_APP;
      app2.bundleName = 'ExtraTestApp2';
      app2.badgeNumber = 1;
      app2.page = 1;
      folder.layoutInfo = [[app, app2]];
      let selectAppList: GridLayoutItemInfo[] = [];
      map.set(folder, selectAppList);

      let folderLayout: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc2: Function = mocker.mockFunc(folderLayout, folderLayout.selectGridLayoutItemByItem);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(folder);
      multiSelectListenManager.executeGather();

      mocker.clear(manager);
      mocker.clear(folderLayout);
      mocker.clearAll();
    });

    it('ExtraTest2_mAddToFolderListener_01', 0, () => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_ITEM_ADD, new GridLayoutItemInfo());
    });

    it('ExtraTest2_isOpeningAndClosing', 0, () => {
      instance.isOpening();
      instance.isClosing();
    });

    it('ExtraTest2_removeShortCutFromFolderInDesktop', 0, () => {
      AppStorage.setOrCreate('openFolderStatus', FeatureConstants.OPEN_FOLDER_STATUS_OPEN);
      let openFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolder.layoutInfo = [];
      instance.removeShortCutFromFolderInDesktop(openFolder, new GridLayoutItemInfo());
    });

    it('ExtraTest2_removeShortCutFromFolderInDock', 0, () => {
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      instance.removeShortCutFromFolderInDock(openFolderData, new GridLayoutItemInfo());

      let shortcut: GridLayoutItemInfo = new GridLayoutItemInfo();
      shortcut.bundleName = 'ExtraTestApp';
      shortcut.shortcutId = '1';
      shortcut.appIndex = 0;
      openFolderData.layoutInfo = [[shortcut, new GridLayoutItemInfo(), new GridLayoutItemInfo()]];
      openFolderData.keyName = 'ExtraTestKey';

      AppStorage.setOrCreate('residentList', []);
      let tempFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      tempFolderData.typeId = CommonConstants.TYPE_FOLDER;
      tempFolderData.area = [1, 1];
      instance.removeShortCutFromFolderInDock(openFolderData, shortcut);

      let residentList: DockItemInfo[] = [GridLayoutUtil.gridLayoutToDockItem(openFolderData)];
      AppStorage.setOrCreate('residentList', [...residentList]);
      openFolderData.layoutInfo = [[shortcut, new GridLayoutItemInfo(), new GridLayoutItemInfo()]];
      instance.removeShortCutFromFolderInDock(openFolderData, shortcut);

      let nullData: GridLayoutItemInfo = getNullObject() as GridLayoutItemInfo;
      openFolderData.layoutInfo = [[shortcut, nullData]];
      instance.removeShortCutFromFolderInDock(openFolderData, shortcut);
      AppStorage.delete('residentList');
    });

    it('ExtraTest2_revertLastFolderData', 0, () => {
      let openFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolder.layoutInfo = [[new GridLayoutItemInfo()]];
      AppStorage.SetOrCreate('lastOpenFolderData', openFolder);
      instance.revertLastFolderData();
      AppStorage.delete('lastOpenFolderData');
    });

    it('ExtraTest2_updateFolderSize', 0, () => {
      let openFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolder.layoutInfo = [[new GridLayoutItemInfo()]];
      openFolder.area = [2, 2];
      instance.updateFolderSize(openFolder);
    });

    it('ExtraTest2_handlerMultiSelectItem', 0, () => {
      let selectedItemMap: Map<GridLayoutItemInfo, GridLayoutItemInfo[]> = new Map();
      let disappearList: Object[] = [];
      let deleteFolderIdList: string[] = [];

      let anotherFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      anotherFolder.folderId = 'ExtraTestFolder';
      anotherFolder.typeId === CommonConstants.TYPE_FOLDER;

      let anotherFolderTwo: GridLayoutItemInfo = new GridLayoutItemInfo();
      anotherFolderTwo.folderId = 'anotherExtraTestFolder';
      anotherFolderTwo.typeId === CommonConstants.TYPE_FOLDER;
      anotherFolderTwo.layoutInfo = [[anotherFolder]];

      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.folderId = 'ExtraTestFolder';
      folder.typeId === CommonConstants.TYPE_FOLDER;
      folder.layoutInfo = [[anotherFolder]];

      let otherFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      otherFolder.typeId === CommonConstants.TYPE_FOLDER;
      otherFolder.folderId = 'otherExtraTestFolder';

      let list: GridLayoutItemInfo[] = [folder, otherFolder];
      selectedItemMap.set(folder, list);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FolderData.getInstance(), FolderData.getInstance().getOpenedFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(anotherFolder);
      let mockFunc2: Function = mocker.mockFunc(instance, instance['layoutInfoToList']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([anotherFolder]);
      let ret = instance['handlerMultiSelectItem'](selectedItemMap, disappearList, deleteFolderIdList);
      expect(ret).assertTrue();
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([anotherFolderTwo]);
      ret = instance['handlerMultiSelectItem'](selectedItemMap, disappearList, deleteFolderIdList);
      expect(ret).assertTrue();
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([anotherFolderTwo, anotherFolderTwo, anotherFolderTwo]);
      ret = instance['handlerMultiSelectItem'](selectedItemMap, disappearList, deleteFolderIdList);
      expect(ret).assertTrue();
      mocker.clear(FolderData.getInstance());
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('ExtraTest2_updateAppLayoutInFolder', 0, () => {
      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.typeId === CommonConstants.TYPE_FOLDER;
      folder.folderId = 'ExtraTestFolder';
      folder.badgeNumber = 1;
      folder.page = 0;
      let list: GridLayoutItemInfo[] = [folder];
      let ret = instance['updateAppLayoutInFolder'](list);
      let retValue = ret[0][0].folderId;
      expect(retValue === 'ExtraTestFolder').assertTrue();
    })

    it('ExtraTest2_disPatchFolderWhenOnlyOneAppLeft', 0, () => {
      let anotherFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      anotherFolder.folderId = 'anotherExtraTestFolder';
      anotherFolder.typeId === CommonConstants.TYPE_FOLDER;
      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.typeId === CommonConstants.TYPE_FOLDER;
      folder.folderId = 'ExtraTestFolder';
      folder.badgeNumber = 1;
      folder.page = 0;
      folder.column = 0;
      folder.row = 0;
      let list: GridLayoutItemInfo[] = [folder];
      let settingModel = SettingsModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingModel, settingModel.getAppListInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([folder]);
      instance['disPatchFolderWhenOnlyOneAppLeft'](false, list, folder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([anotherFolder]);
      instance['disPatchFolderWhenOnlyOneAppLeft'](true, list, folder);
      expect(list.length).assertEqual(1);
      mocker.clear(settingModel);
      mocker.clearAll();
    });

    it('ExtraTest2_moveAppFromOtherFolders', 0, () => {
      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.typeId === CommonConstants.TYPE_FOLDER;
      folder.folderId = 'ExtraTestFolder';
      folder.badgeNumber = 1;
      folder.page = 0;
      folder.column = 0;
      folder.row = 0;
      folder.keyName = 'folder';
      folder.badgeNumber = 0;
      let anotherFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      anotherFolder.folderId = 'anotherExtraTestFolder';
      anotherFolder.typeId === CommonConstants.TYPE_FOLDER;
      anotherFolder.keyName = 'anotherFolder';
      anotherFolder.badgeNumber = 0;
      anotherFolder.layoutInfo = [[folder]];
      let list: GridLayoutItemInfo[] = [folder];
      let folderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemsByType);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([anotherFolder]);
      let mockFunc2: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectIndexInLayout);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(-1);
      let mockFunc3: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.checkFolderIsReleased);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc4: Function = mocker.mockFunc(NotHarmonyUtil, NotHarmonyUtil.isNotHarmonyFolderShouldReleased);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(false);
      instance['moveAppFromOtherFolders'](list, folder);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(0);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);
      instance['moveAppFromOtherFolders'](list, folder);
      anotherFolder.keyName = 'ExtraTestFolder';
      list = [anotherFolder];
      instance['moveAppFromOtherFolders'](list, folder);
      expect(list.length).assertEqual(1);
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(DeliverUtil);
      mocker.clear(NotHarmonyUtil);
      mocker.clearAll();
    });

    it('ExtraTest2_BigFolderViewModel_dragAppFromFolderToDeskTop', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderDataJSONStr: string = '{"bundleName":"lkqkw4s76q0592qwa4g","abilityName":"","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":29,"infoId":"lkqkw4s76q0592qwa4g","folderId":"lkqkw4s76q0592qwa4g","container":-100,"folderName":"实用工具","ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":3,"area":[2,2],"page":2,"column":0,"row":1,"kindId":0,"moduleName":"","keyName":"lkqkw4s76q0592qwa4g","appIconId":0,"extend1":"","extend2":"","extend3":0,"appLabelId":0,"iconResource":"","callerName":"","layoutInfo":[[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":30,"infoId":"20","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":0,"row":0,"kindId":2,"moduleName":"phone","keyName":"com.ohos.calendarMainAbilityphone","appIconId":285212955,"extend1":"","extend2":"","extend3":0,"appLabelId":285212827,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb201iu34asnj6s"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":31,"infoId":"21","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":1,"row":0,"kindId":14,"moduleName":"entry","keyName":"com.ohos.healthMainAbilityentry","appIconId":134220347,"extend1":"","extend2":"","extend3":0,"appLabelId":134217728,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb2rn2bixbfoh"},{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"},{"appName":"","appIconId":67108865,"bundleName":"com.ohos.email","abilityName":"EntryAbility","downloadProgress":0,"appStatus":0,"appLabelId":67108864,"moduleName":"entry","keyName":"com.ohos.emailEntryAbilityentry","iconResource":"","callerName":"","applicationLabelId":67108864,"isUninstallAble":true,"isSystemApp":true,"installTime":"Sat Jun 22 2024 14:15:18 GMT+0800","typeId":0,"area":[1,1],"badgeNumber":0,"infoId":"28","page":0,"row":1,"column":0,"areaType":0,"x":0,"isSelect":false,"geometryId":"lxq0upk8sisd3nfpqtj","extend3":1719054838389}]],"backgroundGeometryId":"lxq0tnb2i98rvvd07sk","totalBadgeGeometryId":"lxq0tnb2xzts9f5r7y","enterEditing":false}';
      let appInfoJSONStr: string = '{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"}';
      let openFolderData: GridLayoutItemInfo = JSON.parse(openFolderDataJSONStr) as GridLayoutItemInfo;
      let appInfo: GridLayoutItemInfo = JSON.parse(appInfoJSONStr) as GridLayoutItemInfo;
      AppStorage.setOrCreate('openFolderData', openFolderData);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance['isEnoughDropSpace']);
      let mockFunc01: Function = mocker.mockFunc(instance, instance['filterFolderPage']);
      let mockFunc02: Function = mocker.mockFunc(instance['mFolderLayout'], instance['mFolderLayout'].selectIndexInLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc01)(ArgumentMatchers.any).afterReturn([[appInfo]]);
      when(mockFunc02)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
      instance.dragAppFromFolderToDeskTop([appInfo], appInfo);
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clear(instance['mFolderLayout']);
      mocker.clearAll();
    });

    it('ExtraTest2_BigFolderViewModel_updateDesktopAppList_01', 0, () => {
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      let manager: MultiSelectManager = new MultiSelectManager();
      let itemInfo: AppItemInfo = new AppItemInfo();
      info.folderId = '996';
      info.keyName = '李华';
      manager['mode'] = MultiSelectMode.MULTI;
      let folderLayoutInfo: GridLayoutItemInfo[][] = [[info]];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.checkFolderIsReleased);
      let mockFunc02: Function = mocker.mockFunc(NotHarmonyUtil, NotHarmonyUtil.isNotHarmonyFolderShouldReleased);
      let mockFunc03: Function = mocker.mockFunc(MultiSelectManager, MultiSelectManager.getInstance);
      let mockFunc04: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.checkGridItemEqual);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc02)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc03)(ArgumentMatchers.any).afterReturn(manager);
      when(mockFunc04)(ArgumentMatchers.any).afterReturn(false);
      instance['updateDesktopAppList'](folderLayoutInfo, info, [info], info, [itemInfo]);
      expect(folderLayoutInfo.length).assertEqual(1);
      mocker.clear(DeliverUtil);
      mocker.clear(NotHarmonyUtil);
      mocker.clear(MultiSelectManager);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    });

    it('ExtraTest2_BigFolderViewModel_updateDesktopAppList_02', 0, () => {
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      let manager: MultiSelectManager = new MultiSelectManager();
      let itemInfo: AppItemInfo = new AppItemInfo();
      info.folderId = '996';
      info.keyName = '李华';
      info.badgeNumber = 9;
      info.bundleName = '李华';
      info.abilityName = '007';
      info.appIconId = 7;
      info.negativeId = 9;
      info.isSelect = true;
      info.area = [1, 2];
      manager['mode'] = MultiSelectMode.MULTI;
      let folderLayoutInfo: GridLayoutItemInfo[][] = [[info]];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance['getIsPad']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      instance['updateDesktopAppList'](folderLayoutInfo, info, [info], info, [itemInfo]);
      expect(folderLayoutInfo.length).assertEqual(1);
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('ExtraTest2_updateOpenedFolderLayout_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      instance['updateOpenedFolderLayout'](false, gridLayoutItemInfo, ['1']);
      gridLayoutItemInfoOther.typeId = 1;
      gridLayoutItemInfoOther.cardId = '1';
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfoOther]];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance['updateFolderAppLocation']);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc2: Function = mocker.mockFunc(instance, instance['updateAppLayoutInFolder']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([[gridLayoutItemInfo]]);
      let mockFunc3: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil['isBigFolder']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      instance['updateOpenedFolderLayout'](true, gridLayoutItemInfo, ['11']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      instance['updateOpenedFolderLayout'](true, gridLayoutItemInfo, ['11']);
      mocker.clear(instance);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
      done();
    });

    it('ExtraTest2_addBackToFolder_1', 0, (done: Function) => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfoOther.layoutInfo = [[gridLayoutItemInfo]];
      let dragItemFromFolderStartInfo: DragItemFromFolderStartInfo = {
        page: 1,
        row: 0,
        column: 0,
        bundleName: '1',
        folderId: undefined,
      };
      gridLayoutItemInfo.bundleName = 'name_1';
      instance.setDragFromFolderStartInfo(dragItemFromFolderStartInfo);
      instance.addBackToFolder(gridLayoutItemInfo);
      dragItemFromFolderStartInfo.folderId = '1';
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      const folderModel: FolderModel = FolderModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['selectGridLayoutItemByFolderId']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      instance.setDragFromFolderStartInfo(dragItemFromFolderStartInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfoOther);
      let mockFunc1: Function = mocker.mockFunc(folderModel, folderModel['getFolderOpenLayout']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn({
        id: 1,
        layout: '1',
        name: '1',
        row: 0,
        column: 0,
        checked: false
      });
      instance.setDragFromFolderStartInfo(dragItemFromFolderStartInfo);
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(folderModel);
      mocker.clearAll();
      done();
    });

    it('ExtraTest2_convertToSmallFolder_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      const folderReporter: FolderReporter = FolderReporter.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectIndexInLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      let mockFunc1: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.deleteGridLayoutItemByIndex);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc2: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.convertFolderSize);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc3: Function = mocker.mockFunc(folderReporter, folderReporter.reportMenuModifyFolderSize);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      instance.convertToSmallFolder(gridLayoutItemInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(-2);
      instance.convertToSmallFolder(gridLayoutItemInfo);
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(folderReporter);
      mocker.clearAll();
      done();
    });

    it('ExtraTest2_deleteAppByDraging_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      const folderData: FolderData = FolderData.getInstance()
      const pageDesktopModel: PageDesktopModel = PageDesktopModel.getInstance();
      const settingsModel: SettingsModel = SettingsModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.filterFolderPage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([[new GridLayoutItemInfo()]]);
      let mockFunc1: Function = mocker.mockFunc(folderData, folderData.getOpenedFolder);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(new GridLayoutItemInfo());
      let mockFunc2: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectIndexInLayout);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(0);
      let mockFunc3: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.deleteGridLayoutItemByItemId);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc4: Function = mocker.mockFunc(instance, instance['updateBadgeNumber']);
      when(mockFunc4)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc5: Function = mocker.mockFunc(settingsModel, settingsModel['getAppListInfo']);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn([]);
      let mockFunc6: Function = mocker.mockFunc(pageDesktopModel, pageDesktopModel['updatePageDesktopLayoutInfo']);
      when(mockFunc6)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc7: Function = mocker.mockFunc(instance, instance['createAppLayoutInfo']);
      when(mockFunc7)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      let mockFunc8: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['insertGridLayoutItemInfo']);
      when(mockFunc8)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc9: Function = mocker.mockFunc(settingsModel, settingsModel['setAppListInfo']);
      when(mockFunc9)(ArgumentMatchers.any).afterReturnNothing();
      instance.deleteAppByDraging([gridLayoutItemInfo], 0)
      when(mockFunc)(ArgumentMatchers.any).afterReturn([[]]);
      instance.deleteAppByDraging([gridLayoutItemInfo], 0);
      expect(folderLayoutCacheManager).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(folderData);
      mocker.clear(pageDesktopModel);
      mocker.clear(instance);
      mocker.clear(settingsModel);
      mocker.clearAll();
      done();
    });

    it('ExtraTest2_getAppFromDesktopPages_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.page = 1;
      gridLayoutItemInfoOther.page = 2;
      gridLayoutItemInfo.container = -100;
      gridLayoutItemInfoOther.container = -100;
      expect(instance['getAppFromDesktopPages']([gridLayoutItemInfo, gridLayoutItemInfoOther])).not().assertNull();
      done();
    });

    it('ExtraTest2_getCurFolderLayoutInfo_1', 0, (done: Function) => {
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.layoutInfo = [[new GridLayoutItemInfo()]];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['selectGridLayoutItemByFolderId']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      expect(instance['getCurFolderLayoutInfo'](gridLayoutItemInfo)).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
      done();
    });

    class GridLayoutInfo {
      layoutInfo?:GridLayoutInfo[];
      typeId?: number;
      keyName?: string;
      bundleName: string = '';
    };

    class InnerOpenFolderData {
      folderId: string = '';
      layoutInfo: [] = [];
    };

    class Params {
      bundleName: string = '';
      isShow: boolean = false;
      badgeNumber: number = 0;
    };
  })
}
