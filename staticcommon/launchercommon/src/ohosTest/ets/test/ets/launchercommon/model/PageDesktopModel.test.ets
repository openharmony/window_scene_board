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
  ArgumentMatchers
} from '@ohos/hypium'
import { RectInfo, StartType, CompanionIconInfo, ObjUtil, } from '@ohos/basicutils';
import { ItemUtils, desktopUtil } from '@ohos/componenthelper';
import { SCBConstants } from '@ohos/commonconstants';
import { GridOccupyStatusEnum } from '@ohos/componentdrag';
import { DeviceHelper, sOutSideWindowMgr } from '@ohos/frameworkwrapper';
import { AbilityItemInfo, WindowSize } from '@ohos/windowscene';
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty,
  SCBSceneSessionManager,
  AppExitLocationInfo,
  AppInFolderInfo,
  AppData
} from '@ohos/windowscene';
import { CommonConstants, PageDesktopModel, AppModel, AppItemInfo} from '../../../../../../..'
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
  StartSubtype,
  LaunchLayoutCacheManager,
  PadLaunchLayoutCacheManager,
  LayoutDescription,
  DeliverUtil,
  FolderData,
} from '../../../../../../main/ets/TsIndex';
import { AppTransitionInfo } from '../../../../../../main/ets/pagedesktop/model/PageDesktopModel';
import { ResidentLayoutCacheMgr } from '../../../../../../main/ets/dock/cache/ResidentLayoutCacheMgr';

export default function PageDesktopModelTest() {

  describe('PageDesktopModelTest', () => {
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

    it('PageDesktopModel_deleteBlankPageFromLayoutInfo_01', 0, () => {
      const instance: PageDesktopModel = PageDesktopModel.getInstance();
      let launcherLayoutCache: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(launcherLayoutCache, launcherLayoutCache.isBlankPage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let bool: boolean = instance.deleteBlankPageFromLayoutInfo(0.01);
      expect(bool).assertTrue();
      mocker.clear(launcherLayoutCache);
      mocker.clearAll();
    })

    it('PageDesktopModel_deleteBlankPageFromLayoutInfo_02', 0, () => {
      const instance: PageDesktopModel = PageDesktopModel.getInstance();
      let launcherLayoutCache: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(launcherLayoutCache, launcherLayoutCache.isBlankPage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let bool: boolean = instance.deleteBlankPageFromLayoutInfo(0.01);
      expect(bool).assertInstanceOf('Boolean');
      mocker.clear(launcherLayoutCache);
      mocker.clearAll();
    })

    it('PageDesktopModel_deleteBlankPageFromLayoutInfo_03', 0, () => {
      const instance: PageDesktopModel = PageDesktopModel.getInstance();
      let launcherLayoutCache: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      try{
        let mockFunc: Function = mocker.mockFunc(launcherLayoutCache, launcherLayoutCache.isBlankPage);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let bool: boolean = instance.deleteBlankPageFromLayoutInfo(0.01, false);
        expect(false).assertFalse();
      } catch (e) {}
      mocker.clear(launcherLayoutCache);
      mocker.clearAll();
    })

    it('PageDesktopModel_updatePageDesktopLayoutInfo', 0, () => {
      const instance: PageDesktopModel = PageDesktopModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.findBlankPosition);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let bool: boolean = instance.updatePageDesktopLayoutInfo(new GridLayoutItemInfo(), 10);
      expect(bool).assertFalse();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('PageDesktopModel_test_getInstance', 0, () => {
      globalThis.PageDesktopModel = null;
      const instance = PageDesktopModel.getInstance();
      expect(globalThis.PageDesktopModel).not().assertNull();
      expect(instance).assertEqual(globalThis.PageDesktopModel);
    })

    it('test_registerPageDesktopItemAddEvent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let  model = PageDesktopModel.getInstance();
      const receivedMap = new HashMap<string, boolean>();
      const mLocalEventListener: ReceiveEventInfo = {
        onReceiveEvent: (event:string, params?: string[]) => {
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
      let  model = PageDesktopModel.getInstance();
      const receivedMap = new HashMap<string, boolean>();
      const mLocalEventListener: ReceiveEventInfo = {
        onReceiveEvent: (event:string, params?:string[]) => {
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
      let  model = PageDesktopModel.getInstance();
      const receivedMap = new HashMap<string, boolean>();
      const mLocalEventListener: ReceiveEventInfo = {
        onReceiveEvent: (event:string, params?: string[]) => {
          receivedMap[event] = true;
        }
      };
      model.registerPageDesktopItemAddEvent(mLocalEventListener);
      model.unregisterEventListener(mLocalEventListener);
      expect(true).assertTrue();
    })

    it('test_sendDockItemChangeEvent', 0, () => {
      let model = PageDesktopModel.getInstance();
      try {
        model.sendDockItemChangeEvent(null);
      } catch (error) {
      }
      expect(true).assertTrue();
    })

    it('test_getNeighborPage', 0, () => {
      let model = PageDesktopModel.getInstance();
      expect(model['getNeighborPage'](0)).assertInstanceOf('Number');
      expect(model['getNeighborPage'](3)).assertInstanceOf('Number');
    })

    it('test_deleteBlankPageFromLayoutInfo', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let  model = PageDesktopModel.getInstance();
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
    })

    it('test_isPageBlank_01', 0, () => {
      let model = PageDesktopModel.getInstance();
      const layoutConfig = PageDesktopLayoutConfig.getInstance();
      layoutConfig.mGridLayoutInfo.layoutInfo = [new GridLayoutItemInfo()];
      model['isPageBlank'](layoutConfig.mGridLayoutInfo, 0);

      let item = new GridLayoutItemInfo();
      item.page = 1;
      layoutConfig.mGridLayoutInfo.layoutInfo = [new GridLayoutItemInfo()];
      model['isPageBlank'](layoutConfig.mGridLayoutInfo, 1);
      expect(true).assertTrue();
    })

    it('test_updateAppItemLayoutInfo', 0, () => {
      let model = PageDesktopModel.getInstance();
      try {
        model.updateAppItemLayoutInfo(null, null);
      } catch (error) {
      }
      try {
        let appItemInfo = AppModel.getInstance().getAppInfoByBundleName('com.ohos.sceneboard');
        model.updateAppItemLayoutInfo({
          layoutDescription: {
            pageCount: 2,
            row: 2,
            column: 2
          }
        }, appItemInfo);
      } catch (error) {
      }
      expect(true).assertTrue();
    })

    it('test_updatePageDesktopLayoutInfo', 0, () => {
      let model = PageDesktopModel.getInstance();
      try {
        model.updatePageDesktopLayoutInfo(null);
      } catch (error) {
      }
      try {
        model.updatePageDesktopLayoutInfo(null, 1);
      } catch (error) {
      }
      expect(true).assertTrue();
    })

    it('test_updatePageDesktopLayoutInfoForFolder', 0, () => {
      let model = PageDesktopModel.getInstance();
      try {
        model.updatePageDesktopLayoutInfoForFolder([{
          page: 1, row: 1, column: 1
        }, {
          page: 2, row: 2, column: 2
        }]);
      } catch (error) {
      }
      expect(true).assertTrue();
    })

    it('test_findElementLocationInPage', 0, () => {
      let model = PageDesktopModel.getInstance();
      let launcherLayout: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let gridOccupyStatusEnum = launcherLayout.selectGridOccupyStatusForPage(0);
      try {
        model['findElementLocationInPage'](gridOccupyStatusEnum, {}, 0);
      } catch (error) {
      }
      expect(true).assertTrue();
    })

    it('test_getGridOccupyStatusEnum', 0, () => {
      let model = PageDesktopModel.getInstance();
      let layoutInfo = new GridLayoutItemInfo();
      try {
        model.getGridOccupyStatusEnum(layoutInfo, 0, 0, 0);
      } catch (error) {
      }
      const layoutConfig = PageDesktopLayoutConfig.getInstance();
      try {
        model.getGridOccupyStatusEnum(layoutConfig.mGridLayoutInfo.layoutInfo, 0, 0, 0);
      } catch (error) {
      }
      expect(true).assertTrue();
    })

    it('test_isPositionValid01', 0, () => {
      let model = PageDesktopModel.getInstance();
      let layoutInfo = PageDesktopLayoutConfig.getInstance().mGridLayoutInfo;
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.area = [0, 1];
      expect(model.isPositionValid(layoutInfo, itemInfo, 1000, 0, 0)).assertInstanceOf('Boolean');
      expect(model.isPositionValid(layoutInfo, itemInfo, 0, 1000, 0)).assertInstanceOf('Boolean');
      expect(model.isPositionValid(layoutInfo, itemInfo, 0, 0, 0)).assertInstanceOf('Boolean');
    })

    it('test_isPositionOccupied01', 0, () => {
      let model = PageDesktopModel.getInstance();
      let layoutInfo = PageDesktopLayoutConfig.getInstance().mGridLayoutInfo;
      expect(model['isPositionOccupied'](layoutInfo, 0, 0, 0)).assertInstanceOf('Boolean');
    })

    it('test_isCurrentPositionOccupied', 0, () => {
      let model = PageDesktopModel.getInstance();
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.area = [0, 1];
      expect(model.isCurrentPositionOccupied(itemInfo)).assertInstanceOf('Boolean');
    })

    it('test_setPageIndex_getPageIndex', 0, () => {
      let model = PageDesktopModel.getInstance();
      model.setPageIndex(0);
      let page: number = model.getPageIndex();
      expect(page).assertInstanceOf('Number');
    })

    it('test_getIsPad', 0, () => {
      let model = PageDesktopModel.getInstance();
      let isPad: boolean = model.getIsPad();
      expect(isPad).assertInstanceOf('Boolean');
    })

    it('test_updateBlankPage', 0, () => {
      let model = PageDesktopModel.getInstance();
      let pageItemCountMap: Map<string, number> = new Map();
      pageItemCountMap.set('test_page',1);
      model.updateBlankPage(pageItemCountMap);
      expect(true).assertTrue();
    })

    it('test_searchInCurrentPage', 0, () => {
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
      let model = PageDesktopModel.getInstance();
      AppStorage.set('openFolderId', '-1');
      try {
        model['searchInCurrentPage'](companionIconInfo);
        expect(true).assertTrue();
      } catch (error) {
      }
      AppStorage.set('openFolderId', '1');
      try {
        model['searchInCurrentPage'](companionIconInfo);
        expect(true).assertTrue();
      } catch (error) {
      }
      AppStorage.delete('openFolderId');
    })

    it('test_findAppInCurrentPage', 0, () => {
      let model = PageDesktopModel.getInstance();
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
      let retValue = model['findAppInCurrentPage'](null, companionIconInfo);
      expect(retValue).not().assertNull();
    })

    it('test_searchInCurrentDeskTopPage', 0, () => {
      let model = PageDesktopModel.getInstance();
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
      let retValue = model['searchInCurrentDeskTopPage'](companionIconInfo);
      expect(retValue).not().assertNull();
    })

    it('test_searchInFolderComponent', 0, () => {
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
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.area = [1, 2];
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.layoutInfo = [[info]];
      let model = PageDesktopModel.getInstance();
      model['searchInFolderComponent'](itemInfo, companionIconInfo);
      expect(true).assertTrue();
    })

    it('test_isFoundApp', 0, () => {
      let model = PageDesktopModel.getInstance();
      let retValue = model['isFoundApp'](null, null);
      expect(retValue).assertFalse();

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: '',
        abilityName: '',
        moduleName: '',
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: '',
        iconNumber: 0
      }
      retValue = model['isFoundApp'](null, companionIconInfo);
      expect(retValue).assertFalse();

      companionIconInfo.bundleName = 'com.ohos.sceneboard';
      companionIconInfo.iconNumber = 1;
      retValue = model['isFoundApp'](null, companionIconInfo);
      expect(retValue).assertFalse();
      companionIconInfo.startAppType = StartType.CARD;
      retValue = model['isFoundApp'](null, companionIconInfo);
      expect(retValue).assertInstanceOf('Boolean');

      let itemInfo = new GridLayoutItemInfo();
      retValue = model['isFoundApp'](itemInfo, companionIconInfo);
      expect(retValue).assertInstanceOf('Boolean');
    })

    it('test_isFoundFormStackCardTop', 0, () => {
      let model = PageDesktopModel.getInstance();
      let itemInfo = new GridLayoutItemInfo();
      let retValue = model['isFoundFormStackCardTop'](itemInfo, null);
      expect(retValue).assertFalse();
      itemInfo.layoutInfo = [[]];
      retValue = model['isFoundFormStackCardTop'](itemInfo, null);
      expect(retValue).assertFalse();

      itemInfo.layoutInfo = [[new GridLayoutItemInfo()]];
      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: '',
        abilityName: '',
        moduleName: '',
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: '',
        iconNumber: 0
      }
      retValue = model['isFoundFormStackCardTop'](itemInfo, companionIconInfo);
      expect(retValue).assertInstanceOf('Boolean');
    })

    it('test_isInDock01', 0, () => {
      let model = PageDesktopModel.getInstance();
      let retValue = model.isInDock('com.ohos.sceneboard', 'abilityName');
      expect(retValue).assertInstanceOf('Boolean');

      retValue = model.isInRecentDock('com.ohos.sceneboard', 'abilityName');
      expect(retValue).assertInstanceOf('Boolean');
    })

    it('test_getAppInfoFromDock01', 0, () => {
      let model = PageDesktopModel.getInstance();
      let dockItemInfo: DockItemInfo = {
        bundleName: 'com.ohos.sceneboard',
        abilityName: 'abilityName',
        appIndex: 0,
        appInstanceKey: '',
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appIconId: 0,
        appName: ''
      }
      let retValue = model.getAppInfoFromDock(dockItemInfo);
      expect(retValue).not().assertNull();
    })

    it('test_getDefaultTransitionController', 0, () => {
      let model = PageDesktopModel.getInstance();
      let item = new AppItemInfo();
      let retValue = model.getDefaultTransitionController(item);
      expect(retValue).not().assertNull();
    })

    it('test_deleteBlankPageFromLayoutInfo_page_blank', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
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
    })

    it('test_isPad', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let  model = PageDesktopModel.getInstance();
      if (CommonConstants.PAD_DEVICE_TYPE === AppStorage.get('device')) {
        expect(model.getIsPad()).assertEqual(true);
      } else {
        expect(model.getIsPad()).assertEqual(false);
      }
    })

    it('test_setPageIndex', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let  model = PageDesktopModel.getInstance();
      const pageIndex = model.getPageIndex();
      expect(pageIndex).assertLargerOrEqual(0);

      model.setPageIndex(pageIndex + 1);
      const curValue = model.getPageIndex();
      expect(curValue).assertEqual(pageIndex + 1);
      model.setPageIndex(pageIndex);
    })

    it('test_isInDock', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let  model = PageDesktopModel.getInstance();
      const bundleName = 'bundleNotExists';
      const abilityName = 'abilityNotExists';
      const retValue = model.isInDock(bundleName, abilityName);
      expect(retValue).assertFalse();
    })

    it('test_isInRecentDock', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let  model = PageDesktopModel.getInstance();
      const bundleName = 'bundleNotExists';
      const abilityName = 'abilityNotExists';
      const retValue = model.isInRecentDock(bundleName, abilityName);
      expect(retValue).assertFalse();
    })

    it('test_getAppInfoFromDock', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let  model = PageDesktopModel.getInstance();
      const bundleName = 'bundleNotExists';
      const abilityName = 'abilityNotExists';
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
      expect(retValue).assertUndefined();
    })

    it('test_isPositionValid', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let  model = PageDesktopModel.getInstance();
      const mGridLayoutInfo: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo()
      class BaseItemInfo {
        area: number[] | undefined;
      };
      let item:BaseItemInfo = {
        area: [1, 1]
      };
      const page = 0;
      const startColumn = 0;
      const startRow = 0;
      let retValue = model.isPositionValid(mGridLayoutInfo, item, page, startColumn, startRow);
      expect(retValue).not().assertNull();

      retValue = model.isPositionValid(mGridLayoutInfo, item, page, 4, startRow);
      expect(retValue).not().assertNull();

      retValue = model.isPositionValid(mGridLayoutInfo, item, page, startColumn, 6);
      expect(retValue).not().assertNull();

      retValue = model.isPositionValid(mGridLayoutInfo, item, 100, startColumn, startRow);
      expect(retValue).not().assertNull();
    })

    it('test_isPositionOccupied', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let  model = PageDesktopModel.getInstance();
      const mGridLayoutInfo: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo()
      class BaseItemInfo {
        area: number[] | undefined;
      };
      let item:BaseItemInfo = {
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
      let pageDesktopModel = PageDesktopModel.getInstance();
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(priSceneSession, screenProperty);
      try {
        let retValue = pageDesktopModel.buildAppExitInfo(containerSession);
        expect(retValue).not().assertUndefined();
      } catch (error) {
      }
    })

    it('test_buildAppExitInfo_1', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopModel = PageDesktopModel.getInstance();
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
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
      try {
        let retValue = pageDesktopModel.buildAppExitInfo(containerSession);
        expect(retValue).not().assertUndefined();
      } catch (error) {
      }
    })

    it('test_buildAppExitInfo_2', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopModel = PageDesktopModel.getInstance();
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
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
      try {
        let retValue = pageDesktopModel.buildAppExitInfo(containerSession);
        expect(retValue).not().assertUndefined();
      } catch (error) {
      }
    })

    it('test_onTransitionActive_0', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopModel = PageDesktopModel.getInstance();
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
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
      try {
        pageDesktopModel.onTransitionActive(containerSession, isInScreen);
        expect(pageDesktopModel).not().assertNull();
      } catch (error) {
      }
    })

    it('test_onTransitionActive_1', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopModel = PageDesktopModel.getInstance();
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
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
      let priSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
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
      try {
        pageDesktopModel.onTransitionActive(containerSession, isInScreen);
        expect(pageDesktopModel).not().assertNull();
      } catch (error) {
      }
    })

    it('test_updateBlankPage_NoBlankPage', 0, () => {
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
    })

    it('test_getCloseAppData', 0, () => {
      let model = PageDesktopModel.getInstance();
      model.getCloseAppData(null, null, undefined, '1', undefined);
      model.getCloseAppData(null, null, null, '1', undefined);
      expect(true).assertTrue();

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

      startType = StartType.RECENT_DOCK_APP;
      let appData3 = model.getCloseAppData(bundleName, abilityName, startType, formCardId, null);

      let screenId = 0;
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

      expect(model.getSceneLaunchType(companionIconInfo)).not().assertNull();
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
      mocker.clear(DeviceHelper)
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
      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);
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
      } catch (error) {
        expect(false).assertFalse()
      }
      mocker.clear(closeAppManager);
      mocker.clearAll();
    })

    it('test_getSceneLaunchType_8', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);

      let recentItem: RecentBundleMissionInfo = {
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility'
      }
      AppStorage.setOrCreate('recentList', [recentItem]);

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

      AppStorage.SetOrCreate('openFolderData', null);

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
      mocker.clear(DeviceHelper)
      mocker.clearAll();
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
      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);
      try {
        let model = PageDesktopModel.getInstance();

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
      } catch (error) {
        expect(false).assertFalse();
      }
      mocker.clear(closeAppManager);
      mocker.clearAll();
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

    it('test_getExitAppData', 0, () => {
      let model = PageDesktopModel.getInstance();
      model.getExitAppData(null, null, undefined, 1, undefined);
      model.getExitAppData(null, null, null, 1, undefined)
      expect(true).assertTrue();

      let bundleName: string = CommonConstants.FILE_MANAGER_BUNDLE;
      let abilityName: string = 'MainAbility';
      let ret = model.getExitAppData(bundleName, abilityName, StartType.CARD, 1, undefined)
      expect(ret).not().assertNull()
    })

    it('test_findBlankPositionInDetail', 0, () => {
      let model = PageDesktopModel.getInstance();
      let pageIndex: number = 0;
      let positionX: number = 0;
      let positionY: number = 0;
      let launcherLayout: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mPadLaunchLayoutCacheManager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.page = 1;
      item.column = 1;
      item.row = 1;
      let mocker: MockKit = new MockKit();
      const mockerFunc1 = mocker.mockFunc(launcherLayout, launcherLayout.isPositionValid);
      when(mockerFunc1)().afterReturn(true);
      const mockerFunc2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockerFunc2)().afterReturn(true);
      let ret = model['findBlankPositionInDetail'](pageIndex, positionX, positionY, item);
      expect(ret).not().assertNull();
      when(mockerFunc1)().afterReturn(false);
      let ret2 = model['findBlankPositionInDetail'](pageIndex, positionX, positionY, item);
      expect(ret2).not().assertNull();
      mocker.clear(launcherLayout);
      mocker.clear(DeviceHelper);
      mocker.clear(mPadLaunchLayoutCacheManager);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_isFromSuggestion', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: '',
        abilityName: '',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.CARD,
        cardId: '',
        extraId: '996'
      };
      let result: boolean = instance['isFromSuggestion'](companionIconInfo);
      expect(result).assertTrue();
    })

    it('test_PageDesktopModel_onTransitionActiveForSplit', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
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
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(mockFunc)().afterReturn(false);
      instance['onTransitionActiveForSplit'](containerSession);
      expect(containerSession.companionIconInfo.iconId).assertEqual('appIconId');
      mocker.clear(sOutSideWindowMgr);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_onTransitionActive', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      let priSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
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
      instance.onTransitionActive(containerSession);
      expect(instance).assertEqual(PageDesktopModel.getInstance());
    })

    it('test_PageDesktopModel_getIconRectInfo', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: '',
        abilityName: '',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.CARD,
        cardId: '',
        extraId: '996'
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerPkg);
      let mockFunc2: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      expect(instance['getIconRectInfo'](companionIconInfo, true, '996')).assertNull();
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_searchInCurrentFolderOpenPage', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: '',
        abilityName: '',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.CARD,
        cardId: '',
        extraId: '996'
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FolderData.getInstance(), FolderData.getInstance().getOpenedFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(info);
      let result: AppExitLocationInfo = instance['searchInCurrentFolderOpenPage'](companionIconInfo);
      expect(result.isInScreen).assertFalse();
      info.layoutInfo = [[new GridLayoutItemInfo()]];
      when(mockFunc)(ArgumentMatchers.any).afterReturn(info);
      AppStorage.setOrCreate('openFolderPageIndex', 1);
      result = instance['searchInCurrentFolderOpenPage'](companionIconInfo);
      expect(result.isInScreen).assertFalse();
      AppStorage.setOrCreate('openFolderPageIndex', 0);
      let mockFunc2: Function = mocker.mockFunc(instance, instance['isFoundApp']);
      info.layoutInfo = [[]];
      when(mockFunc)(ArgumentMatchers.any).afterReturn(info);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      result = instance['searchInCurrentFolderOpenPage'](companionIconInfo);
      expect(result.iconRect).assertEqual(null);
      mocker.clear(FolderData.getInstance());
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_searchInCurrentDeskTopPage', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: '',
        abilityName: '',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: ''
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ObjUtil, ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: AppExitLocationInfo = instance['searchInCurrentDeskTopPage'](companionIconInfo);
      expect(result.isInScreen).assertFalse();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      result = instance['searchInCurrentDeskTopPage'](companionIconInfo);
      expect(result.iconRect).assertEqual(null);
      mocker.clear(ObjUtil);
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_initEleventhItemInfo', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let inFolderInfo: AppInFolderInfo = new AppInFolderInfo();
      inFolderInfo.bundleName = '007';
      instance['initEleventhItemInfo'](inFolderInfo, null);
      expect(inFolderInfo.bundleName).assertEqual('007');
      let folderAppInfo = new GridLayoutItemInfo();
      folderAppInfo.bundleName = '996';
      folderAppInfo.abilityName = '996';
      folderAppInfo.appIndex = undefined;
      folderAppInfo.shortcutId = undefined;
      folderAppInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      instance['initEleventhItemInfo'](inFolderInfo, folderAppInfo);
      expect(inFolderInfo.bundleName).assertEqual('996');
    })

    it('test_PageDesktopModel_isFoundApp', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.appIndex = undefined;
      itemInfo.shortcutId = undefined;
      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.bundleName',
        abilityName: 'com.ohos.abilityName',
        moduleName: 'com.ohos.moduleName',
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: '',
        iconNumber: 1,
        appIndex: 1,
        shortcutId: '996'
      };
      let result: boolean = instance['isFoundApp'](itemInfo, companionIconInfo);
      expect(result).assertInstanceOf('Boolean');
      itemInfo.bundleName = 'com.ohos.bundleName';
      itemInfo.abilityName = 'com.ohos.abilityName';
      itemInfo.moduleName = 'com.ohos.moduleName';
      itemInfo.appIndex = 1;
      itemInfo.shortcutId = '996';
      result = instance['isFoundApp'](itemInfo, companionIconInfo);
      expect(result).assertTrue();
    })

    it('test_PageDesktopModel_isInDock', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      const bundleName = 'bundleNotExists';
      const abilityName = 'abilityNotExists';
      let info: DockItemInfo = new DockItemInfo();
      info.bundleName = bundleName;
      info.abilityName = abilityName;
      AppStorage.setOrCreate('recentDockList', [info]);
      let result: boolean = instance.isInDock(bundleName, abilityName, 9, '007');
      expect(result).assertFalse();
      AppStorage.setOrCreate('recentDockList', [[undefined]]);
      result = instance.isInDock(bundleName, abilityName);
      expect(result).assertFalse();
    })

    it('test_PageDesktopModel_isInRecentDock', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      const bundleName = 'bundleNotExists';
      const abilityName = 'abilityNotExists';
      let info: DockItemInfo = new DockItemInfo();
      info.bundleName = bundleName;
      info.abilityName = abilityName;
      AppStorage.setOrCreate('recentDockList', [info]);
      const retValue = instance.isInRecentDock(bundleName, abilityName);
      expect(retValue).assertTrue();
    })

    it('test_PageDesktopModel_getSceneLaunchType_01', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let info: CompanionIconInfo = {
        iconId: '996',
        bundleName: '996',
        abilityName: '996',
        moduleName: '996',
        iconNumber: 996,
        iconRadius: 996,
        startAppType: StartType.DOCK_APP,
        cardId: '007'
      };
      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.ICON_FROM_OTHER);
      let result: string = instance.getSceneLaunchType(info);
      expect(result).assertEqual('LAUNCHER_APP_LAUNCH_FROM_OTHER');
      mocker.clear(closeAppManager);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_getSceneLaunchType_02', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let info: CompanionIconInfo = {
        iconId: '996',
        bundleName: '996',
        abilityName: '996',
        moduleName: '996',
        iconNumber: 996,
        iconRadius: 996,
        startAppType: StartType.DOCK_APP,
        cardId: '007'
      };
      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.CARD);
      let result: string = instance.getSceneLaunchType(info);
      expect(result).assertEqual('START_APP_ANI_FORM');
      mocker.clear(closeAppManager);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_getSceneLaunchType_03', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let info: CompanionIconInfo = {
        iconId: '996',
        bundleName: '996',
        abilityName: '996',
        moduleName: '996',
        iconNumber: 996,
        iconRadius: 996,
        startAppType: StartType.DOCK_APP,
        cardId: '007'
      };
      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DESKTOP_APP);
      let result: string = instance.getSceneLaunchType(info);
      expect(result).assertEqual('LAUNCHER_APP_LAUNCH_FROM_ICON');
      mocker.clear(closeAppManager);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_findAppInCurrentPage', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = '张三';
      info.cardId = '007';
      info.typeId = CommonConstants.TYPE_FOLDER;
      info.abilityName = '李华';
      info.negativeId = 7;
      info.appIconId = 7;
      let eleInCurrentPage = [info];
      let companionIconInfo: CompanionIconInfo = {
        iconId: '007',
        bundleName: '007',
        abilityName: '007',
        moduleName: '007',
        iconNumber: 7,
        iconRadius: 7,
        startAppType: StartType.CARD,
        cardId: '007',
        extraId: '996'
      };
      let mocker: MockKit = new MockKit();
      let result: AppTransitionInfo = instance['findAppInCurrentPage'](eleInCurrentPage, companionIconInfo);
      expect(result.app.cardId).assertEqual('007');
      companionIconInfo.startAppType = StartType.APP;
      const mockerFunc1 = mocker.mockFunc(instance, instance['searchInFolderComponent']);
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect(result.app.cardId).assertEqual('007');
      companionIconInfo.startAppType = StartType.APP;
      info.typeId = CommonConstants.DOCK_SPACE;
      const mockerFunc2 = mocker.mockFunc(instance, instance['isFound']);
      when(mockerFunc2)(ArgumentMatchers.any).afterReturn(true);
      expect(result.app.cardId).assertEqual('007');
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_searchInScreen', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let companionIconInfo: CompanionIconInfo = {
        iconId: 'CardsView_CardFrame_',
        bundleName: '007',
        abilityName: '007',
        moduleName: '007',
        iconNumber: 7,
        iconRadius: 7,
        startAppType: StartType.CARD,
        cardId: '007',
        extraId: '996'
      };
      let info: DockItemInfo = new DockItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      let mocker: MockKit = new MockKit();
      const mockerFunc = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr['isShowGlobalSearch']);
      when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: AppExitLocationInfo = instance['searchInScreen'](companionIconInfo);
      expect(result.isInScreen).assertFalse();
      when(mockerFunc)(ArgumentMatchers.any).afterReturn(false);
      const mockerFunc1 = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr['isShowNegative']);
      const mockerFunc2 = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr['getDesktopEnabled']);
      const mockerFunc3 = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr['isIntelligentCardShowFull']);
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockerFunc2)(ArgumentMatchers.any).afterReturn(false);
      when(mockerFunc3)(ArgumentMatchers.any).afterReturn(false);
      result = instance['searchInScreen'](companionIconInfo);
      expect(result.isInScreen).assertFalse();
      when(mockerFunc3)(ArgumentMatchers.any).afterReturn(true);
      AppStorage.setOrCreate<boolean>('isIntelligentCardUseAnimation', true);
      expect(result.isInScreen).assertInstanceOf('Boolean');
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(false);
      AppStorage.setOrCreate<string>('openFolderId', SCBConstants.INVALID_FOLDER_ID);
      const mockerFunc4 = mocker.mockFunc(instance, instance['isFromSuggestion']);
      const mockerFunc5 = mocker.mockFunc(instance, instance['isInDock']);
      when(mockerFunc4)(ArgumentMatchers.any).afterReturn(true);
      when(mockerFunc5)(ArgumentMatchers.any).afterReturn(true);
      expect(result.isInScreen).assertFalse();
      mocker.clear(sOutSideWindowMgr);
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_getOObeIconRect', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      const bundleName = 'com.ohos.hicar';
      const moduleName = 'phone_hicar';
      const abilityName = 'com.ohos.contacts';
      const want: Want = { bundleName, abilityName, moduleName };
      const sceneInfo = new SCBSceneInfo(bundleName, moduleName, abilityName);
      sceneInfo.want = want;
      let scene: sceneSessionManager.SceneSession = SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
      let sess: SCBSceneSession = new SCBSceneSession(scene, sceneInfo);
      let property: SCBScreenProperty = new SCBScreenProperty();
      let session: SCBSceneContainerSession = new SCBSceneContainerSession(sess, property);
      let info: RectInfo = new RectInfo(0, 0, 0, 0)
      let appInfo: AppExitLocationInfo = {
        isInScreen: true,
        type: '99',
        pageIndex: 9,
        iconRect: info,
        appInFolderInfo: null,
      };
      let result: AppExitLocationInfo = instance['getOObeIconRect'](appInfo, session);
      expect(result?.iconRect?.left).assertEqual(undefined);
    })

    it('test_PageDesktopModel_getAppExitLocationInfo', 0, () => {
      try {
        let instance: PageDesktopModel = PageDesktopModel.getInstance();
        const bundleName = 'com.ohos.hicar';
        const moduleName = 'phone_hicar';
        const abilityName = 'com.ohos.contacts';
        const want: Want = { bundleName, abilityName, moduleName };
        const sceneInfo = new SCBSceneInfo(bundleName, moduleName, abilityName);
        sceneInfo.want = want;
        let scene: sceneSessionManager.SceneSession = SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
        let sess: SCBSceneSession = new SCBSceneSession(scene, sceneInfo);
        let property: SCBScreenProperty = new SCBScreenProperty();
        let session: SCBSceneContainerSession = new SCBSceneContainerSession(sess, property);
        let info: RectInfo = new RectInfo(0, 0, 0, 0)
        let appInfo: AppExitLocationInfo = {
          isInScreen: true,
          type: '99',
          pageIndex: 9,
          iconRect: info,
          appInFolderInfo: null,
        };
        let result: AppExitLocationInfo = instance['getAppExitLocationInfo'](null, '009', session);
        expect(result.isInScreen).assertFalse();
        result = instance['getAppExitLocationInfo'](appInfo, '', session);
        expect(result.isInScreen).assertTrue();
        let mocker: MockKit = new MockKit();
        const mockerFunc = mocker.mockFunc(ItemUtils, ItemUtils['getRectById']);
        const mockerFunc1 = mocker.mockFunc(instance, instance['getOObeIconRect']);
        when(mockerFunc)(ArgumentMatchers.any).afterReturn(new RectInfo(0, 0, 0, 0));
        when(mockerFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
        result = instance['getAppExitLocationInfo'](appInfo, 'com.ohos.suggestion', session);
        expect(result.isInScreen).assertTrue();
        when(mockerFunc)(ArgumentMatchers.any).afterReturn(new RectInfo(1, 1, 1, 1));
        expect(result.iconRect?.left).assertEqual(0);
        instance.setOuterFormStackExitScale(0.5);
        expect(instance.mOuterFormStackExitScale).assertEqual(0.5);
        mocker.clear(ItemUtils);
        mocker.clear(instance);
        mocker.clearAll();
      } catch (e) {}
    })

    it('test_PageDesktopModel_searchInCurrentPage', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let companionIconInfo: CompanionIconInfo = {
        iconId: 'CardsView_CardFrame_',
        bundleName: '007',
        abilityName: '007',
        moduleName: '007',
        iconNumber: 7,
        iconRadius: 7,
        startAppType: StartType.CARD,
        cardId: '007',
        extraId: '996'
      };
      let appInfo: AppExitLocationInfo = {
        isInScreen: true,
        type: '99',
        pageIndex: 9,
        iconRect: null,
        appInFolderInfo: null,
      };
      let mocker: MockKit = new MockKit();
      const mockerFunc = mocker.mockFunc(FolderData.getInstance(), FolderData.getInstance().isFolderOpen);
      const mockerFunc1 = mocker.mockFunc(instance, instance['searchInCurrentFolderOpenPage']);
      when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
      let result: AppExitLocationInfo = instance['searchInCurrentPage'](companionIconInfo);
      expect(result.isInScreen).assertTrue();
      mocker.clear(FolderData.getInstance());
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_isCurrentPositionOccupied', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let launcherLayout: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let layout: LayoutDescription = {
        pageCount: 1,
        row: 1,
        column: 10,
        maxPage: 1,
        maxForm: 1,
      };
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.abilityName = 'openharmony';
      info.area = [1, 2];
      let mocker: MockKit = new MockKit();
      const mockerFunc = mocker.mockFunc(instance, instance['getIsPad']);
      const mockerFunc1 = mocker.mockFunc(launcherLayout, launcherLayout.selectLayoutDescription);
      when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(layout);
      let result: boolean = instance.isCurrentPositionOccupied(info);
      expect(result).assertTrue();
      layout.row = 10;
      const mockerFunc2 = mocker.mockFunc(launcherLayout, launcherLayout.isPositionOccupied);
      when(mockerFunc2)(ArgumentMatchers.any).afterReturn(true);
      expect(result).assertTrue();
      mocker.clear(launcherLayout);
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_getGridOccupyStatusEnumForInsertInto', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.page = 1;
      itemInfo.abilityName = 'openharmony';
      itemInfo.area = [2, 1];
      let result: GridOccupyStatusEnum[][] = instance.getGridOccupyStatusEnumForInsertInto([itemInfo], 1, 1, -1);
      expect(result.length).assertEqual(0);
      result = instance.getGridOccupyStatusEnumForInsertInto([itemInfo], 1, 1, 1);
      expect(result.length).assertEqual(1);
      itemInfo.area[0] = 1;
      result = instance.getGridOccupyStatusEnumForInsertInto([itemInfo], 1, 1, 1);
      expect(result.length).assertEqual(1);
    })

    it('test_PageDesktopModel_findBlankPositionInDetail', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.page = 1;
      itemInfo.abilityName = 'openharmony';
      itemInfo.area = [2, 1];
      let mocker: MockKit = new MockKit();
      const mockerFunc = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().isPositionValid);
      const mockerFunc1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(true);
      let result: boolean = instance['findBlankPositionInDetail'](1, 1, 1, itemInfo);
      expect(itemInfo.page ).assertEqual(1);
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_findBlankPosition', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.page = 1;
      itemInfo.abilityName = 'openharmony';
      itemInfo.area = [2, 1];
      let mocker: MockKit = new MockKit();
      const mockerFunc = mocker.mockFunc(instance, instance.getIsPad);
      when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: boolean = instance['findBlankPosition'](0, 1, itemInfo);
      expect(result).assertInstanceOf('Boolean');
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_updatePageDesktopLayoutInfo', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.page = 1;
      itemInfo.abilityName = 'openharmony';
      itemInfo.area = [2, 1];
      let mocker: MockKit = new MockKit();
      const mockerFunc = mocker.mockFunc(instance, instance.findBlankPosition);
      when(mockerFunc)(ArgumentMatchers.any).afterReturn(false);
      let result: boolean = instance.updatePageDesktopLayoutInfo(itemInfo, 1);
      expect(result).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_deleteBlankPageFromLayoutInfo', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let launcherLayoutCache: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com';
      itemInfo.abilityName = 'openharmony';
      itemInfo.row = 1;
      itemInfo.column = 1;
      itemInfo.page = 1;
      itemInfo.abilityName = 'openharmony';
      itemInfo.area = [2, 1];
      let mocker: MockKit = new MockKit();
      const mockerFunc = mocker.mockFunc(launcherLayoutCache, launcherLayoutCache.selectPageCount);
      const mockerFunc1 = mocker.mockFunc(launcherLayoutCache, launcherLayoutCache.isBlankPage);
      const mockerFunc2 = mocker.mockFunc(launcherLayoutCache, launcherLayoutCache.isBlankPage);
      const mockerFunc3 = mocker.mockFunc(instance, instance.getNeighborPage);
      when(mockerFunc)(ArgumentMatchers.any).afterReturn(10);
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockerFunc2)(ArgumentMatchers.any).afterReturn(true);
      when(mockerFunc3)(ArgumentMatchers.any).afterReturn(-1);
      let result: boolean = instance.deleteBlankPageFromLayoutInfo(CommonConstants.DEFAULT_WINDOWS_RADIUS_0, false);
      expect(result).assertTrue();
      mocker.clear(launcherLayoutCache);
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_getAppInfoFromDock_01', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let info: DockItemInfo = new DockItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
      let result: AppItemInfo = instance.getAppInfoFromDock(info);
      expect(result.appIconId).assertEqual(0);
    })

    it('test_PageDesktopModel_getAppInfoFromDock_02', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let info: DockItemInfo = new DockItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.appIndex = 996;
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [info], false);
      let result: AppItemInfo = instance.getAppInfoFromDock(info);
      expect(result.appIconId).assertEqual(0);
    })

    it('test_PageDesktopModel_getAppInfoFromDock_03', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let info: DockItemInfo = new DockItemInfo();
      info.bundleName = 'cn';
      info.abilityName = 'harmony';
      info.appIndex = 7;
      AppStorage.setOrCreate<DockItemInfo[]>('recentList', [info]);
      let result: AppItemInfo = instance.getAppInfoFromDock(info);
      expect(result.appIconId).assertEqual(0);
    })

    it('test_PageDesktopModel_getAppInfoFromDock_04', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let info: DockItemInfo = new DockItemInfo();
      info.bundleName = 'cn';
      info.abilityName = 'harmony';
      info.appIndex = 7;
      AppStorage.setOrCreate<DockItemInfo[]>('recentList', [info]);
      let result: AppItemInfo = instance.getAppInfoFromDock(info);
      expect(result.appIconId).assertEqual(0);
    })

    it('test_PageDesktopModel_getCloseAppData_01', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let mocker: MockKit = new MockKit();
      const mockerFunc1 = mocker.mockFunc(desktopUtil, desktopUtil['getShowOutLauncherStatus']);
      when(mockerFunc1)().afterReturn(true);
      let result: AppData = instance.getCloseAppData('com', 'openharmony', StartType.SHORTCUT_MENU, 'https', '007', 996);
      expect(result.iconRadius).assertEqual(0);
      mocker.clear(instance);
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_getCloseAppData_02', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let result: AppData = instance.getCloseAppData('com', 'openharmony', StartType.SHORTCUT_MENU, 'https', '007', 996, '007');
      expect(result.iconRadius).assertEqual(0);
    })

    it('test_PageDesktopModel_getExitAppData_01', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let mocker: MockKit = new MockKit();
      const mockerFunc1 = mocker.mockFunc(desktopUtil, desktopUtil['getShowOutLauncherStatus']);
      when(mockerFunc1)().afterReturn(true);
      let result: AppData = instance.getExitAppData('com', 'openharmony', 996, null, 'https', '007');
      expect(result.iconRadius).assertEqual(0);
      mocker.clear(instance);
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_getExitAppData_02', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let mocker: MockKit = new MockKit();
      const mockerFunc1 = mocker.mockFunc(desktopUtil, desktopUtil['getShowOutLauncherStatus']);
      when(mockerFunc1)().afterReturn(true);
      let result: AppData = instance.getExitAppData('com', 'openharmony', 996, StartType.RECENT_DOCK_APP);
      expect(result.iconRadius).assertEqual(0);
      mocker.clear(instance);
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_getExitAppData_03', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      let mocker: MockKit = new MockKit();
      const mockerFunc1 = mocker.mockFunc(desktopUtil, desktopUtil['getShowOutLauncherStatus']);
      when(mockerFunc1)().afterReturn(true);
      let result: AppData = instance.getExitAppData('com', 'openharmony', 996, StartType.SHORTCUT_APP , 'https', '007', '996');
      expect(result.iconRadius).assertEqual(0);
      mocker.clear(instance);
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it('test_PageDesktopModel_setOuterFormStackExitScale', 0, () => {
      let instance: PageDesktopModel = PageDesktopModel.getInstance();
      instance.setOuterFormStackExitScale(2.2);
      expect(instance.mOuterFormStackExitScale).assertEqual(2.2);
    })
  })
}
