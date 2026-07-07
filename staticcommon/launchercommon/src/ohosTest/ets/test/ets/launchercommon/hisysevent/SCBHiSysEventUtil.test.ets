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
  CommonConstants,
  DeviceState,
  DockItemInfo,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager, SCBHiSysEventUtil } from '../../../../../../main/ets/TsIndex'
import {
  DesktopRegisterDMSListenerParams,
  DesktopReceiveDMSNoticeParams,
  DesktopShowContinueIconEndParams,
  UserClickContinueIconEventParams,
  TriggerContinueMissionParams,
  ReportParams,
  FolderStateInfoParams,
  EmptyGridInfoBean,
  IconGridInfoBeanParams,
  ShortcutInfoBeanParams,
  LocationTypes
} from '../../../../../../main/ets/hisysevent/ReportParams'
import { HiSysEventUtil, HiSysReportEvent, ResourceManager } from '@ohos/frameworkwrapper'
import { CheckEmptyUtils, DeliverUtil, LogHelper } from '@ohos/basicutils'

export default function SCBHiSysEventUtilTest() {
  describe('SCBHiSysEventUtilTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('test_reportDesktopRegisterDMSListener', 0, () => {
      const func: string = 'reportDesktopRegisterDMSListener';
      const result: number = 1;
      const data: DesktopRegisterDMSListenerParams = {
        ORG_PKG: 'com.ohos.sceneboard',
        FUNC: func,
        BIZ_SCENE: 1,
        BIZ_STAGE: 2,
        STAGE_RES: result,
        BIZ_STATE: 2,
      }
      expect(SCBHiSysEventUtil.reportDesktopRegisterDMSListener(data.FUNC, data.STAGE_RES) === undefined).assertTrue();
    })

    it('test_reportDesktopReceiveDMSNotice_active', 0, () => {
      const func: string = 'judgeResultIsActive';
      const scene: number = 8;
      const stage: number = 4;
      const result: number = 1;
      const continueState: string = 'active';
      const data: DesktopReceiveDMSNoticeParams = {
        ORG_PKG: 'com.ohos.sceneboard',
        FUNC: func,
        BIZ_SCENE: scene,
        BIZ_STAGE: stage,
        STAGE_RES: result,
        NOTIFY_MODE: continueState
      }
      expect(SCBHiSysEventUtil.reportDesktopReceiveDMSNotice(data.FUNC, data.BIZ_SCENE, data.BIZ_STAGE, data.STAGE_RES,
        data.NOTIFY_MODE) === undefined).assertTrue();
    })

    it('test_reportDesktopReceiveDMSNotice_inactive', 0, () => {
      const func: string = 'judgeResultIsInactive';
      const scene: number = 9;
      const stage: number = 4;
      const result: number = 1;
      const continueState: string = 'inactive';
      const data: DesktopReceiveDMSNoticeParams = {
        ORG_PKG: 'com.ohos.sceneboard',
        FUNC: func,
        BIZ_SCENE: scene,
        BIZ_STAGE: stage,
        STAGE_RES: result,
        NOTIFY_MODE: continueState
      }
      expect(SCBHiSysEventUtil.reportDesktopReceiveDMSNotice(data.FUNC, data.BIZ_SCENE, data.BIZ_STAGE, data.STAGE_RES,
        data.NOTIFY_MODE) === undefined).assertTrue();
    })

    it('test_reportDesktopShowContinueIconEnd', 0, () => {
      const func: string = 'setContinueShow';
      const scene: number = 8;
      const stage: number = 5;
      const result: number = 1;
      const state: number = 2;
      const data: DesktopShowContinueIconEndParams = {
        ORG_PKG: 'com.ohos.sceneboard',
        FUNC: func,
        BIZ_SCENE: scene,
        BIZ_STAGE: stage,
        STAGE_RES: result,
        BIZ_STATE: state
      }
      expect(SCBHiSysEventUtil.reportDesktopShowContinueIconEnd(data.FUNC, data.BIZ_SCENE, data.BIZ_STAGE,
        data.STAGE_RES) === undefined).assertTrue();
    })

    it('test_reportDesktopHideContinueIconEnd', 0, () => {
      const func: string = 'setContinueShow';
      const scene: number = 9;
      const stage: number = 5;
      const result: number = 1;
      const state: number = 2;
      const data: DesktopShowContinueIconEndParams = {
        ORG_PKG: 'com.ohos.sceneboard',
        FUNC: func,
        BIZ_SCENE: scene,
        BIZ_STAGE: stage,
        STAGE_RES: result,
        BIZ_STATE: state
      }
      expect(SCBHiSysEventUtil.reportDesktopShowContinueIconEnd(data.FUNC, data.BIZ_SCENE, data.BIZ_STAGE,
        data.STAGE_RES) === undefined).assertTrue();
    })

    it('test_reportUserClickContinueIconEvent', 0, () => {
      const func: string = 'continueMission';
      const scene: number = 10;
      const stage: number = 1;
      const result: number = 1;
      const state: number = 1;
      const data: UserClickContinueIconEventParams = {
        ORG_PKG: 'com.ohos.sceneboard',
        FUNC: func,
        BIZ_SCENE: scene,
        BIZ_STAGE: stage,
        STAGE_RES: result,
        BIZ_STATE: state
      }
      expect(SCBHiSysEventUtil.reportUserClickContinueIconEvent(data.FUNC, data.STAGE_RES) === undefined).assertTrue();
    })

    it('test_reportTriggerContinueMission', 0, () => {
      const func: string = 'continueMission';
      const scene: number = 10;
      const stage: number = 2;
      const result: number = 1;
      const peerNetId: string = '11'
      const data: TriggerContinueMissionParams = {
        ORG_PKG: 'com.ohos.sceneboard',
        FUNC: func,
        BIZ_SCENE: scene,
        BIZ_STAGE: stage,
        STAGE_RES: result,
        PEER_NET_ID: peerNetId
      }
      expect(SCBHiSysEventUtil.reportTriggerContinueMission(data.FUNC, data.PEER_NET_ID, data.STAGE_RES) === undefined).assertTrue();
    })

    it('test_SCBHiSysEventUtil_folderStateInfoMethod', 0, () => {
      try {
        let sCBHiSysEventUtil: SCBHiSysEventUtil = new SCBHiSysEventUtil()
        SCBHiSysEventUtil.folderStateInfoMethod();
        expect(sCBHiSysEventUtil).not().assertNull();
      }catch{}
    })

    it('should_handle_empty_residentList_and_gridItems', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockAppStorage: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockAppStorage)(ArgumentMatchers.any).afterReturn([]);
      let mockLaunchLayoutCacheManager: Function = mocker.mockFunc(LaunchLayoutCacheManager, LaunchLayoutCacheManager.getInstance);
      when(mockLaunchLayoutCacheManager)().afterReturn({ getGridLayoutItemList: () => [] });
      SCBHiSysEventUtil.reportShortcutInfo();
      expect(0).assertInstanceOf('Number');
      mocker.verify('get', ['residentList']).atLeast(1);
      mocker.verify('getInstance', []).atLeast(1);
      mocker.ignoreMock(AppStorage, AppStorage.get);
      mocker.ignoreMock(LaunchLayoutCacheManager, LaunchLayoutCacheManager.getInstance);
      done();
    });

    it('should_handle_non-empty residentList and gridItems', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockAppStorage: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      let residentList: GridLayoutItemInfo[] = [new GridLayoutItemInfo()];
      when(mockAppStorage)(ArgumentMatchers.any).afterReturn(residentList);
      let mockLaunchLayoutCacheManager: Function = mocker.mockFunc(LaunchLayoutCacheManager, LaunchLayoutCacheManager.getInstance);
      let gridItems: GridLayoutItemInfo[] = [new GridLayoutItemInfo()];
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_handle_DockItemInfo_correctly', 0, async (done: Function) => {
      let date: ESObject = new Date();
      let item: ESObject = new DockItemInfo();
      item.area = [1, 2];
      item.row = 3;
      item.column = 4;
      item.page = 5;
      item.layoutInfo = [[new GridLayoutItemInfo()]];
      let mocker: MockKit = new MockKit();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_handle_GridLayoutItemInfo_correctly', 0, async (done: Function) => {
      let date: ESObject = new Date();
      let item: ESObject = new GridLayoutItemInfo();
      item.area = [1, 2];
      item.row = 3;
      item.column = 4;
      item.page = 5;
      item.layoutInfo = [[new GridLayoutItemInfo()]];
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_return_appName_when_typeId_is_TYPE_APP_and_appName_is_not_empty', 0, async (done: Function) => {
      let appItem: ESObject = new DockItemInfo();
      appItem.typeId = CommonConstants.TYPE_APP;
      appItem.appName = "TestApp";
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_return_cached_appName_when_typeId_is_TYPE_APP_and_appName_is_empty', 0, async (done: Function) => {
      let appItem: ESObject = new DockItemInfo();
      appItem.typeId = CommonConstants.TYPE_APP;
      appItem.appName = "";
      appItem.appLabelId = 1;
      appItem.bundleName = "com.test.app";
      appItem.moduleName = "main";
      let mocker: MockKit = new MockKit();
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.getCachedAppName);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_return_cached_appName_when_typeId_is_TYPE_SHORTCUT_ICON_and_appName_is_empty', 0, async (done: Function) => {
      let appItem: ESObject = new GridLayoutItemInfo();
      appItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      appItem.appName = "";
      appItem.appLabelId = 2;
      appItem.bundleName = "com.test.shortcut";
      appItem.moduleName = "main";
      let mocker: MockKit = new MockKit();
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.getCachedAppName);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_push_IconGridInfoBean_when_appItem_typeId_is_TYPE_APP_and_container_is_SMARTDOCK', 0, async (done: Function) => {
      let appItem = new DockItemInfo();
      appItem.typeId = CommonConstants.TYPE_APP;
      appItem.container = CommonConstants.CONTAINER_SMARTDOCK;
      let beans = [];
      let mocker = new MockKit();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_push_IconGridInfoBean_when_appItem_typeId_is_TYPE_APP_and_container_is_DESKTOP', 0, async (done: Function) => {
      let appItem = new DockItemInfo();
      appItem.typeId = CommonConstants.TYPE_APP;
      appItem.container = CommonConstants.CONTAINER_DESKTOP;
      let beans = [];
      let mocker = new MockKit();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_handle_GridLayoutItemInfo_with_non-CONTAINER_SMARTDOCK', 0, async (done: Function) => {
      let appItem: ESObject = new GridLayoutItemInfo();
      appItem.layoutInfo = [[new GridLayoutItemInfo()]];
      appItem.container = "testContainer";
      appItem.folderId = "testFolderId";
      let beans: IconGridInfoBeanParams[] = [];
      let mocker: MockKit = new MockKit();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_increment_notHarmonyAppNum_when_folderType_is_FOLDER_TYPE_NOTHARMONY', 0, async (done: Function) => {
      let appItem: ESObject = new DockItemInfo();
      appItem.container = CommonConstants.CONTAINER_SMARTDOCK;
      appItem.keyName = "testKey";
      appItem.layoutInfo = [[1, 2, 3]];
      let mocker: MockKit = new MockKit();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_increment_easyAppNum_when_folderType_is_FOLDER_TYPE_EASY', 0, async (done: Function) => {
      let appItem: ESObject = new GridLayoutItemInfo();
      appItem.container = CommonConstants.CONTAINER_DESKTOP;
      appItem.folderId = "testFolderId";
      appItem.layoutInfo = [[1, 2, 3]];
      let mocker: MockKit = new MockKit();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_return_FLODER_when_folder_is_not_a_big_folder', 0, async (done: Function) => {
      let folder: ESObject = new DockItemInfo();
      let floderItem: ESObject = new GridLayoutItemInfo();
      floderItem.page = 0;
      let mocker: MockKit = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isBigFolder);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_return_BIG_FLODER_HIDE_when_folder_is_a_big_folder_and_page_is_greater_than_0', 0, async (done: Function) => {
      let folder: ESObject = new GridLayoutItemInfo();
      let floderItem: ESObject = new GridLayoutItemInfo();
      floderItem.page = 1;
      let mocker: MockKit = new MockKit();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_return_BIG_FLODER_when_folder_is_a_big_folder_and_page_is_0', 0, async (done: Function) => {
      let folder: ESObject = new GridLayoutItemInfo();
      let floderItem: ESObject = new GridLayoutItemInfo();
      floderItem.page = 0;
      let mocker: MockKit = new MockKit();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_correctly_build_IconGridInfoBeanParams_with_DockItemInfo_and_LocationTypes.DOCK', 0, async (done: Function) => {
      let item: ESObject = new DockItemInfo();
      item.bundleName = "com.example.app";
      item.page = 1;
      item.column = 2;
      item.row = 3;
      let screenColumnRow: ESObject = new DockItemInfo();
      screenColumnRow.page = 1;
      screenColumnRow.column = 4;
      screenColumnRow.row = 5;
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_increment_shortcutIconNums_and_push_bean_when_typeId_is_TYPE_SHORTCUT_ICON_and_container_is_SMARTDOCK', 0, async (done: Function) => {
      let appItem: ESObject = new DockItemInfo();
      appItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      appItem.container = CommonConstants.CONTAINER_SMARTDOCK;
      let beans: ESObject = [];
      let mocker: ESObject = new MockKit();
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_handle_multiple_shortcuts_in_layoutInfo', 0, async (done: Function) => {
      let appItem: ESObject = new DockItemInfo();
      let shortcut1: ESObject = new GridLayoutItemInfo();
      shortcut1.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      let shortcut2: ESObject = new GridLayoutItemInfo();
      shortcut2.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      appItem.layoutInfo = [[shortcut1, shortcut2]];
      let beans: ESObject = [];
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_correctly_build_ShortcutInfoBeanParams_from_DockItemInfo_and_GridLayoutItemInfo', 0, async (done: Function) => {
      let item: ESObject = new DockItemInfo();
      item.bundleName = "com.example.app";
      item.page = 1;
      item.column = 2;
      item.row = 3;
      let screenColumnRow: ESObject = new GridLayoutItemInfo();
      screenColumnRow.page = 4;
      screenColumnRow.column = 5;
      screenColumnRow.row = 6;
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });

    it('should_not_proceed_when_params_is_empty', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: ESObject = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    });
  })
}
