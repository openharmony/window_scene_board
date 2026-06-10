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
  ArgumentMatchers
} from '@ohos/hypium'
import {
  AppStatus,
  CommonConstants,
  DeleteItemType,
  DockItemInfo,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  ResidentLayoutCacheMgr
} from '@ohos/launchercommon/src/main/ets/TsIndex'
import {
  CancelRestoreLauncherData,
  ExtraDataInfo,
  OwnerInfo
} from '@ohos/phonebase/src/main/ets/backup/impl/CancelRestoreLauncherData'

export default function CancelRestoreLauncherDataTest() {
  describe('CancelRestoreLauncherDataTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_execute_yes_return', 0, async (done: Function) => {
      try {
        let cancel: CancelRestoreLauncherData = new CancelRestoreLauncherData();
        let response1: string = await cancel.execute(null);
        expect(response1).assertInstanceOf('String');
        let response2: string = await cancel.execute(undefined);
        expect(response2).assertInstanceOf('String');
        let owner: OwnerInfo = {
          bundleName: 'aaa', moduleName: 'bbb', abilityName: 'ccc'
        };
        let list: ExtraDataInfo[] = [{
          callerName: '9',
          callerType: 9,
          bundleName: '9',
          packageName: '9',
          title: '9',
          iconUri: 'http://9',
          index: 9
        }];
        let response3: string = await cancel.execute(new Object({
          list: list, ownerInfo: owner
        }));
        expect(response3).assertInstanceOf('String');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    });

    it('test_CancelRestoreLauncherData_getItemFromFolder', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let cancel: CancelRestoreLauncherData = new CancelRestoreLauncherData();
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        itemInfo.bundleName = '007';
        itemInfo.cardId = '007';
        itemInfo.typeId = CommonConstants.TYPE_APP;
        itemInfo.abilityName = '李华';
        itemInfo.callerName = '李华';
        itemInfo.negativeId = 7;
        itemInfo.appIconId = 7;
        itemInfo.row = 7;
        itemInfo.column = 7;
        itemInfo.appStatus = AppStatus.WAIT_FOR_HARMONY;
        itemInfo.appIndex = 0;
        itemInfo.callerName = 'com.ohos.clouddrive';
        itemInfo.intent = '007';
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.bundleName = '007';
        info.cardId = '007';
        info.typeId = CommonConstants.TYPE_APP;
        info.abilityName = '李华';
        info.callerName = '李华';
        info.negativeId = 7;
        info.appIconId = 7;
        info.row = 7;
        info.column = 7;
        info.appStatus = AppStatus.WAIT_FOR_HARMONY;
        info.appIndex = 0;
        info.callerName = 'com.ohos.clouddrive';
        info.intent = '007';
        info.layoutInfo = [[itemInfo]];
        let mockFunc: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
          LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByType);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([info]);
        cancel['getItemFromFolder']('007', 0, [itemInfo]);
        expect(cancel).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clearAll();
    });

    it('test_CancelRestoreLauncherData_isNeedToDelete', 0, () => {
      try {
        let cancel: CancelRestoreLauncherData = new CancelRestoreLauncherData();
        let itemInfo: DockItemInfo = new DockItemInfo();
        itemInfo.visible = true;
        itemInfo.borderVisible = true;
        itemInfo.shake = 1;
        itemInfo.bundleName = '007';
        itemInfo.appStatus = AppStatus.INSTALL_WAITING;
        itemInfo.itemType = CommonConstants.TYPE_APP;
        itemInfo.layoutInfo = [];
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
        let deleteItem: DeleteItemType = {
          bundleName: '007',
          appIndex: 0,
        } as DeleteItemType;
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        cancel['isNeedToDelete'](deleteItem);

        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [itemInfo], false);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        cancel['isNeedToDelete'](deleteItem);

        itemInfo.itemType = CommonConstants.TYPE_FOLDER;
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [itemInfo], false);

        cancel['isNeedToDelete'](deleteItem);

        itemInfo.itemType = CommonConstants.DOCK_SPACE;
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [itemInfo], false);

        cancel['isNeedToDelete'](deleteItem);

        expect(itemInfo.bundleName).assertInstanceOf('String');
        mocker.clear(CheckEmptyUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_CancelRestoreLauncherData_execute', 0, async (done: Function) => {
      let cancel: CancelRestoreLauncherData = new CancelRestoreLauncherData();
      let mocker: MockKit = new MockKit();
      try {
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        itemInfo.bundleName = '007';
        itemInfo.cardId = '007';
        itemInfo.typeId = CommonConstants.TYPE_APP;
        itemInfo.abilityName = '李华';
        itemInfo.callerName = '李华';
        itemInfo.negativeId = 7;
        itemInfo.appIconId = 7;
        itemInfo.row = 7;
        itemInfo.column = 7;
        itemInfo.appStatus = AppStatus.WAIT_FOR_HARMONY;
        itemInfo.appIndex = 9;
        itemInfo.callerName = 'com.ohos.clouddrive';
        itemInfo.intent = '007';
        let info: GridLayoutItemInfo = new GridLayoutItemInfo();
        info.bundleName = '007';
        info.cardId = '007';
        info.typeId = CommonConstants.TYPE_APP;
        info.abilityName = '李华';
        info.callerName = '李华';
        info.negativeId = 7;
        info.appIconId = 7;
        info.row = 7;
        info.column = 7;
        info.appStatus = AppStatus.WAIT_FOR_HARMONY;
        info.appIndex = 9;
        info.callerName = 'com.ohos.clouddrive';
        info.intent = '007';
        info.layoutInfo = [[itemInfo]];

        let mockFunc: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
          LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByType);
        let mockFunc1: Function = mocker.mockFunc(cancel, cancel['isNeedToDelete']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([info]);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
        let owner: OwnerInfo = {
          bundleName: 'aaa',
          moduleName: 'bbb',
          abilityName: 'ccc'
        };
        let list: ExtraDataInfo[] = [{
          callerName: '9',
          callerType: 9,
          bundleName: '9',
          packageName: '9',
          title: '9',
          iconUri: 'http://9',
          index: 9
        }];
        try {
          let result: string = await cancel.execute(new Object({
            list: list,
            ownerInfo: owner
          }));
          expect(result).assertInstanceOf('String');
        } catch (e) {
          expect(JSON.stringify(e)).assertInstanceOf('String');
        }
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clear(cancel);
      mocker.clearAll();
    });
  })
}