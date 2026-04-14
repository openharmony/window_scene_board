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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  AppItemInfo,
  FolderAppItemInfo,
  FolderItemInfo,
  FolderReporter,
  GridLayoutItemInfo,
  GridLayoutItemBuilder,
  AppListInfo,
  DockItemInfo
} from '../../../../main/ets/TsIndex';
import { DragItemPosition } from '@ohos/componentdrag'
import { CommonConstants } from '../../../../main/ets/constants/CommonConstants';

function retNull(): DragItemPosition | null | GridLayoutItemInfo {
  return null;
}

export default function FolderReporterTest() {
  describe('FolderReporterTest', () => {
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

    it('test_isFolderInDock_true', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance()
      const resistDockItems: DockItemInfo[] = []
      const itemType: number = 1;
      const editable: boolean = false;
      const visible: boolean = false;
      const borderVisible: boolean = false;
      const shake: number = 0;
      const layoutInfo: GridLayoutItemInfo[][] = [];
      const iconId: string = '';
      const keyName: string = '1';
      const FolderItemInfo: FolderItemInfo = {
        folderId: '334545565556676',
        typeId: 0,
        folderName: undefined,
        appList: undefined,
        layoutInfo: [],
        badgeNumber: 0,
        column: 0,
        row: 0,
        area: [0, 1],
        page: 0,
        addIconGeometryId: '',
        backgroundGeometryId: '',
        enterEditing: false,
        extend1: ''
      }
      const data: DockItemInfo = {
        itemType,
        editable,
        visible,
        borderVisible,
        shake,
        layoutInfo,
        iconId,
        keyName,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: '',
        abilityName: ''
      }
      resistDockItems.push(data)
      FolderItemInfo.folderId = 'f0000000011111111'
      AppStorage.SetOrCreate('resistDockItems', resistDockItems);
      expect(FolderReporterInstance.isFolderInDock(FolderItemInfo)).assertFalse();
    })

    it('test_isFolderInDock_find', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance();
      let dockItem1: DockItemInfo = new DockItemInfo();
      let folderId: string = 'anyFolderId';
      dockItem1.area = [1, 1];
      dockItem1.keyName = folderId;
      let dockItem2: DockItemInfo = new DockItemInfo();
      const resistDockItems: DockItemInfo[] = [dockItem1, dockItem2];
      AppStorage.setOrCreate('resistDockItems', resistDockItems);

      let folderInfo: FolderItemInfo = new FolderItemInfo();
      folderInfo.folderId = folderId;
      expect(FolderReporterInstance.isFolderInDock(folderInfo)).assertTrue();
    });

    it('test_isFolderInDock_false', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance()
      const resistDockItems: DockItemInfo[] = []
      const itemType: number = 1;
      const editable: boolean = false;
      const visible: boolean = false;
      const borderVisible: boolean = false;
      const shake: number = 0;
      const layoutInfo: GridLayoutItemInfo[][] = [];
      const iconId: string = 'icon.jpg';
      const data: DockItemInfo = {
        itemType,
        editable,
        visible,
        borderVisible,
        shake,
        layoutInfo,
        iconId,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: 'abilityName'
      }
      resistDockItems.push(data)
      const FolderItemInfo: FolderItemInfo = {
        folderId: '0',
        typeId: 0,
        folderName: undefined,
        appList: undefined,
        layoutInfo: [],
        badgeNumber: 0,
        column: 0,
        row: 0,
        area: [],
        page: 0,
        addIconGeometryId: '',
        backgroundGeometryId: '',
        enterEditing: false,
        extend1: ''
      }
      AppStorage.setOrCreate('resistDockItems', resistDockItems);
      expect(FolderReporterInstance.isFolderInDock(FolderItemInfo)).assertFalse();
    })

    it('test_reportCreateFolder', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance()
      const folderId: string | undefined = undefined;
      const folderName: string | undefined = undefined;
      const appList: string[] | undefined = undefined;
      const layoutInfo: FolderAppItemInfo[][] = [];
      const badgeNumber: number = 0;
      const column: number = 1;
      const row: number = 2;
      const area: number[] = [];
      const page: number = 2;
      const addIconGeometryId: string = 'icon_demo';
      const totalBadgeGeometryId: string = '';
      const backgroundGeometryId: string = '';
      const enterEditing: boolean = true;
      const extend1: string = '';
      const container: number = 4;
      const isInDock: boolean = true;
      const data: FolderItemInfo = {
        folderId,
        folderName,
        appList,
        layoutInfo,
        badgeNumber,
        column,
        row,
        area,
        page,
        addIconGeometryId,
        totalBadgeGeometryId,
        backgroundGeometryId,
        enterEditing,
        extend1,
        container,
        typeId: 2
      }
      expect(data.folderId).assertEqual(folderId);
      expect(data.folderName).assertEqual(folderName);
      expect(data.appList).assertEqual(appList);
      expect(data.layoutInfo).assertEqual(layoutInfo);
      expect(data.badgeNumber).assertEqual(badgeNumber);
      expect(data.column).assertEqual(column);
      expect(data.row).assertEqual(row);
      expect(data.area).assertEqual(area);
      expect(data.page).assertEqual(page);
      expect(data.addIconGeometryId).assertEqual(addIconGeometryId);
      expect(data.totalBadgeGeometryId).assertEqual(totalBadgeGeometryId);
      expect(data.backgroundGeometryId).assertEqual(backgroundGeometryId);
      expect(data.enterEditing).assertEqual(enterEditing);
      expect(data.container).assertEqual(container);
      expect(data.addIconGeometryId).assertEqual(addIconGeometryId);
      expect(FolderReporterInstance.reportCreateFolder(data, isInDock) === undefined).assertTrue()
    })

    it('test_reportCreateFolder1', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance()
      try {
        expect(instance.reportCreateFolder(null, false) === undefined).assertTrue();
      } catch (e) {
        expect(instance).not().assertNull();
      }
    })

    it('test_reportCreateFolderInTransfer', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance()
      const isInDock: boolean = true;
      let data = new GridLayoutItemInfo();
      data.id = 1;
      data.infoId = '';
      data.infoName = '';
      data.cardId = '';
      data.folderId = '';
      data.formStackId = '';
      data.container = 0;
      data.folderName = '';
      data.badgeNumber = 0;
      data.typeId = 0;
      data.uri = 'uri:com.demo/hap';
      data.fileFolderName = 'fileFolderName';
      data.fileType = 1;
      data.ino = '';
      data.area = [];
      data.page = 0;
      data.column = 1;
      data.row = 2;
      data.bundleName = '';
      data.keyName = '';
      data.abilityName = '';
      data.moduleName = '';
      data.layoutInfo = [];
      data.appIconId = 123123123;
      data.appLabelId = 1;
      data.formRefreshDate = '';
      data.extend1 = '';
      data.extend2 = '';
      data.extend3 = 3;
      data.negativeId = 1;
      data.isSelect = false;
      data.operation = '';
      data.isTransparent = false;
      data.enterEditing = false;
      data.downloadProgress = 0;
      data.appStatus = 0;
      data.iconResource = '';
      data.callerName = '';
      data.hasContainerBackplane = false;
      data.centerAniX = 1;
      data.centerAniY = 1;

      expect(FolderReporterInstance.reportCreateFolderInTransfer(data, isInDock) === undefined).assertTrue()
    })

    it('test_reportCreateFolderInTransfer1', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance()
      try {
        expect(instance.reportCreateFolderInTransfer(null, false) === undefined).assertTrue();
      } catch (e) {
        expect(instance).not().assertNull();
      }
    })

    it('test_reportDragIconIntoDockFolder1', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance()
      try {
        expect(instance.reportDragIconIntoDockFolder(null, null) === undefined).assertTrue();
      } catch (e) {
        expect(instance).not().assertNull();
      }
    })

    it('test_reportDragIconIntoFolder1', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance()
      try {
        expect(instance.reportDragIconIntoFolder(null, null) === undefined).assertTrue();
      } catch (e) {
        expect(instance).not().assertNull();
      }
    })

    it('test_reportDragIconIntoDockFolder01', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance()
      const itemType: number = 0;
      const editable: boolean = true;
      const visible: boolean = true;
      const borderVisible: boolean = false;
      const shake: number = 0;
      const layoutInfo: GridLayoutItemInfo[][] = []
      const iconId: string = 'iconId';
      const missionInfoList = [];
      const appName: string = '';
      const appIconId: number = 1;
      const bundleName: string = '';
      const abilityName: string = 'abilityName';
      const startLayoutInfo: DockItemInfo = {
        itemType,
        editable,
        visible,
        borderVisible,
        shake,
        layoutInfo,
        iconId,
        missionInfoList,
        appName,
        appIconId,
        bundleName,
        abilityName
      }
      const endLayoutInfo: DockItemInfo = {
        itemType,
        editable,
        visible,
        borderVisible,
        shake,
        layoutInfo,
        iconId,
        missionInfoList,
        appName,
        appIconId,
        bundleName,
        abilityName
      }
      expect(startLayoutInfo.itemType).assertEqual(itemType);
      expect(startLayoutInfo.editable).assertEqual(editable);
      expect(startLayoutInfo.visible).assertEqual(visible);
      expect(startLayoutInfo.borderVisible).assertEqual(borderVisible);
      expect(startLayoutInfo.shake).assertEqual(shake);
      expect(startLayoutInfo.layoutInfo).assertEqual(layoutInfo);
      expect(startLayoutInfo.iconId).assertEqual(iconId);
      expect(startLayoutInfo.missionInfoList).assertEqual(missionInfoList);
      expect(startLayoutInfo.appName).assertEqual(appName);
      expect(startLayoutInfo.appIconId).assertEqual(appIconId);
      expect(startLayoutInfo.bundleName).assertEqual(bundleName);
      expect(startLayoutInfo.abilityName).assertEqual(abilityName);
      expect(endLayoutInfo.itemType).assertEqual(itemType);
      expect(endLayoutInfo.editable).assertEqual(editable);
      expect(endLayoutInfo.visible).assertEqual(visible);
      expect(endLayoutInfo.borderVisible).assertEqual(borderVisible);
      expect(endLayoutInfo.shake).assertEqual(shake);
      expect(endLayoutInfo.layoutInfo).assertEqual(layoutInfo);
      expect(endLayoutInfo.iconId).assertEqual(iconId);
      expect(endLayoutInfo.missionInfoList).assertEqual(missionInfoList);
      expect(endLayoutInfo.appName).assertEqual(appName);
      expect(endLayoutInfo.appIconId).assertEqual(appIconId);
      expect(endLayoutInfo.bundleName).assertEqual(bundleName);
      expect(endLayoutInfo.abilityName).assertEqual(abilityName);
      expect(FolderReporterInstance.reportDragIconIntoDockFolder(startLayoutInfo, endLayoutInfo) === undefined)
        .assertTrue()
    })

    it('test_reportDragIconIntoDockFolder102', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance();
      const itemType: number = 0;
      const editable: boolean = true;
      const visible: boolean = true;
      const borderVisible: boolean = false;
      const shake: number = 0;
      const layoutInfo: GridLayoutItemInfo[][] | undefined = undefined;
      const iconId: string = '';
      const missionInfoList = [];
      const appName: string = '';
      const appIconId: number = 1;
      const bundleName: string = 'com.ohos.demo';
      const abilityName: string = 'abilityName_demo';
      const endLayoutInfo: DockItemInfo = {
        itemType,
        editable,
        visible,
        borderVisible,
        shake,
        layoutInfo,
        iconId,
        missionInfoList,
        appName,
        appIconId,
        bundleName,
        abilityName
      }
      const startLayoutInfo: DockItemInfo = {
        itemType,
        editable,
        visible,
        borderVisible,
        shake,
        layoutInfo,
        iconId,
        missionInfoList,
        appName,
        appIconId,
        bundleName,
        abilityName
      }
      expect(startLayoutInfo.itemType).assertEqual(itemType);
      expect(startLayoutInfo.editable).assertEqual(editable);
      expect(startLayoutInfo.borderVisible).assertEqual(borderVisible);
      expect(startLayoutInfo.shake).assertEqual(shake);
      expect(startLayoutInfo.layoutInfo).assertEqual(layoutInfo);
      expect(startLayoutInfo.iconId).assertEqual(iconId);
      expect(startLayoutInfo.missionInfoList).assertEqual(missionInfoList);
      expect(startLayoutInfo.appName).assertEqual(appName);
      expect(startLayoutInfo.appIconId).assertEqual(appIconId);
      expect(startLayoutInfo.bundleName).assertEqual(bundleName);
      expect(startLayoutInfo.abilityName).assertEqual(abilityName);
      expect(endLayoutInfo.itemType).assertEqual(itemType);
      expect(endLayoutInfo.editable).assertEqual(editable);
      expect(endLayoutInfo.visible).assertEqual(visible);
      expect(endLayoutInfo.borderVisible).assertEqual(borderVisible);
      expect(endLayoutInfo.shake).assertEqual(shake);
      expect(endLayoutInfo.layoutInfo).assertEqual(layoutInfo);
      expect(endLayoutInfo.iconId).assertEqual(iconId);
      expect(endLayoutInfo.missionInfoList).assertEqual(missionInfoList);
      expect(endLayoutInfo.appName).assertEqual(appName);
      expect(endLayoutInfo.appIconId).assertEqual(appIconId);
      expect(endLayoutInfo.bundleName).assertEqual(bundleName);
      expect(endLayoutInfo.abilityName).assertEqual(abilityName);
      expect(FolderReporterInstance.reportDragIconIntoDockFolder(startLayoutInfo, endLayoutInfo) === undefined)
        .assertTrue()
    })

    it('test_reportDragIconIntoFolder', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance();
      let dragItemInfo = new GridLayoutItemInfo();
      dragItemInfo.id = 1;
      dragItemInfo.infoId = '';
      dragItemInfo.infoName = '';
      dragItemInfo.cardId = '';
      dragItemInfo.folderId = '';
      dragItemInfo.formStackId = '';
      dragItemInfo.container = 0;
      dragItemInfo.folderName = '';
      dragItemInfo.badgeNumber = 0;
      dragItemInfo.typeId = 0;
      dragItemInfo.uri = '111';
      dragItemInfo.fileFolderName = 'name';
      dragItemInfo.fileType = 1;
      dragItemInfo.ino = '';
      dragItemInfo.area = [];
      dragItemInfo.page = 0;
      dragItemInfo.column = 1;
      dragItemInfo.row = 1;
      dragItemInfo.bundleName = 'bundleName';
      dragItemInfo.keyName = 'keyName';
      dragItemInfo.abilityName = 'abilityName';
      dragItemInfo.moduleName = 'moduleName';
      dragItemInfo.layoutInfo = [];
      dragItemInfo.appIconId = 1;
      dragItemInfo.appLabelId = 1;
      dragItemInfo.formRefreshDate = '';
      dragItemInfo.extend1 = '';
      dragItemInfo.extend2 = '';
      dragItemInfo.extend3 = 2;
      dragItemInfo.negativeId = 1;
      dragItemInfo.isSelect = false;
      dragItemInfo.operation = '';
      dragItemInfo.isTransparent = false;
      dragItemInfo.enterEditing = false;
      dragItemInfo.downloadProgress = 0;
      dragItemInfo.appStatus = 1;
      dragItemInfo.iconResource = '';
      dragItemInfo.callerName = 'callerName';
      dragItemInfo.hasContainerBackplane = false;
      dragItemInfo.centerAniX = 2;
      dragItemInfo.centerAniY = 2;

      let endLayoutInfo = new GridLayoutItemInfo();
      endLayoutInfo.id = 1;
      endLayoutInfo.infoId = '';
      endLayoutInfo.infoName = '';
      endLayoutInfo.cardId = '';
      endLayoutInfo.folderId = 'f423452345';
      endLayoutInfo.formStackId = 'stack0000';
      endLayoutInfo.container = 0;
      endLayoutInfo.folderName = '';
      endLayoutInfo.badgeNumber = 0;
      endLayoutInfo.typeId = 0;
      endLayoutInfo.uri = '555';
      endLayoutInfo.fileFolderName = 'f_name';
      endLayoutInfo.fileType = 1;
      endLayoutInfo.ino = '';
      endLayoutInfo.area = [];
      endLayoutInfo.page = 0;
      endLayoutInfo.column = 1;
      endLayoutInfo.row = 1;
      endLayoutInfo.bundleName = '';
      endLayoutInfo.keyName = '';
      endLayoutInfo.abilityName = '';
      endLayoutInfo.moduleName = '';
      endLayoutInfo.layoutInfo = [];
      endLayoutInfo.appIconId = 1;
      endLayoutInfo.appLabelId = 1;
      endLayoutInfo.formRefreshDate = '';
      endLayoutInfo.extend1 = '';
      endLayoutInfo.extend2 = '';
      endLayoutInfo.extend3 = 2;
      endLayoutInfo.negativeId = 1;
      endLayoutInfo.isSelect = false;
      endLayoutInfo.operation = '';
      endLayoutInfo.isTransparent = false;
      endLayoutInfo.enterEditing = false;
      endLayoutInfo.downloadProgress = 0;
      endLayoutInfo.appStatus = 0;
      endLayoutInfo.iconResource = '';
      endLayoutInfo.callerName = '';
      endLayoutInfo.hasContainerBackplane = false;
      endLayoutInfo.centerAniX = 0;
      endLayoutInfo.centerAniY = 0;

      expect(FolderReporterInstance.reportDragIconIntoFolder(dragItemInfo, endLayoutInfo) === undefined).assertTrue()
    })

    it('test_reportDragFolder', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance();
      let folderItemInfo = new GridLayoutItemInfo();
      folderItemInfo.id = 1;
      folderItemInfo.infoId = '';
      folderItemInfo.infoName = '';
      folderItemInfo.cardId = '';
      folderItemInfo.folderId = '';
      folderItemInfo.formStackId = '';
      folderItemInfo.container = 0;
      folderItemInfo.folderName = '';
      folderItemInfo.badgeNumber = 0;
      folderItemInfo.typeId = 0;
      folderItemInfo.uri = '11aaaa1';
      folderItemInfo.fileFolderName = 'adaf';
      folderItemInfo.fileType = 1;
      folderItemInfo.ino = '';
      folderItemInfo.area = [];
      folderItemInfo.page = 0;
      folderItemInfo.column = 1;
      folderItemInfo.row = 1;
      folderItemInfo.bundleName = '';
      folderItemInfo.keyName = '';
      folderItemInfo.abilityName = '';
      folderItemInfo.moduleName = '';
      folderItemInfo.layoutInfo = [];
      folderItemInfo.appIconId = 1;
      folderItemInfo.appLabelId = 1;
      folderItemInfo.formRefreshDate = '';
      folderItemInfo.extend1 = '';
      folderItemInfo.extend2 = '';
      folderItemInfo.extend3 = 2;
      folderItemInfo.negativeId = 1;
      folderItemInfo.isSelect = false;
      folderItemInfo.operation = '';
      folderItemInfo.isTransparent = false;
      folderItemInfo.enterEditing = false;
      folderItemInfo.downloadProgress = 0;
      folderItemInfo.appStatus = 0;
      folderItemInfo.iconResource = '';
      folderItemInfo.callerName = '';
      folderItemInfo.hasContainerBackplane = false;
      folderItemInfo.centerAniX = 0;
      folderItemInfo.centerAniY = 0;
      let isInDockArea = false;

      const startPosition: DragItemPosition = {
        page: 0,
        row: 1,
        column: 1,
        x: 10,
        y: 5,
        isInDock: false,
      };
      const endPosition: DragItemPosition = {
        page: 0,
        row: 1,
        column: 1,
        x: 2,
        y: 2,
        isInDock: true,
      };

      expect(FolderReporterInstance.reportDragFolder(folderItemInfo, startPosition, endPosition, isInDockArea) === undefined)
        .assertTrue()
    })

    it('test_reportDragFolder_01', 0, () => {
      let instance = FolderReporter.getInstance();
      let startPosition: DragItemPosition = {
        page: 0,
        row: 1,
        column: 1,
        x: 10,
        y: 5,
        isInDock: false,
      };
      let endPosition: DragItemPosition = retNull() as DragItemPosition;
      let isInDockArea: boolean = true;
      let folderItemInfo: GridLayoutItemInfo = retNull() as GridLayoutItemInfo;
      instance.reportDragFolder(folderItemInfo, startPosition, endPosition, isInDockArea);

      folderItemInfo = new GridLayoutItemInfo();
      instance.reportDragFolder(folderItemInfo, startPosition, endPosition, isInDockArea);

      endPosition = {
        page: 0,
        row: 1,
        column: 1,
        x: 2,
        y: 2,
        isInDock: true,
      } as DragItemPosition;
      instance.reportDragFolder(folderItemInfo, startPosition, endPosition, isInDockArea);
      expect(instance).not().assertNull();
    })

    it('test_reportFolderOperation1', 0, () => {
      let instance = FolderReporter.getInstance();
      instance.reportFolderOperation(null, true);
      expect(instance).not().assertNull();
    })

    it('test_reportCloseFolder1', 0, () => {
      let instance = FolderReporter.getInstance();

      instance.reportCloseFolder(true, null);
      expect(instance).not().assertNull();
    })

    it('test_reportCloseFolder', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance();

      let folderItem = new GridLayoutItemInfo();
      folderItem.bundleName = 'bundleName';
      folderItem.abilityName = 'abilityName';
      folderItem.appIconId = 1;
      folderItem.negativeId = 1;
      folderItem.isSelect = false;
      folderItem.enterEditing = false;
      folderItem.downloadProgress = 0;
      folderItem.appStatus = 0;
      folderItem.iconResource = 'icon.png';
      folderItem.callerName = 'caller';

      expect(FolderReporterInstance.reportCloseFolder(false, folderItem) === undefined).assertTrue()
      expect(FolderReporterInstance.reportCloseFolder(true, folderItem) === undefined).assertTrue()
    })

    it('test_reportDragIconFromFolder01', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance();

      let removeLayout = new GridLayoutItemInfo();
      removeLayout.id = 1;
      removeLayout.infoId = '';
      removeLayout.infoName = '';
      removeLayout.cardId = '';
      removeLayout.folderId = '';
      removeLayout.formStackId = '';
      removeLayout.container = 0;
      removeLayout.folderName = '';
      removeLayout.badgeNumber = 0;
      removeLayout.typeId = 0;
      removeLayout.uri = 'uri';
      removeLayout.fileFolderName = 'fileFolderName';
      removeLayout.fileType = 1;
      removeLayout.ino = '';
      removeLayout.area = [];
      removeLayout.page = 0;
      removeLayout.column = 1;
      removeLayout.row = 1;
      removeLayout.bundleName = 'bundleName';
      removeLayout.keyName = '';
      removeLayout.abilityName = 'abilityName';
      removeLayout.moduleName = 'moduleName';
      removeLayout.layoutInfo = [];
      removeLayout.appIconId = 1;
      removeLayout.appLabelId = 1;
      removeLayout.formRefreshDate = '';
      removeLayout.extend1 = '';
      removeLayout.extend2 = '';
      removeLayout.extend3 = 2;
      removeLayout.negativeId = 1;
      removeLayout.isSelect = false;
      removeLayout.operation = '';
      removeLayout.isTransparent = false;
      removeLayout.enterEditing = false;
      removeLayout.downloadProgress = 0;
      removeLayout.appStatus = 0;
      removeLayout.iconResource = '';
      removeLayout.callerName = 'test name dt';
      removeLayout.hasContainerBackplane = false;
      removeLayout.centerAniX = 0;
      removeLayout.centerAniY = 0;

      const result: string = '';
      const tempOperation: string = '';

      expect(FolderReporterInstance.reportMenuModifyFolderSize(removeLayout, result, tempOperation) === undefined)
        .assertTrue()
    })

    it('test_reportDragIconFromFolder02', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance();

      let removeLayout = new GridLayoutItemInfo();
      removeLayout.id = 1;
      removeLayout.infoId = '';
      removeLayout.infoName = '';
      removeLayout.cardId = '';
      removeLayout.folderId = '';
      removeLayout.formStackId = '';
      removeLayout.container = 0;
      removeLayout.folderName = '';
      removeLayout.badgeNumber = 0;
      removeLayout.typeId = 0;
      removeLayout.uri = '111';
      removeLayout.fileFolderName = 'name';
      removeLayout.fileType = 1;
      removeLayout.ino = '';
      removeLayout.area = [];
      removeLayout.page = 0;
      removeLayout.column = 1;
      removeLayout.row = 1;
      removeLayout.bundleName = 'b';
      removeLayout.keyName = 'k';
      removeLayout.abilityName = 'main abiliity';
      removeLayout.moduleName = '';
      removeLayout.layoutInfo = [];
      removeLayout.appIconId = 1;
      removeLayout.appLabelId = 1;
      removeLayout.formRefreshDate = '';
      removeLayout.extend1 = '';
      removeLayout.extend2 = '';
      removeLayout.extend3 = 2;
      removeLayout.negativeId = 1;
      removeLayout.isSelect = false;
      removeLayout.operation = '';
      removeLayout.isTransparent = false;
      removeLayout.enterEditing = false;
      removeLayout.downloadProgress = 0;
      removeLayout.appStatus = 0;
      removeLayout.iconResource = '';
      removeLayout.callerName = '';
      removeLayout.hasContainerBackplane = false;
      removeLayout.centerAniX = 0;
      removeLayout.centerAniY = 0;

      const result: string = '';
      const tempOperation: string = '111';

      expect(FolderReporterInstance.reportMenuModifyFolderSize(removeLayout, result, tempOperation) === undefined)
        .assertTrue()
    })

    it('test_reportDragIconFromFolder03', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance();

      let removeLayout = new GridLayoutItemInfo();
      removeLayout.id = 1;
      removeLayout.infoId = '4567';
      removeLayout.infoName = 'desc.';
      removeLayout.cardId = '';
      removeLayout.folderId = 'adfasdf';
      removeLayout.formStackId = '';
      removeLayout.container = 0;
      removeLayout.folderName = '';
      removeLayout.badgeNumber = 0;
      removeLayout.typeId = 0;
      removeLayout.uri = '67899';
      removeLayout.fileFolderName = 'name';
      removeLayout.fileType = 1;
      removeLayout.ino = '';
      removeLayout.area = [];
      removeLayout.page = 0;
      removeLayout.column = 1;
      removeLayout.row = 1;
      removeLayout.bundleName = 'bundleName0';
      removeLayout.keyName = '';
      removeLayout.abilityName = 'abilityName';
      removeLayout.moduleName = 'moduleName';
      removeLayout.layoutInfo = [];
      removeLayout.appIconId = 1;
      removeLayout.appLabelId = 1;
      removeLayout.formRefreshDate = '';
      removeLayout.extend1 = '';
      removeLayout.extend2 = '';
      removeLayout.extend3 = 2;
      removeLayout.negativeId = 1;
      removeLayout.isSelect = false;
      removeLayout.operation = '';
      removeLayout.isTransparent = false;
      removeLayout.enterEditing = false;
      removeLayout.downloadProgress = 0;
      removeLayout.appStatus = 0;
      removeLayout.iconResource = 'app.png';
      removeLayout.callerName = '';
      removeLayout.hasContainerBackplane = false;
      removeLayout.centerAniX = 0;
      removeLayout.centerAniY = 0;

      const result: string = '123';
      const tempOperation: string = '';

      expect(FolderReporterInstance.reportMenuModifyFolderSize(removeLayout, result, tempOperation) === undefined)
        .assertTrue()
    })

    it('test_reportDragIconFromFolder04', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance();

      let removeLayout = new GridLayoutItemInfo();
      removeLayout.id = 1;
      removeLayout.infoId = '';
      removeLayout.infoName = '';
      removeLayout.cardId = '';
      removeLayout.folderId = '';
      removeLayout.formStackId = '';
      removeLayout.container = 0;
      removeLayout.folderName = '';
      removeLayout.badgeNumber = 0;
      removeLayout.typeId = 0;
      removeLayout.uri = 'ad3445555';
      removeLayout.fileFolderName = 'folder';
      removeLayout.fileType = 1;
      removeLayout.ino = '';
      removeLayout.area = [];
      removeLayout.page = 0;
      removeLayout.column = 1;
      removeLayout.row = 1;
      removeLayout.bundleName = 'bundleName';
      removeLayout.keyName = '';
      removeLayout.abilityName = 'abilityName';
      removeLayout.moduleName = 'module';
      removeLayout.layoutInfo = [];
      removeLayout.appIconId = 1;
      removeLayout.appLabelId = 1;
      removeLayout.formRefreshDate = '';
      removeLayout.extend1 = '';
      removeLayout.extend2 = '';
      removeLayout.extend3 = 2;
      removeLayout.negativeId = 1;
      removeLayout.isSelect = false;
      removeLayout.operation = '';
      removeLayout.isTransparent = false;
      removeLayout.enterEditing = false;
      removeLayout.downloadProgress = 0;
      removeLayout.appStatus = 0;
      removeLayout.iconResource = 'icon.png';
      removeLayout.callerName = '';
      removeLayout.hasContainerBackplane = false;
      removeLayout.centerAniX = 0;
      removeLayout.centerAniY = 0;

      const result: string = 'RES: 0, FAILREASON: 0';
      const tempOperation: string = '111';

      expect(FolderReporterInstance.reportMenuModifyFolderSize(removeLayout, result, tempOperation) === undefined)
        .assertTrue()
    })

    it('test_reportMoveIconInFolder', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance();

      let tempGridInfo = new GridLayoutItemInfo();
      tempGridInfo.bundleName = 'bundleName';
      tempGridInfo.abilityName = 'abilityName1';
      tempGridInfo.appIconId = 1;
      tempGridInfo.negativeId = 1;
      tempGridInfo.isSelect = false;
      tempGridInfo.enterEditing = false;
      tempGridInfo.downloadProgress = 0;
      tempGridInfo.appStatus = 0;
      tempGridInfo.iconResource = '';
      tempGridInfo.callerName = '';

      let dragItemInfo = new GridLayoutItemInfo();
      dragItemInfo.bundleName = 'bundleName';
      dragItemInfo.abilityName = 'abilityName2';
      dragItemInfo.appIconId = 1;
      dragItemInfo.negativeId = 1;
      dragItemInfo.isSelect = false;
      dragItemInfo.enterEditing = false;
      dragItemInfo.downloadProgress = 0;
      dragItemInfo.appStatus = 0;
      dragItemInfo.iconResource = '';
      dragItemInfo.callerName = '';

      const dragItemFolderPosition1: number[] = [];
      const endAppPosition1: number[] = [];
      FolderReporterInstance.reportMoveIconInFolder(null, 1, dragItemInfo, dragItemFolderPosition1, endAppPosition1);

      expect(FolderReporterInstance.reportMoveIconInFolder(tempGridInfo, 1, dragItemInfo, dragItemFolderPosition1, endAppPosition1) === undefined)
        .assertTrue();
      const dragItemFolderPosition2: number[] = [1, 2]
      const endAppPosition2: number[] = [1, 2]
      expect(FolderReporterInstance.reportMoveIconInFolder(tempGridInfo, 1, dragItemInfo, dragItemFolderPosition2, endAppPosition2) === undefined)
        .assertTrue();
    })

    it('test_reportFolderOperation', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance();

      let folderItem = new GridLayoutItemInfo();
      folderItem.bundleName = '';
      folderItem.abilityName = 'abilityName3';
      folderItem.appIconId = 1;
      folderItem.negativeId = 1;
      folderItem.isSelect = false;
      folderItem.enterEditing = false;
      folderItem.downloadProgress = 0;
      folderItem.appStatus = 0;
      folderItem.iconResource = '';
      folderItem.callerName = '';

      expect(FolderReporterInstance.reportFolderOperation(folderItem, false) === undefined).assertTrue()
      expect(FolderReporterInstance.reportFolderOperation(folderItem, true) === undefined).assertTrue()
    })

    it('test_reportDragIconFromFolder', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      instance.reportDragIconFromFolder(null, null);

      let folderItemInfo = new GridLayoutItemInfo();

      folderItemInfo.id = 1;
      folderItemInfo.infoId = 'abilityName';
      folderItemInfo.infoName = 'abilityName';
      folderItemInfo.cardId = '';
      folderItemInfo.folderId = '';
      folderItemInfo.formStackId = '';
      folderItemInfo.container = 0;
      folderItemInfo.folderName = '';
      folderItemInfo.badgeNumber = 0;
      folderItemInfo.typeId = 0;
      folderItemInfo.uri = 'abilityName';
      folderItemInfo.fileFolderName = 'abilityName';
      folderItemInfo.fileType = 1;
      folderItemInfo.ino = '';
      folderItemInfo.area = [];
      folderItemInfo.page = 0;
      folderItemInfo.column = 1;
      folderItemInfo.row = 7;
      folderItemInfo.bundleName = 'bundleName';
      folderItemInfo.keyName = 'keyName';
      folderItemInfo.abilityName = 'abilityName';
      folderItemInfo.moduleName = '';
      folderItemInfo.layoutInfo = [];
      folderItemInfo.appIconId = 1;
      folderItemInfo.appLabelId = 1;
      folderItemInfo.formRefreshDate = '';
      folderItemInfo.extend1 = '';
      folderItemInfo.extend2 = '';
      folderItemInfo.extend3 = 5;
      folderItemInfo.negativeId = 1;
      folderItemInfo.isSelect = false;
      folderItemInfo.operation = '';
      folderItemInfo.isTransparent = false;
      folderItemInfo.enterEditing = false;
      folderItemInfo.downloadProgress = 0;
      folderItemInfo.appStatus = 0;
      folderItemInfo.iconResource = '';
      folderItemInfo.callerName = '';
      folderItemInfo.hasContainerBackplane = false;
      folderItemInfo.centerAniX = 0;
      folderItemInfo.centerAniY = 0;

      AppStorage.setOrCreate('dragItemType', 7);

      let dragItemBundleName: string = '123';
      instance.reportDragIconFromFolder(dragItemBundleName, folderItemInfo);

      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com.ohos.clock';
      info.abilityName = 'abilityName';
      info.appIconId = 0;
      info.negativeId = 0;
      info.isSelect = false;
      info.enterEditing = false;
      info.downloadProgress = 0;

      let infos: GridLayoutItemInfo[] = [info];
      const layoutInfo1: GridLayoutItemInfo[][] = [infos];

      let folderItemInfo2 = new GridLayoutItemInfo();
      folderItemInfo2.bundleName = 'com.ohos.health';
      folderItemInfo2.abilityName = 'health';
      folderItemInfo2.appIconId = 0;
      folderItemInfo2.negativeId = 0;
      folderItemInfo2.isSelect = false;
      folderItemInfo2.enterEditing = false;
      folderItemInfo2.downloadProgress = 0;
      instance.reportDragIconFromFolder(dragItemBundleName, folderItemInfo2);

      folderItemInfo2.layoutInfo = layoutInfo1;
      AppStorage.setOrCreate('dragItemType', 8);
      instance.reportDragIconFromFolder(dragItemBundleName, folderItemInfo2);
      expect(instance).not().assertNull();
    })

    it('test_isInDock', 0, () => {
      const FolderReporterInstance: FolderReporter = FolderReporter.getInstance();
      const isInDock: boolean = FolderReporterInstance.isInDock('', '');
      expect(isInDock).assertEqual(FolderReporterInstance.isInDock('', ''))
    })
    it('test_getInstance', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      expect(instance).assertEqual(FolderReporter.getInstance());
      expect(instance).assertEqual(FolderReporter.getInstance());
    })

    it('test_getFolderIconCount_01', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let folderItemLayoutInfo: Array<GridLayoutItemInfo[]> = [];
      instance['getFolderIconCount'](folderItemLayoutInfo);
      expect(folderItemLayoutInfo.length).assertEqual(0);
    });

    it('test_getItemPositionInDesktop_01', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let itemInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let isInDock: boolean = false;
      let appListInfo: AppListInfo = {} as AppListInfo;
      AppStorage.setOrCreate<AppListInfo>('appListInfo', appListInfo);

      let ret: string = instance['getItemPositionInDesktop'](itemInfo, isInDock);
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('test_getItemPositionInDesktop_02', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.clock';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'dt.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo.layoutInfo = [[item1], [item2]];
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo.keyName = 'key here';
      let isInDock: boolean = false;

      let appListInfo: AppListInfo = new AppListInfo();
      appListInfo.appGridInfo = [];
      AppStorage.setOrCreate<AppListInfo>('appListInfo', appListInfo);

      let ret: string = instance['getItemPositionInDesktop'](itemInfo, isInDock)
      expect(ret.length).assertLargerOrEqual(0);
    });


    it('test_reportCreateFolderInTransfer_01', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let folderInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let isInDock: boolean = true;
      instance.reportCreateFolderInTransfer(folderInfo, isInDock);
      expect(isInDock).assertTrue();
    });

    it('test_reportCreateFolderInTransfer_02', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let folderInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;

      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;

      folderInfo.layoutInfo = [[item1], [item2]];
      folderInfo.typeId = CommonConstants.TYPE_FOLDER;
      folderInfo.keyName = 'keyName0';
      let isInDock: boolean = false;
      instance.reportCreateFolderInTransfer(folderInfo, isInDock);
      expect(isInDock).assertFalse();
    });

    it('test_reportCloseFolder_11', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let isCloseFolderAni: boolean = false;
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      instance.reportCloseFolder(isCloseFolderAni, folderItem);
      expect(isCloseFolderAni).assertFalse();
    });

    it('test_reportCloseFolder_12', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let isCloseFolderAni: boolean = true;
      let folderItem: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      instance.reportCloseFolder(isCloseFolderAni, folderItem);
      expect(isCloseFolderAni).assertTrue();
    });

    it('test_reportCloseFolder_13', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let isCloseFolderAni: boolean = true;
      let folderItem: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.maps.app';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.photos';
      item3.typeId = CommonConstants.TYPE_ADD;
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'dt.ohos.sceneboard';
      item4.typeId = CommonConstants.TYPE_ADD;

      folderItem.layoutInfo = [[item1], [item2]];
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.keyName = 'maps';

      instance.reportCloseFolder(isCloseFolderAni, folderItem);
      expect(isCloseFolderAni).assertTrue();
    });

    it('test_reportMoveIconInFolder_11', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let tempGridInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let pageIndex: number = 0;
      let dragItemInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let dragItemFolderPosition: number[] = [];
      let endAppPosition: number[] = [];
      instance.reportMoveIconInFolder(tempGridInfo, pageIndex, dragItemInfo, dragItemFolderPosition, endAppPosition);
      expect(pageIndex).assertEqual(0);
    });

    it('test_reportMoveIconInFolder_12', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let tempGridInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let pageIndex: number = 2;
      let dragItemInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let dragItemFolderPosition: number[] = [];
      let endAppPosition: number[] = [];
      AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_FOLDER_IN_DOCK);
      instance.reportMoveIconInFolder(tempGridInfo, pageIndex, dragItemInfo, dragItemFolderPosition, endAppPosition);
      expect(pageIndex).assertEqual(0);
    });

    it('test_reportMoveIconInFolder_13', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let tempGridInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let pageIndex: number = 0;
      let dragItemInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let dragItemFolderPosition: number[] = [];
      let endAppPosition: number[] = [];
      AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_FORM_INTELLIGENT);
      instance.reportMoveIconInFolder(tempGridInfo, pageIndex, dragItemInfo, dragItemFolderPosition, endAppPosition);
      expect(pageIndex).assertEqual(0);
    });


    it('test_reportMoveIconInFolder_14', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let tempGridInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let pageIndex: number = 1;
      let dragItemInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let dragItemFolderPosition: number[] = [];
      let endAppPosition: number[] = [];
      AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_FORM_INTELLIGENT);
      instance.reportMoveIconInFolder(tempGridInfo, pageIndex, dragItemInfo, dragItemFolderPosition, endAppPosition);
      expect(pageIndex).assertEqual(0);
    });

    it('test_reportMoveIconInFolder_05', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let tempGridInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let pageIndex: number = 0;
      let dragItemInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let dragItemFolderPosition: number[] = [1, 2, 4];
      let endAppPosition: number[] = [];
      AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_FORM_INTELLIGENT);
      instance.reportMoveIconInFolder(tempGridInfo, pageIndex, dragItemInfo, dragItemFolderPosition, endAppPosition);
      expect(pageIndex).assertEqual(0);
    });

    it('test_reportMoveIconInFolder_06', 0, () => {
      const instance: FolderReporter = FolderReporter.getInstance();
      let tempGridInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let pageIndex: number = 0;
      let dragItemInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let dragItemFolderPosition: number[] = [1, 2, 3, 4];
      let endAppPosition: number[] = [1, 2, 3, 4];
      AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_FORM_INTELLIGENT);
      instance.reportMoveIconInFolder(tempGridInfo, pageIndex, dragItemInfo, dragItemFolderPosition, endAppPosition);
      expect(pageIndex).assertEqual(0);
    });

  })
}
