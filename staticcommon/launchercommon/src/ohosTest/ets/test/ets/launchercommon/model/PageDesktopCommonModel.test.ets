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
  when
} from '@ohos/hypium'
import { CompanionIconInfo, StartType } from '@ohos/basicutils';
import { DeviceHelper, localEventManager } from '@ohos/frameworkwrapper';
import {
  AbilityItemInfo,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty,
  SCBSceneSessionManager,
  WindowSize
} from '@ohos/windowscene';
import { CommonConstants, PageDesktopModel } from '../../../../../../..'
import HashMap from '@ohos.util.HashMap'
import sceneSessionManager from '@ohos.sceneSessionManager';
import { bundleManager } from '@kit.AbilityKit';
import {
  CloseAppManager,
  DefaultDesktopLayoutInfo,
  DockItemInfo,
  EventConstants,
  GridLayoutItemInfo,
  PageDesktopLayoutConfig,
  ReceiveEventInfo,
  RecentBundleMissionInfo,
  StartSubtype
} from '../../../../../../main/ets/TsIndex';
import { ResidentLayoutCacheMgr } from '../../../../../../main/ets/dock/cache/ResidentLayoutCacheMgr';


export default function PageDesktopCommonModelTest() {

  describe('PageDesktopCommonModelTest', () => {
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
    it('PageDesktopModel_test_getInstance', 0, () => {
      globalThis.PageDesktopModel = null;
      const instance = PageDesktopModel.getInstance();
      expect(globalThis.PageDesktopModel).not().assertNull();
      expect(instance).assertEqual(globalThis.PageDesktopModel);
    })

    it('test_registerPageDesktopItemAddEvent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = PageDesktopModel.getInstance();
      const receivedMap = new HashMap<string, boolean>();
      const mLocalEventListener: ReceiveEventInfo = {
        onReceiveEvent: (event: string, params?: string[]) => {
          console.log('Receive event: ' + event);
          receivedMap[event] = true;
        }
      };
      model.registerPageDesktopItemAddEvent(mLocalEventListener);

      const eventList = [
        EventConstants.EVENT_SMARTDOCK_INIT_FINISHED,
        EventConstants.EVENT_LAYOUT_INIT_FINISHED,
      ];

      for (const eventKey of eventList) {
        expect(receivedMap[eventKey]).assertUndefined();
      }
    })

    it('test_registerPageDesktopBadgeUpdateEvent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = PageDesktopModel.getInstance();
      const receivedMap = new HashMap<string, boolean>();
      const mLocalEventListener: ReceiveEventInfo = {
        onReceiveEvent: (event: string, params?: string[]) => {
          if (EventConstants.EVENT_BADGE_UPDATE === event) {
            receivedMap[event] = true;
          }
        }
      };
      let eventKey = EventConstants.EVENT_BADGE_UPDATE;
      model.registerPageDesktopBadgeUpdateEvent(mLocalEventListener);
      expect(receivedMap.get(eventKey)).assertUndefined();
    })

    it('test_unregisterEventListener', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = PageDesktopModel.getInstance();
      const receivedMap = new HashMap<string, boolean>();
      const mLocalEventListener: ReceiveEventInfo = {
        onReceiveEvent: (event: string, params?: string[]) => {
          receivedMap[event] = true;
        }
      };
      model.registerPageDesktopItemAddEvent(mLocalEventListener);
      model.unregisterEventListener(mLocalEventListener);
      let eventKey = 'anyKeyAsYouLike';
      localEventManager.sendLocalEvent(eventKey);
      expect(receivedMap[eventKey]).assertUndefined();
    })

    it('test_deleteBlankPageFromLayoutInfo', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try {
        let model = PageDesktopModel.getInstance();
        globalThis.PageDesktopLayoutConfigInstance = null;
        const layoutConfig = PageDesktopLayoutConfig.getInstance();

        let retValue = model.deleteBlankPageFromLayoutInfo(CommonConstants.WATERFALL_PAGE_INDEX);
        expect(retValue).assertFalse();

        retValue = model.deleteBlankPageFromLayoutInfo(-1);
        expect(retValue).assertFalse();

        retValue = model.deleteBlankPageFromLayoutInfo(layoutConfig.mGridLayoutInfo.layoutDescription.pageCount);
        expect(retValue).assertFalse();

        retValue = model.deleteBlankPageFromLayoutInfo(layoutConfig.mGridLayoutInfo.layoutDescription.pageCount + 1);
        expect(retValue).assertFalse();
      } catch (e) {
      }
    })

    it('test_isPageBlank_01', 0, () => {
      let model = PageDesktopModel.getInstance();
      const layoutConfig = PageDesktopLayoutConfig.getInstance();
      let retValue = layoutConfig.mGridLayoutInfo.layoutInfo.length;
      expect(retValue === 0).assertTrue();
    })

    it('test_deleteBlankPageFromLayoutInfo_page_blank', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try {
        let model = PageDesktopModel.getInstance();
        globalThis.PageDesktopLayoutConfigInstance = null;
        const layoutConfig = PageDesktopLayoutConfig.getInstance();
        let layoutInfo: GridLayoutItemInfo[] = new Array<GridLayoutItemInfo>(1);
        layoutInfo[0] = new GridLayoutItemInfo();
        layoutInfo[0].page = 1;
        layoutConfig.mGridLayoutInfo.layoutInfo = layoutInfo;

        let retValue_1 = model.deleteBlankPageFromLayoutInfo(1);
        expect(retValue_1).assertFalse();

        let retValue_2 = model.deleteBlankPageFromLayoutInfo(2);
        expect(retValue_2).not().assertUndefined();
      } catch (e) {
      }
    })

    it('test_isPad', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = PageDesktopModel.getInstance();
      if (CommonConstants.PAD_DEVICE_TYPE === AppStorage.get('device')) {
        expect(model.getIsPad()).assertEqual(true);
      } else {
        expect(model.getIsPad()).assertEqual(false);
      }
    })

    it('test_setPageIndex', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = PageDesktopModel.getInstance();
      const pageIndex = model.getPageIndex();
      expect(pageIndex).assertLargerOrEqual(0);

      model.setPageIndex(pageIndex + 1);
      const curValue = model.getPageIndex();
      expect(curValue).assertEqual(pageIndex + 1);
      model.setPageIndex(pageIndex);
    })

    it('test_isInDock', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = PageDesktopModel.getInstance();
      const bundleName = 'bundleNotExists';
      const abilityName = 'abilityNotExists';
      const retValue = model.isInDock(bundleName, abilityName);
      expect(retValue).assertFalse();
    })

    it('test_isInRecentDock', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = PageDesktopModel.getInstance();
      const bundleName = 'bundleNotExists';
      const abilityName = 'abilityNotExists';
      const retValue = model.isInRecentDock(bundleName, abilityName);
      expect(retValue).not().assertNull();
    })

    it('test_getAppInfoFromDock', 0, () => {
      let resistDockItems: DockItemInfo[] = [];
      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      itemInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      itemInfo.abilityName = 'MainAbilityentry';
      resistDockItems.push(itemInfo);

      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', resistDockItems, false);

      let model = PageDesktopModel.getInstance();
      const bundleName = 'com.ohos.contacts';
      const abilityName = 'MainAbilityentry';
      let dockItemInfo: DockItemInfo = {
        bundleName: bundleName,
        abilityName: abilityName,
        appIndex: 0,
        appInstanceKey: '',
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appIconId: 0,
        appName: ''
      }
      const retValue = model.getAppInfoFromDock(dockItemInfo);
      expect(retValue).not().assertNull();
    })

    it('test_isPositionValid', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = PageDesktopModel.getInstance();
      const mGridLayoutInfo: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo()

      class BaseItemInfo {
        area: number[] | undefined;
      };
      let item: BaseItemInfo = {
        area: [1, 1]
      };
      const page = 0;
      const startColumn = 0;
      const startRow = 0;
      let retValue = model.isPositionValid(mGridLayoutInfo, item, page, startColumn, startRow);
      expect(retValue).not().assertNull();

      retValue = model.isPositionValid(mGridLayoutInfo, item, page, 4, startRow);
      expect(retValue).not().assertNull()

      retValue = model.isPositionValid(mGridLayoutInfo, item, page, startColumn, 6);
      expect(retValue).not().assertNull()

      retValue = model.isPositionValid(mGridLayoutInfo, item, 100, startColumn, startRow);
      expect(retValue).not().assertNull()
    })

    it('test_isPositionOccupied', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = PageDesktopModel.getInstance();
      const mGridLayoutInfo: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo()

      class BaseItemInfo {
        area: number[] | undefined;
      };
      let item: BaseItemInfo = {
        area: [1, 1]
      };
      const page = 0;
      const column = 0;
      const row = 0;
      let retValue = model.isPositionValid(mGridLayoutInfo, item, page, column, row);
      expect(retValue).assertTrue();
    })

    it('test_buildAppExitInfo_0', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try {
        let pageDesktopModel = PageDesktopModel.getInstance();
        let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
        let priSceneSession: SCBSceneSession =
          new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(priSceneSession, screenProperty);
        let retValue = pageDesktopModel.buildAppExitInfo(containerSession);
        expect(retValue).not().assertUndefined();
      } catch (e) {
      }
    })

    it('test_buildAppExitInfo_1', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopModel = PageDesktopModel.getInstance();
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(priSceneSession, screenProperty);
      containerSession.companionIconInfo = {
        bundleName: 'sceneInfo.bundleName',
        abilityName: 'sceneInfo.abilityName',
        moduleName: 'sceneInfo.moduleName',
        iconId: 'appIconId',
        iconNumber: 1,
        iconRadius: 1,
        startAppType: StartType.RECENT_DOCK_APP,
        cardId: '1',
        extraId: '1',
      };
      let retValue = pageDesktopModel.buildAppExitInfo(containerSession);
      expect(retValue).not().assertUndefined();
    })

    it('test_buildAppExitInfo_2', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopModel = PageDesktopModel.getInstance();
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(priSceneSession, screenProperty);
      containerSession.companionIconInfo = {
        bundleName: 'sceneInfo.bundleName',
        abilityName: 'sceneInfo.abilityName',
        moduleName: 'sceneInfo.moduleName',
        iconId: 'appIconId',
        iconNumber: 2,
        iconRadius: 2,
        startAppType: StartType.DOCK_APP,
        cardId: '2',
        extraId: '2',
      };
      let retValue = pageDesktopModel.buildAppExitInfo(containerSession);
      expect(retValue).not().assertUndefined();
    })

    it('test_onTransitionActive_0', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopModel = PageDesktopModel.getInstance();
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(priSceneSession, screenProperty);
      containerSession.companionIconInfo = {
        bundleName: 'sceneInfo.bundleName',
        abilityName: 'sceneInfo.abilityName',
        moduleName: 'sceneInfo.moduleName',
        iconId: 'appIconId',
        iconNumber: 2,
        iconRadius: 2,
        startAppType: StartType.DOCK_APP,
        cardId: '2',
        extraId: '2',
      };
      let isInScreen = false;
      pageDesktopModel.onTransitionActive(containerSession, isInScreen);
      expect(pageDesktopModel).not().assertNull();
    })

    it('test_onTransitionActive_1', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopModel = PageDesktopModel.getInstance();
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(priSceneSession, screenProperty);
      containerSession.companionIconInfo = {
        bundleName: 'sceneInfo.bundleName',
        abilityName: 'sceneInfo.abilityName',
        moduleName: 'sceneInfo.moduleName',
        iconId: 'appIconId',
        iconNumber: 3,
        iconRadius: 3,
        startAppType: StartType.DOCK_APP,
        cardId: '3',
        extraId: '3',
      };
      let isInScreen = true;
      pageDesktopModel.onTransitionActive(containerSession, isInScreen);
      expect(pageDesktopModel).not().assertNull();
    })

    it('test_onTransitionActive_2', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopModel = PageDesktopModel.getInstance();
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(priSceneSession, screenProperty);
      containerSession.companionIconInfo = {
        bundleName: 'sceneInfo.bundleName',
        abilityName: 'sceneInfo.abilityName',
        moduleName: 'sceneInfo.moduleName',
        iconId: '',
        iconNumber: 4,
        iconRadius: 4,
        startAppType: StartType.DOCK_APP,
        cardId: '3',
        extraId: '3',
      };
      let isInScreen = false;
      pageDesktopModel.onTransitionActive(containerSession, isInScreen);
      expect(pageDesktopModel).not().assertNull();
    })

    it('test_updateBlankPage_NoBlankPage', 0, () => {
      try {
        let model = PageDesktopModel.getInstance();
        globalThis.PageDesktopLayoutConfigInstance = null;
        let mGridLayoutInfo = PageDesktopLayoutConfig.getInstance().mGridLayoutInfo;
        let oldPageCount: number = mGridLayoutInfo.layoutDescription.pageCount;
        const pageItemMap: Map<string, number> = new Map();
        pageItemMap.set('0', 3);
        pageItemMap.set('1', 5);
        pageItemMap.set('2', 6);
        model.updateBlankPage(pageItemMap);
        let newPageCount: number = mGridLayoutInfo.layoutDescription.pageCount;
        expect(newPageCount <= oldPageCount).assertTrue();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_getCloseAppData', 0, () => {
      let model = PageDesktopModel.getInstance();

      AppStorage.setOrCreate('openFolderId', '0');

      let bundleName: string = CommonConstants.FILE_MANAGER_BUNDLE;
      let abilityName: string = 'MainAbility';
      let appData = model.getCloseAppData(bundleName, abilityName);
      expect(appData.bundleName).assertEqual(bundleName);
    })

    it('test_getCloseAppData_1', 0, () => {
      let model = PageDesktopModel.getInstance();

      AppStorage.set('openFolderId', null);

      let bundleName: string = CommonConstants.FILE_MANAGER_BUNDLE;
      let abilityName: string = 'MainAbility';
      let startType: StartType = StartType.CARD;
      let appData = model.getCloseAppData(bundleName, abilityName, startType);

      let formCardId: string = '1';
      let appData2 = model.getCloseAppData(bundleName, abilityName, startType, formCardId, null);

      startType = StartType.AI_SUGGESTION_APP;
      let appData3 = model.getCloseAppData(bundleName, abilityName, startType, formCardId, null);

      let screenId: number = 0;
      let appData4 = model.getCloseAppData(bundleName, abilityName, startType, formCardId, null, screenId);

      expect(appData.bundleName).assertEqual(bundleName);
      expect(appData2.bundleName).assertEqual(bundleName);
      expect(appData3.bundleName).assertEqual(bundleName);
      expect(appData4.bundleName).assertEqual(bundleName);
    })

    it('test_getSceneLaunchType_0', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.ICON_FROM_APP_CENTER);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: '',
        abilityName: '',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: ''
      }
      try {
        expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(closeAppManager);
      mocker.clearAll();
    })

    it('test_getSceneLaunchType_1', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_RIGHT_MENU);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: '',
        abilityName: '',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: ''
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('START_APP_ANI_MENU');
      mocker.clear(closeAppManager);
      mocker.clearAll();
    })

    it('test_getSceneLaunchType_2', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: ''
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
      mocker.clearAll();
    })

    it('test_getSceneLaunchType_3', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      itemInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      itemInfo.abilityName = 'MainAbilityentry';

      let residentList: DockItemInfo[] = new Array<DockItemInfo>();
      residentList.push(itemInfo);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbilityentry',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: ''
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_DOCK');
      mocker.clear(closeAppManager);
      mocker.clearAll();
    })

    it('test_getSceneLaunchType_4', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      itemInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      itemInfo.abilityName = 'MainAbilityentry';

      let residentList: DockItemInfo[] = new Array<DockItemInfo>();
      residentList.push(itemInfo);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: ''
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
      mocker.clearAll();
    })

    it('test_getSceneLaunchType_5', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      itemInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      itemInfo.abilityName = 'MainAbilityentry';

      let residentList: DockItemInfo[] = new Array<DockItemInfo>();
      residentList.push(itemInfo);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: ''
      }

      let isFold = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(isFold)().afterReturn(true);

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_getSceneLaunchType_6', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      itemInfo.keyName = 'com.ohos.contactscom.ohos.contacts.MainAbilityentry';
      itemInfo.abilityName = 'MainAbilityentry';

      let residentList: DockItemInfo[] = new Array<DockItemInfo>();
      residentList.push(itemInfo);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      let recentItem: RecentBundleMissionInfo = {
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbilityentry'
      };

      let recentList: RecentBundleMissionInfo[] = new Array<RecentBundleMissionInfo>();
      recentList.push(recentItem);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: ''
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
      mocker.clearAll();
    })

    it('test_getSceneLaunchType_7', 0, () => {
      try {
        let model = PageDesktopModel.getInstance();

        let mocker: MockKit = new MockKit();
        let closeAppManager = CloseAppManager.getInstance();
        const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
        when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
        const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
        when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

        let recentItem: RecentBundleMissionInfo = {
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'com.ohos.contacts',
          abilityName: 'MainAbilityentry'
        };
        let recentList: RecentBundleMissionInfo[] = new Array<RecentBundleMissionInfo>();
        recentList.push(recentItem);
        AppStorage.setOrCreate('recentList', recentList);

        let companionIconInfo: CompanionIconInfo = {
          iconId: '',
          bundleName: 'com.ohos.contacts',
          abilityName: 'MainAbility',
          moduleName: '',
          iconNumber: 0,
          iconRadius: 0,
          startAppType: StartType.APP,
          cardId: ''
        }

        AppStorage.setOrCreate('openFolderId', '0');

        expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
        mocker.clear(closeAppManager);
        mocker.clearAll();
      } catch (error) {
        expect(false).assertFalse()
      }
    })

    it('test_getSceneLaunchType_9', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      let recentItem: RecentBundleMissionInfo = {
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbilityentry'
      };
      let recentList: RecentBundleMissionInfo[] = new Array<RecentBundleMissionInfo>();
      recentList.push(recentItem);
      AppStorage.setOrCreate('recentList', recentList);
      AppStorage.setOrCreate('openFolderId', '1');
      AppStorage.setOrCreate('openFolderData', null);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: ''
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
      mocker.clearAll();
    })

    it('test_getSceneLaunchType_10', 0, () => {
      try {
        let model = PageDesktopModel.getInstance();
        let mocker: MockKit = new MockKit();
        let closeAppManager = CloseAppManager.getInstance();
        const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
        when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
        const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
        when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
        AppStorage.setOrCreate('openFolderId', '1');
        let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
        let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayoutItemInfo.bundleName = 'com.ohos.contacts';
        openFolderData.formStackId = '0';
        openFolderData.layoutInfo = [[gridLayoutItemInfo]];
        AppStorage.setOrCreate('openFolderData', openFolderData);
        AppStorage.setOrCreate('openFolderPageIndex', 0);
        let companionIconInfo: CompanionIconInfo = {
          iconId: '',
          bundleName: 'com.ohos.contacts',
          abilityName: 'MainAbility',
          moduleName: '',
          iconNumber: 0,
          iconRadius: 0,
          startAppType: StartType.APP,
          cardId: ''
        }
        expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
        mocker.clear(closeAppManager);
        mocker.clearAll();
      } catch (error) {
        expect(false).assertFalse();
      }
    })

    it('test_getSceneLaunchType_11', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
      AppStorage.setOrCreate('openFolderId', '1');

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.formStackId = '0';

      openFolderData.layoutInfo = [[]];
      AppStorage.setOrCreate('openFolderData', openFolderData);
      AppStorage.setOrCreate('openFolderPageIndex', 0);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: ''
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
      mocker.clearAll();
    })

    it('test_getAbilityItemInfo', 0, () => {
      let model = PageDesktopModel.getInstance();
      let map = new Map<string, AbilityItemInfo>();
      let bundleName: string = 'com.ohos.contacts';
      let abilityName: string = 'MainAbilityentry';
      let moduleName: string = '';
      SCBSceneSessionManager.getInstance()['abilityInfoMap'] = map;
      expect(model.getAbilityItemInfo(bundleName, moduleName, abilityName)).assertUndefined();
    })

    it('test_getAbilityItemInfo_1', 0, () => {
      let model = PageDesktopModel.getInstance();
      let map = new Map<string, AbilityItemInfo>();
      let bundleName: string = 'com.ohos.contacts';
      let abilityName: string = 'MainAbilityentry';
      let moduleName: string = '123';
      let key = bundleName + moduleName + abilityName;
      let abilityItemInfo = {
        appIconId: 0,
        appLabelId: 0,
        bundleName: '',
        moduleName: '',
        name: '',
        launchType: bundleManager.LaunchType.SINGLETON,
        supportWindowModes: [],
        windowSize: new WindowSize,
        orientation: bundleManager.DisplayOrientation.UNSPECIFIED,
        removeSessionAfterTerminate: false,
        excludeFromSession: false,
        unclearableSession: false,
        continuable: false,
        preferMultiWindowOrientation: ''
      } as AbilityItemInfo;
      map.set(key, abilityItemInfo);
      SCBSceneSessionManager.getInstance()['abilityInfoMap'] = map;
      expect(model.getAbilityItemInfo(bundleName, moduleName, abilityName)).not().assertNull();
    })

  })
}
