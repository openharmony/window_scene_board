/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import {
  AppItemInfo,
  AppModel,
  CloseAppManager,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  DockItemInfo,
  EventConstants,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  PageDesktopLayoutConfig,
  PageDesktopModel, ReceiveEventInfo,
  RecentBundleMissionInfo,
  StartSubtype } from '../../../../main/ets/TsIndex'
import { HashMap } from '@kit.ArkTS';
import { StartType, CompanionIconInfo } from '@ohos/basicutils';
import {
  AbilityItemInfo,
  SCBSceneSessionManager,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty
} from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { bundleManager } from '@kit.AbilityKit';
import { WindowSize } from '@ohos/windowscene/src/main/ets/bean/AbilityItemInfo'
import sceneSessionManager from '@ohos.sceneSessionManager';

export default function BasePageDesktopModelTest() {

  describe('BasePageDesktopModelTest', () => {
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
      expect(instance).assertEqual(PageDesktopModel.getInstance());
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

    it('test_getGridOccupyStatusEnum', 0, () => {
      let model = PageDesktopModel.getInstance();
      let layoutInfo = PageDesktopLayoutConfig.getInstance().mGridLayoutInfo;
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.area = [0, 1];
      expect(model.isPositionValid(layoutInfo, itemInfo, 1000, 0, 0)).assertInstanceOf('Boolean');
      expect(model.isPositionValid(layoutInfo, itemInfo, 0, 1000, 0)).assertInstanceOf('Boolean');
      expect(model.isPositionValid(layoutInfo, itemInfo, 0, 0, 0)).assertInstanceOf('Boolean');
    })

    it('test_isPositionOccupied', 0, () => {
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
        cardId: 0
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
        cardId: 0
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
        cardId: 0
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
        cardId: 0
      }
      let itemInfo = new GridLayoutItemInfo();
      itemInfo.layoutInfo = [[new GridLayoutItemInfo()]];
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
        cardId: 0,
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
        cardId: 0,
        iconNumber: 0
      }
      retValue = model['isFoundFormStackCardTop'](itemInfo, companionIconInfo);
      expect(retValue).assertInstanceOf('Boolean');
    })

    it('test_isInDock', 0, () => {
      let model = PageDesktopModel.getInstance();
      let retValue = model.isInDock('com.ohos.sceneboard', 'abilityName');
      expect(retValue).assertInstanceOf('Boolean');

      retValue = model.isInRecentDock('com.ohos.sceneboard', 'abilityName');
      expect(retValue).assertInstanceOf('Boolean');
    })

    it('test_getAppInfoFromDock', 0, () => {
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

    it('test_getDragItemCenterPosition', 0, () => {
      let model = PageDesktopModel.getInstance();
      let retValue = model.getDragItemCenterPosition(0, 0, [1, 1]);
      expect(retValue).not().assertNull();

      model.registerGetCenterPositionCallback((column: number, row: number, area: number[]): number[] => {
        return [1, 2];
      });
      retValue = model.getDragItemCenterPosition(0, 0, [1, 1]);
      expect(retValue).not().assertNull();
    })

    it('test_getAppInfoFromDock', 0, () => {
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
      let dockItemInfo: DockItemInfo = {
        bundleName: 'bundleNotExists',
        abilityName: 'abilityNotExists',
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
      expect(retValue).assertTrue();

      retValue = model.isPositionValid(mGridLayoutInfo, item, page, 4, startRow);
      expect(retValue).assertFalse();

      retValue = model.isPositionValid(mGridLayoutInfo, item, page, startColumn, 6);
      expect(retValue).assertFalse();

      retValue = model.isPositionValid(mGridLayoutInfo, item, 100, startColumn, startRow);
      expect(retValue).assertTrue();
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
        cardId: 1,
        extraId: 1,
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
        cardId: 2,
        extraId: 2,
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
        cardId: 2,
        extraId: 2,
      };
      let isInScreen = false;
      try {
        pageDesktopModel.onTransitionActive(containerSession, isInScreen);
        expect(pageDesktopModel).assertEqual(PageDesktopModel.getInstance());
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
        cardId: 3,
        extraId: 3,
      };
      let isInScreen = true;
      pageDesktopModel.onTransitionActive(containerSession, isInScreen);
      expect(pageDesktopModel).assertEqual(PageDesktopModel.getInstance());
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
        cardId: 3,
        extraId: 3,
      };
      let isInScreen = false;
      try {
        pageDesktopModel.onTransitionActive(containerSession, isInScreen);
        expect(pageDesktopModel).assertEqual(PageDesktopModel.getInstance());
      } catch (error) {
      }
    })

    it('test_getDragItemCenterPosition_0', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopModel = PageDesktopModel.getInstance();
      let column: number = 0;
      let row: number = 0;
      let area: number[] = [0, 0];
      pageDesktopModel.registerGetCenterPositionCallback(null);
      let retValue = pageDesktopModel.getDragItemCenterPosition(column, row, area);
      expect(retValue).assertEqual(retValue);
    })

    it('test_getDragItemCenterPosition_1', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopModel = PageDesktopModel.getInstance();
      let column: number = 0;
      let row: number = 1;
      let area: number[] = [1, 1];
      pageDesktopModel.registerGetCenterPositionCallback((column: number, row: number, area: number[]): number[] => {
        let width: number = area[0] + column;
        let height: number = area[1] + row;
        return [width, height];
      });
      let retValue = pageDesktopModel.getDragItemCenterPosition(column, row, area);
      let retArea: number[] = [1, 2]
      expect(retValue[0]).assertEqual(retArea[0]);
      expect(retValue[1]).assertEqual(retArea[1]);
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
      model.getCloseAppData(null, null, undefined, 1, undefined);
      model.getCloseAppData(null, null, null, 1, undefined);
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
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
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
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('START_APP_ANI_MENU');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_2', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', []);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
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
      AppStorage.setOrCreate('residentList', residentList);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbilityentry',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_DOCK');
      mocker.clear(closeAppManager);
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
      AppStorage.setOrCreate('residentList', residentList);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
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
      AppStorage.setOrCreate('residentList', residentList);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      let isFold = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(isFold)().afterReturn(true);

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
      mocker.clear(DeviceHelper)
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
      AppStorage.setOrCreate('residentList', residentList);

      let recentItem: RecentBundleMissionInfo = {
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbilityentry'
      };

      let recentList: RecentBundleMissionInfo[] = new Array<RecentBundleMissionInfo>();
      recentList.push(recentItem);
      AppStorage.setOrCreate('residentList', residentList);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
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
        AppStorage.setOrCreate('residentList', recentList);

        let companionIconInfo: CompanionIconInfo = {
          iconId: '',
          bundleName: 'com.ohos.contacts',
          abilityName: 'MainAbility',
          moduleName: '',
          iconNumber: 0,
          iconRadius: 0,
          startAppType: StartType.APP,
          cardId: 0
        }

        AppStorage.setOrCreate('openFolderId', '0');

        expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
        mocker.clear(closeAppManager);
      } catch (error) {
        expect(false).assertFalse()
      }
    })

    it('test_getSceneLaunchType_8', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', []);

      let recentItem: RecentBundleMissionInfo = {
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility'
      }
      AppStorage.setOrCreate('residentList', [recentItem]);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      let isFold = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(isFold)().afterReturn(true);

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_DOCK');
      mocker.clear(closeAppManager);
      mocker.clear(DeviceHelper)
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
      AppStorage.setOrCreate('residentList', recentList);
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
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
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

        AppStorage.setOrCreate('residentList', null);
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
          cardId: 0
        }

        expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
        mocker.clear(closeAppManager);
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

      AppStorage.setOrCreate('residentList', null);
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
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
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
      let abilityItemInfo: AbilityItemInfo = {
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
      };
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

    //kaishi
    it('test_getSceneLaunchType_001', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
      AppStorage.setOrCreate('openFolderId', '1');

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.formStackId = '0';

      openFolderData.layoutInfo = [[]];
      AppStorage.setOrCreate('openFolderData', openFolderData);
      AppStorage.setOrCreate('openFolderPageIndex', 0);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.settings',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_002', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
      AppStorage.setOrCreate('openFolderId', '1');

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.formStackId = '0';

      openFolderData.layoutInfo = [[]];
      AppStorage.setOrCreate('openFolderData', openFolderData);
      AppStorage.setOrCreate('openFolderPageIndex', 0);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.settings',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_003', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
      AppStorage.setOrCreate('openFolderId', '1');

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.formStackId = '0';

      openFolderData.layoutInfo = [[]];
      AppStorage.setOrCreate('openFolderData', openFolderData);
      AppStorage.setOrCreate('openFolderPageIndex', 0);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.settings',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_004', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
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
        iconNumber: 1,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_005', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
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
        iconNumber: 2,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_006', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
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
        iconNumber: 3,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_007', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
      AppStorage.setOrCreate('openFolderId', '1');

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.formStackId = '0';

      openFolderData.layoutInfo = [[]];
      AppStorage.setOrCreate('openFolderData', openFolderData);
      AppStorage.setOrCreate('openFolderPageIndex', 1);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_008', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
      AppStorage.setOrCreate('openFolderId', '1');

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.formStackId = '0';

      openFolderData.layoutInfo = [[]];
      AppStorage.setOrCreate('openFolderData', openFolderData);
      AppStorage.setOrCreate('openFolderPageIndex', 2);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_009', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
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
        cardId: 1
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_010', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
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
        cardId: 2
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_012', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
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
        iconNumber: 1,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 1
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_013', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
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
        iconNumber: 1,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 2
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_014', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
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
        iconNumber: 2,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 1
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_015', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
      AppStorage.setOrCreate('openFolderId', '1');

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.formStackId = '0';

      openFolderData.layoutInfo = [[]];
      AppStorage.setOrCreate('openFolderData', openFolderData);
      AppStorage.setOrCreate('openFolderPageIndex', 1);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 1
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_016', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
      AppStorage.setOrCreate('openFolderId', '1');

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.formStackId = '0';

      openFolderData.layoutInfo = [[]];
      AppStorage.setOrCreate('openFolderData', openFolderData);
      AppStorage.setOrCreate('openFolderPageIndex', 2);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.contacts',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 1
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_017', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
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
        iconNumber: 2,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 2
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_018', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
      AppStorage.setOrCreate('openFolderId', '1');

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.formStackId = '0';

      openFolderData.layoutInfo = [[]];
      AppStorage.setOrCreate('openFolderData', openFolderData);
      AppStorage.setOrCreate('openFolderPageIndex', 0);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.photos',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 0,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })

    it('test_getSceneLaunchType_019', 0, () => {
      let model = PageDesktopModel.getInstance();

      let mocker: MockKit = new MockKit();
      let closeAppManager = CloseAppManager.getInstance();
      const mockerFunc1 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppType);
      when(mockerFunc1)().afterReturn(StartType.DOCK_APP);
      const mockerFunc2 = mocker.mockFunc(closeAppManager, closeAppManager.getStartAppSubtype);
      when(mockerFunc2)().afterReturn(StartSubtype.DOCK_ICON);

      AppStorage.setOrCreate('residentList', null);
      AppStorage.setOrCreate('openFolderId', '1');

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.formStackId = '0';

      openFolderData.layoutInfo = [[]];
      AppStorage.setOrCreate('openFolderData', openFolderData);
      AppStorage.setOrCreate('openFolderPageIndex', 0);

      let companionIconInfo: CompanionIconInfo = {
        iconId: '',
        bundleName: 'com.ohos.photos',
        abilityName: 'MainAbility',
        moduleName: '',
        iconNumber: 1,
        iconRadius: 0,
        startAppType: StartType.APP,
        cardId: 0
      }

      expect(model.getSceneLaunchType(companionIconInfo)).assertEqual('LAUNCHER_APP_LAUNCH_FROM_APPCENTER');
      mocker.clear(closeAppManager);
    })
  })
}
