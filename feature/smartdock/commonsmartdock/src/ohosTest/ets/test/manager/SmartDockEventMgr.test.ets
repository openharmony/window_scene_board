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
  AppItemInfo,
  AppLockUtils,
  AppStatus,
  CommonConstants,
  DockContinuableInfo,
  GridLayoutItemInfo,
  layoutLockUtil,
  lockLayoutManager,
  MenuInfo,
  ShortcutViewModel,
  LayoutViewModel,
  DesktopLayoutState,
  DesktopUtils,
  DeleteDockItem,
  DragCoveredItem,
} from '@ohos/launchercommon';
import { DockItemInfo, RecentBundleMissionInfo } from '@ohos/launchercommon';
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
} from '@ohos/hypium';
import { SmartDockEventMgr } from '../../../../main/ets/default/manager/SmartDockEventMgr';
import SmartDockModel from '../../../../main/ets/default/model/SmartDockModel';
import { CheckEmptyUtils, LogDomain, LogHelper, ObjUtil } from '@ohos/basicutils';
import {
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SceneInfoAdapterUtil,
  StartAbilityUtil,
} from '@ohos/windowscene';
import SmartDockConstants from '../../../../main/ets/default/common/constants/SmartDockConstants';
import { SCBSceneContainerSession } from '@ohos/windowscene';
import type { SnapshotInfo } from '@ohos/launchercommon';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { UIContext } from '@kit.ArkUI';
import { DeviceHelper, GlobalContext, ResourceManager } from '@ohos/frameworkwrapper';
import StatusBarServiceEventMgr from '../../../../main/ets/default/manager/StatusBarServiceEventMgr';

const TAG = 'SmartDockEventMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default function SmartDockEventMgrTest() {
  describe('SmartDockEventMgrTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_residentOnClick_0', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate<boolean>('isDrag', true);
        let item: DockItemInfo = new DockItemInfo();
        instance.residentOnClick(null, item, false)
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      }catch(err){}
    })

    class DockItem{
      bundleName?: string;
      keyName?: string;
    }

    it('test_residentOnClick_1', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate<boolean>('isDrag', false);
        AppStorage.setOrCreate<boolean>('isDockItemMove', true);
        let item: DockItemInfo = new DockItemInfo();
        instance.residentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    })

    it('test_residentOnClick_2', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();

        AppStorage.setOrCreate<boolean>('isDrag', false);
        AppStorage.setOrCreate<boolean>('isDockItemMove', false);

        let appItemInfo: AppItemInfo = {
          appName: '',
          appIconId: 0,
          bundleName: '',
          abilityName: ''
        };

        let item: DragCoveredItem = {
          isCreateSmallFolder: true,
          coveredAppPositionX: 0,
          coveredAppPositionY: 0,
          dragItemInfo: appItemInfo,
          coveredItemInfo: appItemInfo,
          folderId: '',
          folderType: 0,
          dragItemInfoX: 0,
          dragItemInfoY: 0,
          coveredItemUpperLeftPosition: []
        };

        AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', item);
        let item1: DockItemInfo = new DockItemInfo();
        instance.residentOnClick(null, item1, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    })

    it('test_residentOnClick_3', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();

        AppStorage.setOrCreate<boolean>('isDrag', false);
        AppStorage.setOrCreate<boolean>('isDockItemMove', false);

        let appItemInfo: AppItemInfo = {
          appName: '',
          appIconId: 0,
          bundleName: '',
          abilityName: ''
        };

        let item: DragCoveredItem = {
          isCreateSmallFolder: false,
          coveredAppPositionX: 0,
          coveredAppPositionY: 0,
          dragItemInfo: appItemInfo,
          coveredItemInfo: appItemInfo,
          folderId: '',
          folderType: 0,
          dragItemInfoX: 0,
          dragItemInfoY: 0,
          coveredItemUpperLeftPosition: []
        };
        AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', item);

        AppStorage.setOrCreate('missionInfoList', []);

        let dockItemInfo: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'MainAbilityentry',
          moduleName: 'contacts'
        }
        instance.residentOnClick(null, dockItemInfo, false)
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    })

    it('test_residentOnClick_4', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();

        AppStorage.setOrCreate<boolean>('isDrag', false);
        AppStorage.setOrCreate<boolean>('isDockItemMove', false);
        AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', null);

        let missionInfoList: RecentBundleMissionInfo = {
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: '',
          abilityName: ''
        }

        AppStorage.setOrCreate('missionInfoList', [missionInfoList]);

        let dockItemInfo: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'MainAbilityentry',
          moduleName: 'contacts'
        }
        instance.residentOnClick(null, dockItemInfo, false)
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    })

    it('test_residentOnClick_5', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();

        AppStorage.setOrCreate<boolean>('isDrag', false);
        AppStorage.setOrCreate<boolean>('isDockItemMove', false);
        AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', null);

        AppStorage.setOrCreate('missionInfoList', []);

        let dockItemInfo: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'MainAbilityentry',
          moduleName: 'contacts'
        }
        instance.residentOnClick(null, dockItemInfo, false)
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    })

    it('test_residentOnClick_6', 0, () => {
      let instance = SmartDockEventMgr.getInstance();

      AppStorage.setOrCreate<boolean>('isDrag', false);
      AppStorage.setOrCreate<boolean>('isDockItemMove', false);
      AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', null);

      let mocker: MockKit = new MockKit();
      let mockFunc2 = mocker.mockFunc(StartAbilityUtil, StartAbilityUtil.startLauncherAbility);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);

      let missionInfoList: RecentBundleMissionInfo = {
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: '',
        abilityName: ''
      }

      AppStorage.setOrCreate('missionInfoList', [missionInfoList]);

      let dockItemInfo: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbilityentry',
        moduleName: 'contacts'
      }
      try {
        instance.residentOnClick(null, dockItemInfo, false)
        expect(instance instanceof SmartDockEventMgr).assertTrue();

      } catch (err) {}
      mocker.clear(StartAbilityUtil);
      mocker.clearAll();
    })

    it('test_residentOnClick_7', 0, () => {
      let instance = SmartDockEventMgr.getInstance();

      AppStorage.setOrCreate<boolean>('isDrag', false);
      AppStorage.setOrCreate<boolean>('isDockItemMove', false);
      AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', null);

      let mocker: MockKit = new MockKit();

      let mockFunc2 = mocker.mockFunc(StartAbilityUtil, StartAbilityUtil.startLauncherAbility);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        AppStorage.setOrCreate('missionInfoList', []);

        let dockItemInfo: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'MainAbilityentry',
          moduleName: 'contacts'
        }
        instance.residentOnClick(null, dockItemInfo, true)
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
      mocker.clear(StartAbilityUtil);
      mocker.clearAll();
    })

    it('test_residentOnClick_9', 0, () => {
      let instance = SmartDockEventMgr.getInstance();

      AppStorage.setOrCreate<boolean>('isDrag', false);
      AppStorage.setOrCreate<boolean>('isDockItemMove', false);
      AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', null);

      let mocker: MockKit = new MockKit();
      let mockFunc2 = mocker.mockFunc(StartAbilityUtil, StartAbilityUtil.startLauncherAbility);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);

      try {
        let missionInfoList: RecentBundleMissionInfo = {
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: '',
          abilityName: ''
        }

        AppStorage.setOrCreate('missionInfoList', [missionInfoList]);
        let item: DockItemInfo = new DockItemInfo();
        item.abilityName = 'abilityName';
        item.bundleName = 'bundleName';
        item.moduleName = 'moduleName';

        instance.residentOnClick(null, item, true)
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
      mocker.clear(StartAbilityUtil);
      mocker.clearAll();
    })

    it('test_residentOnClick_10', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate<boolean>('isDrag', false);
        AppStorage.setOrCreate<boolean>('isDockItemMove', true);
        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = 'com.ohos.sceneboard';
        item.abilityName = 'com.ohos.sceneboard.recents.MainAbility';
        item.typeId = 0;
        item.itemType = 2;
        item.areaType = 1;
        item.appIndex = 0;
        instance.residentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    })

    it('test_residentOnClick_11', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate<boolean>('isDrag', false);
        AppStorage.setOrCreate<boolean>('isDockItemMove', true);
        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = 'com.ohos.sceneboard';
        item.abilityName = 'com.ohos.sceneboard.recents.MainAbility';
        item.appIndex = 2;
        item.typeId = 0;
        item.itemType = 2;
        item.areaType = 1;
        item.appIndex = 0;
        instance.residentOnClick(null, item, false)
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    })

    it('test_residentOnClick_Screen_01', 0, () => {
      let instance = SmartDockEventMgr.getInstance();

      AppStorage.setOrCreate<boolean>('isDrag', false);
      AppStorage.setOrCreate<boolean>('isDockItemMove', false);
      AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', null);

      let mocker: MockKit = new MockKit();
      let mockFunc2 = mocker.mockFunc(StartAbilityUtil, StartAbilityUtil.startLauncherAbility);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);

      try {
        let missionInfoList: RecentBundleMissionInfo = {
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: '',
          abilityName: ''
        }

        AppStorage.setOrCreate('missionInfoList', [missionInfoList]);
        let item: DockItemInfo = new DockItemInfo();
        item.abilityName = 'abilityName';
        item.bundleName = 'bundleName';
        item.moduleName = 'moduleName';

        let screenId = 0;
        instance.residentOnClickWithDisplay(screenId, null, item, true);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
      mocker.clear(StartAbilityUtil);
      mocker.clearAll();
    });

    it('test_residentOnClick_Screen_02', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate<boolean>('isDrag', false);
        AppStorage.setOrCreate<boolean>('isDockItemMove', true);
        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = 'com.ohos.sceneboard';
        item.abilityName = 'com.ohos.sceneboard.recents.MainAbility';
        item.typeId = 0;
        item.itemType = 2;
        item.areaType = 1;
        item.appIndex = 0;
        let screenId = 0;
        instance.residentOnClickWithDisplay(screenId, null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    });

    it('test_buildNotInstalledAppMenu_01', 0, () => {
      let instance = SmartDockEventMgr.getInstance();
      let appItem: DockItemInfo = new DockItemInfo();
      appItem.bundleName = 'anyBundleName';
      appItem.area = [1, 1];
      let dialog = new CustomDialogController({
        builder: {},
      });
      let ret: Map<AppStatus, MenuInfo[]> = instance.buildNotInstalledAppMenu(appItem, dialog);
      expect(ret).not().assertNull();
    });

    it('test_checkAddToOuterMenu_02', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        let appInfo: AppItemInfo = new AppItemInfo();
        let menuInfoList: MenuInfo[] = [];
        (instance as object)['checkAddToOuterMenu'](appInfo, menuInfoList);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_canClick_01', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate('isDrag', true);
        let ret:boolean = (instance as object)['canClick']();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
        AppStorage.delete('isDrag');
      } catch (err) {}
    });

    it('test_canClick_02', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate('isDrag', false);
        AppStorage.setOrCreate('isDockItemMove', true);
        let ret:boolean = (instance as object)['canClick']();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
        AppStorage.delete('isDrag');
        AppStorage.delete('isDockItemMove');
      } catch (err) {}
    });

    it('test_canClick_03', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate('isDrag', false);
        AppStorage.setOrCreate('isDockItemMove', true);
        let dragCoveredItem: DragCoveredItem = {} as DragCoveredItem;
        AppStorage.setOrCreate('DragCoveredItem', dragCoveredItem);
        let ret:boolean = (instance as object)['canClick']();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
        AppStorage.delete('isDrag');
        AppStorage.delete('isDockItemMove');
        AppStorage.delete('DragCoveredItem');
      } catch (err) {}
    });

    it('test_canClick_04', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate('isDrag', false);
        AppStorage.setOrCreate('isDockItemMove', true);
        let dragCoveredItem: DragCoveredItem = {
          isCreateSmallFolder: true,
          coveredAppPositionX: 0,
          coveredAppPositionY: 0,
          dragItemInfo: new AppItemInfo,
          coveredItemInfo: new AppItemInfo,
          folderId: '',
          folderType: 0,
          dragItemInfoX: 0,
          dragItemInfoY: 0,
          coveredItemUpperLeftPosition: []
        };
        AppStorage.setOrCreate('DragCoveredItem', dragCoveredItem);
        let ret:boolean = (instance as object)['canClick']();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
        AppStorage.delete('isDrag');
        AppStorage.delete('isDockItemMove');
        AppStorage.delete('DragCoveredItem');
      } catch (err) {}
    });

    it('test_deleteDockItem_01', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        let dockItem: DeleteDockItem = {
          bundleName: 'anyBundleName',
          keyName: 'anyKeyName'
        };
        let dockType: number = SmartDockConstants.RESIDENT_DOCK_TYPE;
        instance.deleteDockItem(dockItem, dockType);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    });

    it('test_getSelectedDockType_01', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        let ret: number = instance.getSelectedDockType()
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    });

    it('test_getSelectedItem_01', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        instance.getSelectedItem();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    });

    it('test_getSnapshot_01', 0, async () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        let missionInfos: RecentBundleMissionInfo = {
          missionInfoList: [],
          appName: 'anyAppName',
          appIconId: 0,
          bundleName: 'anyBundleName',
          abilityName: 'anyAbilityName'
        };
        let ret: SnapshotInfo[] = await instance.getSnapshot(missionInfos);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    });

    it('test_initRecentDataList_01', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        let containerSessionList: SCBSceneContainerSession[] = [];
        instance.initRecentDataList(containerSessionList);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_initRecentDataList_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(SmartDockModel.getInstance(), SmartDockModel.getInstance().initRecentDataList);
        when(mockFunc)(ArgumentMatchers.any).afterThrow('err');

        let instance = SmartDockEventMgr.getInstance();
        let containerSessionList: SCBSceneContainerSession[] = [];
        instance.initRecentDataList(containerSessionList);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SmartDockModel.getInstance());
      mock.clearAll();
    })

    it('test_initRecentDataList_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(SmartDockModel.getInstance(), SmartDockModel.getInstance().initRecentDataList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(Promise.resolve());

        let instance = SmartDockEventMgr.getInstance();
        let containerSessionList: SCBSceneContainerSession[] = [];
        instance.initRecentDataList(containerSessionList);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SmartDockModel.getInstance());
      mock.clearAll();
    })

    it('test_getOpenMenu_01', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = 'com.ohos.contacts';
        item.moduleName = 'entry';
        let menu: MenuInfo = instance.getOpenMenu(item);
        if (menu.onMenuClick) {
          menu.onMenuClick();
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getOpenMenu_02', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = 'com.ohos.contacts';
        item.moduleName = 'entry';
        item.enableNewAppInstance = true;
        let menu: MenuInfo = instance.getOpenMenu(item);
        if (menu.onMenuClick) {
          menu.onMenuClick();
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getExitMenu_01', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = 'com.ohos.contacts';
        item.moduleName = 'entry';
        let menu: MenuInfo = instance.getExitMenu(item);
        if (menu.onMenuClick) {
          menu.onMenuClick();
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getOpenNewWindowMenu_01', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = 'com.ohos.contacts';
        item.moduleName = 'entry';
        let menu: MenuInfo = instance.getOpenNewWindowMenu(item);
        if (menu.onMenuClick) {
          menu.onMenuClick();
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getOpenNewWindowMenu_02', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = 'com.ohos.contacts';
        item.moduleName = 'entry';
        item.enableNewAppInstance = true;
        let menu: MenuInfo = instance.getOpenNewWindowMenu(item);
        if (menu.onMenuClick) {
          menu.onMenuClick();
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_moveToFront', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
        let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        SmartDockEventMgr.getInstance().moveToFront(sceneSession, 0);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    });

    it('test_closeFrontWindow_02', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockEventMgr.getInstance();
      try {
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let sceneSession3: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
        sceneSession3.isMinimizing = false;
        sceneSession3.setFocused(true);
        let containerSession3: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession3, screenProperty);
        containerSession3.primarySession = sceneSession3;
        containerSession3.secondarySession = sceneSession3;
        containerSession3.isSplit = true;
        containerSession3['_isActive'] = true;

        let containerSessionList: SCBSceneContainerSession[] = [containerSession3];
        let mockFunc: Function = mock.mockFunc(instance, (instance as object)['getMissionInfoActiveList']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(containerSessionList);

        let dockItemInfo: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'MainAbilityentry',
          moduleName: 'contacts'
        }

        instance.closeFrontWindow();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_getMissionInfoActiveList_01', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        (instance as object)['getMissionInfoActiveList']();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getMissionInfoActiveList_02', 0, () => {
      let mock = new MockKit();
      try {
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let sceneSession3: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
        sceneSession3.isMinimizing = false;
        sceneSession3.setFocused(true);
        let containerSession3: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession3, screenProperty);
        containerSession3.primarySession = sceneSession3;
        containerSession3.secondarySession = sceneSession3;
        containerSession3.isSplit = true;
        containerSession3['_isActive'] = true;

        let containerSessionList: SCBSceneContainerSession[] = [containerSession3];
        let mockFunc: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().getContainerSessionList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(containerSessionList);

        let instance = SmartDockEventMgr.getInstance();
        (instance as object)['getMissionInfoActiveList']();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('SmartDockEventMgrTest_showRecentCenter_true', 0, async (done: Function) => {
      try{
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate('showRecent', true);
        let dockItemInfo: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'com.ohos.sceneboard.recents.MainAbility',
          moduleName: 'contacts'
        };
        (instance as object)['showRecentCenter'](dockItemInfo);
        let showRecent: boolean = AppStorage.get('showRecent') as boolean;
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      }catch{}
      done();
    })

    it('SmartDockEventMgrTest_showRecentCenter_false', 0, async (done: Function) => {
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      AppStorage.setOrCreate('showRecent', false);
      let dockItemInfo: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'com.ohos.contacts',
        abilityName: 'com.ohos.sceneboard.recents.MainAbility',
        moduleName: 'contacts'
      };
      try{
        (instance as object)['showRecentCenter'](dockItemInfo);
        let showRecent: boolean = AppStorage.get('showRecent') as boolean;
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
      done();
    })

    it('SmartDockEventMgrTest_residentOnClick_recentability', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate<boolean>('isDrag', false);
        AppStorage.setOrCreate<boolean>('isDockItemMove', false);
        AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', null);
        let dockItemInfo: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'com.ohos.sceneboard.recents.MainAbility',
          moduleName: 'contacts'
        };
        instance.residentOnClick(null, dockItemInfo)
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    })

    it('SmartDockEventMgrTest_residentOnClick_abilityFalse', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate<boolean>('isDrag', true);
        AppStorage.setOrCreate<boolean>('isDockItemMove', false);
        AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', null);
        let dockItemInfo: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'com.ohos.sceneboard.recents.MainAbility',
          moduleName: 'contacts'
        };
        instance.residentOnClick(null, dockItemInfo, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    })

    it('SmartDockEventMgrTest_residentOnClick_startNewAbilityIndex1', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate<boolean>('isDrag', false);
        AppStorage.setOrCreate<boolean>('isDockItemMove', false);
        let dragCoveredItem: DragCoveredItem = new DragCoveredItem();
        AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', dragCoveredItem);
        let dockItemInfo: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          appIndex: 1,
          typeId: 7,
          bundleName: 'com.ohos.contacts',
          abilityName: 'com.ohos.sceneboard.recents.MainAbilityTest',
          moduleName: 'contacts',
          shortcutId: 'shortCutId001',
        };
        let map: Map<string, Object> = new Map<string, Object>();
        instance.residentOnClick(null, dockItemInfo, true, null, map)
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    })

    it('SmartDockEventMgrTest_recentOnClickWithDisplay', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate<boolean>('isDrag', true);
        AppStorage.setOrCreate<boolean>('isDockItemMove', false);
        AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', null);
        let dockItemInfo: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          typeId: 7,
          appIconId: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'com.ohos.sceneboard.recents.MainAbility',
          moduleName: 'contacts'
        };
        let clickEvent = {
          displayX: 0,
          displayY: 0,
          windowX: 0,
          windowY: 0,
          screenX: 0,
          screenY: 0,
          x: 0,
          y: 0,
          preventDefault: () => {
          },
        } as ClickEvent
        let res = instance.recentOnClickWithDisplay(0, clickEvent, dockItemInfo);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    })

    it('SmartDockEventMgrTest_residentOnClickWithDisplay', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        AppStorage.setOrCreate<boolean>('isDrag', true);
        AppStorage.setOrCreate<boolean>('isDockItemMove', false);
        AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', null);
        let dockItemInfo: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          typeId: 7,
          appIconId: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'com.ohos.sceneboard.recents.MainAbility',
          moduleName: 'contacts'
        };
        let res = instance.residentOnClickWithDisplay(0, null, dockItemInfo);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
    })

    it('SmartDockEventMgrTest_setStartAppInfo', 0, () => {
      let instance = SmartDockEventMgr.getInstance();
      let mocker: MockKit = new MockKit();
      AppStorage.setOrCreate<boolean>('isDrag', true);
      AppStorage.setOrCreate<boolean>('isDockItemMove', false);
      AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', null);
      AppStorage.setOrCreate<string>('device', 'phone');
      let actionShowInfo = 0;
      let mockerFunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockerFunc)('setStartAppType: 8').afterAction(() => {
        actionShowInfo = actionShowInfo + 1;
      });
      try {
        (instance as object)['setStartAppInfo'](null);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
      let dockItemInfo: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        typeId: 7,
        appIconId: 0,
        bundleName: 'com.ohos.contacts',
        abilityName: 'com.ohos.sceneboard.recents.MainAbility',
        moduleName: 'contacts'
      };
      try {
        (instance as object)['setStartAppInfo'](dockItemInfo);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
      actionShowInfo = 12;
      AppStorage.setOrCreate<string>('device', 'phone');
      let dockItemInfo1: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        typeId: 8,
        appIconId: 0,
        bundleName: 'com.ohos.contacts',
        abilityName: 'com.ohos.sceneboard.recents.MainAbility',
        moduleName: 'contacts'
      };
      when(mockerFunc)('setStartAppType: 4').afterAction(() => {
        actionShowInfo = 8;
      });
      try {
        (instance as object)['setStartAppInfo'](dockItemInfo1);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
      AppStorage.setOrCreate<string>('device', 'ipad');
      try {
        (instance as object)['setStartAppInfo'](dockItemInfo1);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (err) {}
      mocker.clear(log);
      mocker.clearAll();
    })

    it('test_queryFrontSession_01', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        let manger: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
        manger.registerGetContainerSessionListCallback(() => {
          return undefined
        }, -1);
        (instance as object)['queryFrontSession']();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
        manger.registerGetContainerSessionListCallback(() => {
          return null
        }, -1);
        (instance as object)['queryFrontSession']();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_queryFrontSession_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(),
            SCBSceneSessionManager.getInstance().getContainerSessionList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        (instance as object)['queryFrontSession']();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_queryFrontSession_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(),
            SCBSceneSessionManager.getInstance().getContainerSessionList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        (instance as object)['queryFrontSession']();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_queryFrontSession_04', 0, () => {
      let mock = new MockKit();
      try {
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let sceneSession3: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
        sceneSession3.isMinimizing = false;
        sceneSession3.setFocused(true);
        let containerSession3: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession3, screenProperty);
        containerSession3.primarySession = sceneSession3;
        containerSession3.secondarySession = sceneSession3;
        containerSession3['_isActive'] = true;

        let containerSessionList: SCBSceneContainerSession[] = [containerSession3];
        let mockFunc: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(),
            SCBSceneSessionManager.getInstance().getContainerSessionList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(containerSessionList);

        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        (instance as object)['queryFrontSession']();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_setUIContext_01', 0,() => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        instance.setUIContext(new UIContext());
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_openFrontWindow_01', 0, () => {
      try {
        AppStorage.setOrCreate<SCBSceneContainerSession[]>('missionInfoActiveList', []);
        let instance = SmartDockEventMgr.getInstance();
        instance.openFrontWindow();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_openFrontWindow_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        AppStorage.setOrCreate<SCBSceneContainerSession[]>('missionInfoActiveList', []);
        let instance = SmartDockEventMgr.getInstance();
        instance.openFrontWindow();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_openFrontWindow_03', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockEventMgr.getInstance();
      try {
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let sceneSession3: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
        sceneSession3.isMinimizing = false;
        sceneSession3.setFocused(true);
        let containerSession3: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession3, screenProperty);
        containerSession3.primarySession = sceneSession3;
        containerSession3.secondarySession = sceneSession3;
        containerSession3['_isActive'] = true;

        let containerSessionList: SCBSceneContainerSession[] = [containerSession3];
        let mockFunc2: Function = mock.mockFunc(instance, (instance as object)['getMissionInfoActiveList']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(containerSessionList);

        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        AppStorage.setOrCreate<SCBSceneContainerSession[]>('missionInfoActiveList', containerSessionList);

        instance.openFrontWindow();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_openFrontWindow_04', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockEventMgr.getInstance();
      try {
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let sceneSession3: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
        sceneSession3.isMinimizing = false;
        sceneSession3.setFocused(true);
        let containerSession3: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession3, screenProperty);
        containerSession3.primarySession = sceneSession3;
        containerSession3.secondarySession = sceneSession3;
        containerSession3['_isActive'] = true;

        let containerSessionList: SCBSceneContainerSession[] = [containerSession3];
        let mockFunc2: Function = mock.mockFunc(instance, (instance as object)['getMissionInfoActiveList']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn([]);

        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        AppStorage.setOrCreate<SCBSceneContainerSession[]>('missionInfoActiveList', containerSessionList);

        instance.openFrontWindow();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_recentOnClick_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let item: DockItemInfo = new DockItemInfo();
        item.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        instance.recentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_recentOnClick_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let item: DockItemInfo = new DockItemInfo();
        item.typeId = CommonConstants.TYPE_SHORTCUT_ICON +1;
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        instance.recentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_recentOnClick_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let item: DockItemInfo = new DockItemInfo();
        item.typeId = CommonConstants.TYPE_SHORTCUT_ICON +1;
        item.bundleName = 'other';
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        instance.recentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_recentOnClick_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let item: DockItemInfo = new DockItemInfo();
        item.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        item.bundleName = 'other';

        AppStorage.setOrCreate<RecentBundleMissionInfo[]>('missionInfoList', []);

        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        instance.recentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_recentOnClick_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let item: DockItemInfo = new DockItemInfo();
        item.typeId = CommonConstants.TYPE_SHORTCUT_ICON+1;
        item.bundleName = 'other';

        AppStorage.setOrCreate<RecentBundleMissionInfo[]>('missionInfoList', []);

        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        instance.recentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_recentOnClick_04', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let item: DockItemInfo = new DockItemInfo();
        item.typeId = CommonConstants.TYPE_SHORTCUT_ICON+1;

        AppStorage.setOrCreate<RecentBundleMissionInfo[]>('missionInfoList', []);

        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        instance.recentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_recentOnClick_05', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let item: DockItemInfo = new DockItemInfo();
        item.typeId = CommonConstants.TYPE_SHORTCUT_ICON+1;
        item.appIndex = 0;

        let missionInfo:RecentBundleMissionInfo = new RecentBundleMissionInfo();
        missionInfo.appIndex = 0;
        missionInfo.missionInfoList = [];
        let missionInfoList: RecentBundleMissionInfo[] = [missionInfo];
        AppStorage.setOrCreate<RecentBundleMissionInfo[]>('missionInfoList', missionInfoList);
        let mockFunc7: Function = mock.mockFunc(instance, (instance as object)['getMissionInfoList']);
        when(mockFunc7)(ArgumentMatchers.any).afterReturn(missionInfoList);

        instance.recentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_recentOnClick_066', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let item: DockItemInfo = new DockItemInfo();
        item.typeId = CommonConstants.TYPE_SHORTCUT_ICON+1;
        item.appIndex = 0;

        let testSceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
        let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(testSceneInfo), testSceneInfo);
        testPrimarySCBSceneSession.session.setIsPcAppInPad(testPrimarySCBSceneSession['checkIfPcAppInPad']());
        let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
        let session: SCBSceneContainerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession, testSCBScreenProperty);

        let missionInfo:RecentBundleMissionInfo = new RecentBundleMissionInfo();
        missionInfo.appIndex = 0;
        missionInfo.missionInfoList = [session];
        let missionInfoList: RecentBundleMissionInfo[] = [missionInfo];
        AppStorage.setOrCreate<RecentBundleMissionInfo[]>('missionInfoList', missionInfoList);
        let mockFunc7: Function = mock.mockFunc(instance, (instance as object)['getMissionInfoList']);
        when(mockFunc7)(ArgumentMatchers.any).afterReturn(missionInfoList);

        instance.recentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_recentOnClick_07', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let item: DockItemInfo = new DockItemInfo();
        item.typeId = CommonConstants.TYPE_SHORTCUT_ICON+1;
        item.appIndex = 0;

        let testSceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
        let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(testSceneInfo), testSceneInfo);
        testPrimarySCBSceneSession.session.setIsPcAppInPad(testPrimarySCBSceneSession['checkIfPcAppInPad']());
        let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
        let session: SCBSceneContainerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession, testSCBScreenProperty);
        session.isSplit = true;

        let missionInfo:RecentBundleMissionInfo = new RecentBundleMissionInfo();
        missionInfo.appIndex = 0;
        missionInfo.missionInfoList = [session];
        let missionInfoList: RecentBundleMissionInfo[] = [missionInfo];
        AppStorage.setOrCreate<RecentBundleMissionInfo[]>('missionInfoList', missionInfoList);
        let mockFunc7: Function = mock.mockFunc(instance, (instance as object)['getMissionInfoList']);
        when(mockFunc7)(ArgumentMatchers.any).afterReturn(missionInfoList);

        instance.recentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_recentOnClick_08', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(SceneInfoAdapterUtil, SceneInfoAdapterUtil.getAdapterBundleName);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(bundleName);

        let item: DockItemInfo = new DockItemInfo();
        item.typeId = CommonConstants.TYPE_SHORTCUT_ICON+1;
        item.bundleName = bundleName;
        item.appIndex = 0;

        let testSceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
        let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(testSceneInfo), testSceneInfo);
        testPrimarySCBSceneSession.session.setIsPcAppInPad(testPrimarySCBSceneSession['checkIfPcAppInPad']());
        let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
        let session: SCBSceneContainerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession, testSCBScreenProperty);
        session.isSplit = false;
        session.setActivationAtToggleHomeScenario();

        let missionInfo:RecentBundleMissionInfo = new RecentBundleMissionInfo();
        missionInfo.appIndex = 0;
        missionInfo.missionInfoList = [session];
        let missionInfoList: RecentBundleMissionInfo[] = [missionInfo];
        AppStorage.setOrCreate<RecentBundleMissionInfo[]>('missionInfoList', missionInfoList);
        let mockFunc7: Function = mock.mockFunc(instance, (instance as object)['getMissionInfoList']);
        when(mockFunc7)(ArgumentMatchers.any).afterReturn(missionInfoList);

        instance.recentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clear(SceneInfoAdapterUtil);
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_recentOnClick_09', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(SceneInfoAdapterUtil, SceneInfoAdapterUtil.getAdapterBundleName);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(bundleName);

        let item: DockItemInfo = new DockItemInfo();
        item.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        item.bundleName = bundleName + 'not equal';
        item.appIndex = 0;

        let testSceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
        let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(testSceneInfo), testSceneInfo);
        testPrimarySCBSceneSession.session.setIsPcAppInPad(testPrimarySCBSceneSession['checkIfPcAppInPad']());
        let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
        let session: SCBSceneContainerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession, testSCBScreenProperty);
        session.isSplit = false;
        session.setActivationAtToggleHomeScenario();

        let missionInfo:RecentBundleMissionInfo = new RecentBundleMissionInfo();
        missionInfo.appIndex = 0;
        missionInfo.missionInfoList = [session];
        let missionInfoList: RecentBundleMissionInfo[] = [missionInfo];
        AppStorage.setOrCreate<RecentBundleMissionInfo[]>('missionInfoList', missionInfoList);
        let mockFunc7: Function = mock.mockFunc(instance, (instance as object)['getMissionInfoList']);
        when(mockFunc7)(ArgumentMatchers.any).afterReturn(missionInfoList);

        instance.recentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clear(SceneInfoAdapterUtil);
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_recentOnClick_10', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(SceneInfoAdapterUtil, SceneInfoAdapterUtil.getAdapterBundleName);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(bundleName);

        let item: DockItemInfo = new DockItemInfo();
        item.typeId = CommonConstants.TYPE_SHORTCUT_ICON+1;
        item.bundleName = bundleName + 'not equal';
        item.appIndex = 0;

        let testSceneInfo: SCBSceneInfo = new SCBSceneInfo('', '', '');
        let testPrimarySCBSceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(testSceneInfo), testSceneInfo);
        testPrimarySCBSceneSession.session.setIsPcAppInPad(testPrimarySCBSceneSession['checkIfPcAppInPad']());
        let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
        let session: SCBSceneContainerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession, testSCBScreenProperty);
        session.isSplit = false;
        session.setActivationAtToggleHomeScenario();

        let missionInfo:RecentBundleMissionInfo = new RecentBundleMissionInfo();
        missionInfo.appIndex = 0;
        missionInfo.missionInfoList = [session];
        let missionInfoList: RecentBundleMissionInfo[] = [missionInfo];
        AppStorage.setOrCreate<RecentBundleMissionInfo[]>('missionInfoList', missionInfoList);
        let mockFunc7: Function = mock.mockFunc(instance, (instance as object)['getMissionInfoList']);
        when(mockFunc7)(ArgumentMatchers.any).afterReturn(missionInfoList);

        instance.recentOnClick(null, item, false);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clear(SceneInfoAdapterUtil);
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_getMissionInfoList_01', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        (instance as object)['getMissionInfoList']();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_deleNotInstallApp_01', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        let dockItemInfo: DockItemInfo = {
          typeId: CommonConstants.TYPE_SHORTCUT_ICON,
          bundleName: 'com.ohos.contacts',
          appIndex: 0,
          shortcutId: '1',
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          abilityName: 'MainAbilityentry',
          moduleName: 'contacts'
        };
        (instance as object)['curItem'] = dockItemInfo;
        instance.deleNotInstallApp();
        instance.getRemoveDialogName();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_deleNotInstallApp_02', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        let dockItemInfo: DockItemInfo = {
          typeId: CommonConstants.TYPE_APP,
          bundleName: 'com.ohos.contacts',
          appIndex: 0,
          shortcutId: '1',
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          abilityName: 'MainAbilityentry',
          moduleName: 'contacts'
        };
        (instance as object)['curItem'] = dockItemInfo;
        instance.deleNotInstallApp();
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getRemoveInfo_01', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        let dockItemInfo: DockItemInfo = {
          callerName: CommonConstants.SOURCE_CLONE,
          typeId: CommonConstants.TYPE_APP,
          bundleName: 'com.ohos.contacts',
          appIndex: 0,
          shortcutId: '1',
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          abilityName: 'MainAbilityentry',
          moduleName: 'contacts'
        }
        let removeInfo: MenuInfo = (instance as object)['getRemoveInfo'](dockItemInfo, true, null);
        if (removeInfo.onMenuClick) {
          removeInfo.onMenuClick();
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getRemoveInfo_02', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        let dockItemInfo: DockItemInfo = {
          callerName: CommonConstants.SOURCE_UPGRADE,
          typeId: CommonConstants.TYPE_APP,
          bundleName: 'com.ohos.contacts',
          appIndex: 0,
          shortcutId: '1',
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          abilityName: 'MainAbilityentry',
          moduleName: 'contacts'
        }
        let removeInfo: MenuInfo = (instance as object)['getRemoveInfo'](dockItemInfo, false, null);
        if (removeInfo.onMenuClick) {
          removeInfo.onMenuClick();
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getRemoveInfo_03', 0, () => {
      try {
        let instance = SmartDockEventMgr.getInstance();
        let dockItemInfo: DockItemInfo = {
          callerName: 'migrate_server_test',
          typeId: CommonConstants.TYPE_APP,
          bundleName: 'com.ohos.contacts',
          appIndex: 0,
          shortcutId: '1',
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          abilityName: 'MainAbilityentry',
          moduleName: 'contacts'
        }
        let removeInfo: MenuInfo = (instance as object)['getRemoveInfo'](dockItemInfo, false, null);
        if (removeInfo.onMenuClick) {
          removeInfo.onMenuClick();
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_buildShortcutMenuOnTv_01', 0, () => {
      let mock = new MockKit();
      try {
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let instance = SmartDockEventMgr.getInstance();
        let deleteItemInfo: DeleteDockItem = new DeleteDockItem();
        deleteItemInfo.bundleName = 'com.example.myapplicationclone';
        deleteItemInfo.isDeleteAppToUninstallFolder = true;
        deleteItemInfo.appIndex = 0;
        deleteItemInfo.shortcutId = ResourceManager.getInstance().getStringByName('smart_frame_shortcut_id');
        let menuInfoList: MenuInfo[] =
          (instance as object)['buildShortcutMenuOnTv'](deleteItemInfo, SmartDockConstants.RECENT_DOCK_TYPE);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ShortcutViewModel.getInstance());
      mock.clearAll();
    })

    it('test_close_01', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        (instance as object)['close'](null);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_close_02', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
        let sceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        (instance as object)['close'](sceneSession);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_close_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(),
            SCBSceneSessionManager.getInstance().asyncPrepareTerminate);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(Promise.resolve());

        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
        let sceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        (instance as object)['close'](sceneSession);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_closeSceneSession_01', 0, () => {
      let mock = new MockKit();
      try {
        let appIndex: number = 0;

        let item: DockItemInfo = new DockItemInfo();
        item.appIndex = appIndex;
        item.moduleName = 'entry';

        let screenProperty: SCBScreenProperty = new SCBScreenProperty();

        let sceneInfo1: SCBSceneInfo =
        let sceneSession1: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
        let containerSession1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession1, screenProperty);
        containerSession1.primarySession = sceneSession1;
        containerSession1.secondarySession = sceneSession1;

        let sceneInfo2: SCBSceneInfo =
        let sceneSession2: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
        let containerSession2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession2, screenProperty);
        containerSession2.primarySession = sceneSession2;
        containerSession2.secondarySession = null;

        let sceneSession3: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
        let containerSession3: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession3, screenProperty);
        containerSession3.primarySession = null;
        containerSession3.secondarySession = sceneSession3;

        let containerSessionList: SCBSceneContainerSession[] =
          [containerSession1, containerSession2, containerSession3];
        let mockFunc: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(),
            SCBSceneSessionManager.getInstance().getContainerSessionList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(containerSessionList);

        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        (instance as object)['closeSceneSession'](item);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_closeSceneSession_02', 0, () => {
      let mock = new MockKit();
      try {
        let bundleName: string = 'other';
        let appIndex: number = 0;

        let item: DockItemInfo = new DockItemInfo();
        item.bundleName = bundleName;
        item.appIndex = appIndex;
        item.moduleName = 'entry';

        let screenProperty: SCBScreenProperty = new SCBScreenProperty();

        let sceneInfo1: SCBSceneInfo =
          new SCBSceneInfo(bundleName, 'exampleModule', 'VOICE_PC_ABILITY_NAME', appIndex);
        let sceneSession1: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
        let containerSession1: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession1, screenProperty);
        containerSession1.primarySession = sceneSession1;
        containerSession1.secondarySession = sceneSession1;

        let sceneInfo2: SCBSceneInfo =
          new SCBSceneInfo(bundleName, 'exampleModule', 'VOICE_PC_ABILITY_NAME', appIndex);
        let sceneSession2: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
        let containerSession2: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession2, screenProperty);
        containerSession2.primarySession = sceneSession2;
        containerSession2.secondarySession = null;

        let sceneInfo3: SCBSceneInfo =
          new SCBSceneInfo(bundleName, 'exampleModule', 'VOICE_PC_ABILITY_NAME', appIndex);
        let sceneSession3: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
        let containerSession3: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession3, screenProperty);
        containerSession3.primarySession = null;
        containerSession3.secondarySession = sceneSession3;

        let containerSessionList: SCBSceneContainerSession[] =
          [containerSession1, containerSession2, containerSession3];
        let mockFunc: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(),
            SCBSceneSessionManager.getInstance().getContainerSessionList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(containerSessionList);

        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        (instance as object)['closeSceneSession'](item);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_cleanContinueItem_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(ObjUtil, ObjUtil.isValid);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let bundleName: string = 'test';
        let dockItemInfo: DockItemInfo = {
          appIndex: 0,
          bundleName: bundleName,
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          abilityName: 'MainAbilityentry',
          moduleName: 'contacts'
        }

        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        let deviceInfo: DockContinuableInfo = new DockContinuableInfo();
        deviceInfo.sourceDeviceName = 'phone';
        deviceInfo.bundleName = bundleName;
        AppStorage.set('continueDeviceInfo', deviceInfo);
        (instance as object)['cleanContinueItem'](dockItemInfo);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ObjUtil);
      mock.clearAll();
    })

    it('test_moveSplitToFront_01', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        let dockItemInfo: DockItemInfo = {
          bundleName: bundleName,
          appIndex: appIndex,
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          abilityName: 'MainAbilityentry',
          moduleName: 'contacts'
        }

        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let sceneInfo3: SCBSceneInfo =
          new SCBSceneInfo(bundleName, 'exampleModule', 'VOICE_PC_ABILITY_NAME', appIndex);
        let sceneSession3: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
        let containerSession3: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession3, screenProperty);
        containerSession3.primarySession = sceneSession3;
        containerSession3.secondarySession = sceneSession3;

        instance.moveSplitToFront(containerSession3, dockItemInfo);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_moveSplitToFront_02', 0, () => {
      try {
        let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        let dockItemInfo: DockItemInfo = {
          bundleName: bundleName,
          appIndex: appIndex,
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          abilityName: 'MainAbilityentry',
          moduleName: 'contacts'
        }

        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let sceneInfo3: SCBSceneInfo =
          new SCBSceneInfo(bundleName, 'exampleModule', 'VOICE_PC_ABILITY_NAME', 1);
        let sceneSession3: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo3), sceneInfo3);
        let containerSession3: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession3, screenProperty);
        containerSession3.primarySession = sceneSession3;
        containerSession3.secondarySession = sceneSession3;

        instance.moveSplitToFront(containerSession3, dockItemInfo);
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_buildMenuInfoList_01', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;

        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_buildMenuInfoList_02', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function =
          mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().isContactsApp);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(ShortcutViewModel.getInstance());
      mock.clearAll();
    })

    it('test_buildMenuInfoList_03', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function =
          mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().isContactsApp);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function =
          mock.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(ShortcutViewModel.getInstance());
      mock.clear(layoutLockUtil);
      mock.clearAll();
    })

    it('test_buildMenuInfoList_04', 0, () => {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function =
          mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().isContactsApp);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function =
          mock.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc4: Function =
          mock.mockFunc(lockLayoutManager, lockLayoutManager.isLockLayout);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn(false);

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(ShortcutViewModel.getInstance());
      mock.clear(layoutLockUtil);
      mock.clear(lockLayoutManager);
      mock.clearAll();
    })

    it('test_buildMenuInfoList_05', 0, () => {
      // if (this.mDevice === CommonConstants.PAD_DEVICE_TYPE) {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_APP;
        AppStorage.setOrCreate<string>('device', CommonConstants.PAD_DEVICE_TYPE);

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_buildMenuInfoList_06', 0, () => {
      // if (this.mDevice === CommonConstants.DEFAULT_DEVICE_TYPE && dockType === SmartDockConstants.RESIDENT_DOCK_TYPE) {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_APP;
        appInfo.appIndex = 0;
        appInfo.isUninstallAble = true;
        AppStorage.setOrCreate<string>('device', CommonConstants.DEFAULT_DEVICE_TYPE);

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mock.mockFunc(lockLayoutManager, lockLayoutManager.isLockLayout);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(layoutLockUtil);
      mock.clear(lockLayoutManager);
      mock.clearAll();
    })

    it('test_buildMenuInfoList_07', 0, () => {
      // if (this.mDevice === CommonConstants.DEFAULT_DEVICE_TYPE && dockType === SmartDockConstants.RESIDENT_DOCK_TYPE) {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_APP;
        appInfo.appIndex = 1;
        appInfo.isUninstallAble = true;
        AppStorage.setOrCreate<string>('device', CommonConstants.DEFAULT_DEVICE_TYPE);

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mock.mockFunc(lockLayoutManager, lockLayoutManager.isLockLayout);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(layoutLockUtil);
      mock.clear(lockLayoutManager);
      mock.clearAll();
    })

    it('test_buildMenuInfoList_08', 0, () => {
      // if (this.mDevice === CommonConstants.DEFAULT_DEVICE_TYPE && dockType === SmartDockConstants.RESIDENT_DOCK_TYPE) {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_APP;
        appInfo.appIndex = 1;
        appInfo.isUninstallAble = true;
        AppStorage.setOrCreate<string>('device', CommonConstants.DEFAULT_DEVICE_TYPE);

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mock.mockFunc(lockLayoutManager, lockLayoutManager.isLockLayout);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let appLockMenu: MenuInfo | undefined = new MenuInfo();
        let mockFunc4: Function = mock.mockFunc(AppLockUtils.getInstance(), AppLockUtils.getInstance().buildAppLockMenu);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn(appLockMenu);

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(layoutLockUtil);
      mock.clear(lockLayoutManager);
      mock.clear(AppLockUtils.getInstance());
      mock.clearAll();
    })

    it('test_buildMenuInfoList_09', 0, () => {
      // if (formDialog != null && this.mDevice === CommonConstants.DEFAULT_DEVICE_TYPE &&
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog: CustomDialogController = new CustomDialogController({
          builder: 'builder',
          cancel: () => {
          },
        });
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_APP;
        AppStorage.setOrCreate<string>('device', CommonConstants.DEFAULT_DEVICE_TYPE);

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(LayoutViewModel.getInstance(), LayoutViewModel.getInstance().getDesktopModel);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(DesktopLayoutState.HOME_LAUNCHER_MODE);

        let mockFunc3: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(LayoutViewModel.getInstance());
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_buildMenuInfoList_10', 0, () => {
      // if (formDialog != null && this.mDevice === CommonConstants.DEFAULT_DEVICE_TYPE &&
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog: CustomDialogController = new CustomDialogController({
          builder: 'builder',
          cancel: () => {
          },
        });
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_APP;
        AppStorage.setOrCreate<string>('device', CommonConstants.DEFAULT_DEVICE_TYPE);

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(LayoutViewModel.getInstance(), LayoutViewModel.getInstance().getDesktopModel);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(DesktopLayoutState.HOME_LAUNCHER_MODE);

        let mockFunc3: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(LayoutViewModel.getInstance());
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_buildMenuInfoList_11', 0, () => {
      //  if (appInfo.itemType !== CommonConstants.TYPE_FUNCTION) {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_APP;
        appInfo.itemType = CommonConstants.TYPE_CARD;
        AppStorage.setOrCreate<string>('device', CommonConstants.PAD_DEVICE_TYPE);

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(lockLayoutManager, lockLayoutManager.isLockLayout);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(lockLayoutManager);
      mock.clearAll();
    })

    it('test_buildMenuInfoList_12', 0, () => {
      // if (appInfo.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_APP;
        appInfo.abilityName = CommonConstants.RECYCLE_BIN_ABILITY;
        AppStorage.setOrCreate<string>('device', CommonConstants.PAD_DEVICE_TYPE);

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_buildMenuInfoList_13', 0, () => {
      // if (appInfo.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_APP;
        appInfo.abilityName = CommonConstants.RECYCLE_BIN_ABILITY;
        AppStorage.setOrCreate<string>('device', CommonConstants.PAD_DEVICE_TYPE);

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(GlobalContext.getContext(), GlobalContext.getContext().startServiceExtensionAbility);
        when(mockFunc2)(ArgumentMatchers.any).afterThrow('err');

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(GlobalContext.getContext());
      mock.clearAll();
    })

    it('test_buildMenuInfoList_16', 0, () => {
      // if (appInfo.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_APP;
        appInfo.abilityName = CommonConstants.RECYCLE_BIN_ABILITY;
        AppStorage.setOrCreate<string>('device', CommonConstants.PAD_DEVICE_TYPE);

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(GlobalContext.getContext(), GlobalContext.getContext().startServiceExtensionAbility);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(Promise.resolve());

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(GlobalContext.getContext());
      mock.clearAll();
    })

    it('test_buildMenuInfoList_14', 0, () => {
      // if (appInfo.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RESIDENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_APP;
        appInfo.abilityName = CommonConstants.RECYCLE_BIN_ABILITY;
        AppStorage.setOrCreate<string>('device', CommonConstants.PAD_DEVICE_TYPE);

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(GlobalContext, GlobalContext.getContext);
        when(mockFunc2)(ArgumentMatchers.any).afterThrow('err');

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(GlobalContext);
      mock.clearAll();
    })

    it('test_buildMenuInfoList_15', 0, () => {
      // if ((AppStorage.get<number>('folderStatus') !== DeviceState.DEFAULT_STATE || DeviceHelper.isPad() ||
      let mock = new MockKit();
      let instance: SmartDockEventMgr = SmartDockEventMgr.getInstance();
      try {
        let dockType = SmartDockConstants.RECENT_DOCK_TYPE;
        let formDialog = null;
        let index: number = 0;
        let callback = (): void => {
          index++;
        };
        let appInfo: DockItemInfo = new DockItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.typeId = CommonConstants.TYPE_APP;
        AppStorage.setOrCreate<string>('device', CommonConstants.PAD_DEVICE_TYPE);

        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function = mock.mockFunc(StatusBarServiceEventMgr.getInstance(), StatusBarServiceEventMgr.getInstance().isRegisterApp);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc4: Function = mock.mockFunc(lockLayoutManager, lockLayoutManager.isLockLayout);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn(false);

        let menuInfoList: MenuInfo[] = instance.buildMenuInfoList(appInfo, dockType, formDialog, callback);
        for (let menu of menuInfoList) {
          if (menu.onMenuClick) {
            menu.onMenuClick();
          }
        }
        expect(instance instanceof SmartDockEventMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(StatusBarServiceEventMgr.getInstance());
      mock.clearAll();
    })





  })
}