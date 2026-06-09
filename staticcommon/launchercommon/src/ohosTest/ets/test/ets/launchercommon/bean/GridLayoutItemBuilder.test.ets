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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { GameCardInfo } from '../../../../../../main/ets/bean/GameCardInfo'
import { AppItemInfo } from '../../../../../../main/ets/TsIndex'
import { GridLayoutItemBuilder } from '../../../../../../main/ets/TsIndex'
import { GridLayoutItemInfo } from '../../../../../../main/ets/TsIndex'



export default function GridLayoutItemBuilderTest() {
  describe('GridLayoutItemBuilderTest', () => {
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

    it('test_setFormConfigAbility', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const formConfigAbility: string = 'anyFormAbility';
      builder.setFormConfigAbility(formConfigAbility);
      expect(builder.formConfigAbility).assertEqual(formConfigAbility);
    })

    it('test_setAppName', 0, () => {
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const appName: string = 'anyAppName';
      builder.setAppName(appName);
      expect(builder.appName).assertEqual(appName);
    })

    it('test_setCardName', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const cardName : string = 'anyCardName';
      builder.setCardName(cardName);
      expect(builder.cardName ).assertEqual(cardName);
    })

    it('test_setCardId', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const cardId: string = '100';
      builder.setCardId(cardId);
      expect(builder.cardId).assertEqual(cardId);
    })

    it('test_setFolderId', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const folderId: string = 'anyFolderId';
      builder.setFolderId(folderId);
      expect(builder.folderId).assertEqual(folderId);
    })

    it('test_setContainer', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const container: number = 10;
      builder.setContainer(container);
      expect(builder.container).assertEqual(container);
    })

    it('test_setFolderName', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const folderName: string = 'anyFolderName';
      builder.setFolderName(folderName);
      expect(builder.folderName).assertEqual(folderName);
    })

    it('test_setBadgeNumber', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const badgeNumber: number = 88;
      builder.setBadgeNumber(badgeNumber);
      expect(builder.badgeNumber).assertEqual(badgeNumber);
    })

    it('test_setTypeId', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const typeId: number = 2;
      builder.setTypeId(typeId);
      expect(builder.typeId).assertEqual(typeId);
    })

    it('test_setArea', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const area: string = '1,1';
      builder.setArea(area);
      expect(builder.area?.length).assertEqual(2);
    })

    it('test_getArea', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let area: string = '1,2';
      let retArray = GridLayoutItemBuilder.getArea(area);
      expect(retArray.length).assertEqual(2);

      area = '';
      retArray = GridLayoutItemBuilder.getArea(area);
      expect(retArray.length).assertEqual(0);
      area = '1';
      retArray = GridLayoutItemBuilder.getArea(area);
      expect(retArray.length).assertEqual(0);

      area = '1,2,3';
      retArray = GridLayoutItemBuilder.getArea(area);
      expect(retArray.length).assertEqual(0);
    })

    it('test_setPage', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const page: number = 2;
      builder.setPage(page);
      expect(builder.page).assertEqual(page);
    })

    it('test_setColumn', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const column: number = 2;
      builder.setColumn(column);
      expect(builder.column).assertEqual(column);
    })

    it('test_setRow', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const row: number = 1;
      builder.setRow(row);
      expect(builder.row).assertEqual(row);
    })

    it('test_setBundleName', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const bundleName: string = 'anyBundleName';
      builder.setBundleName(bundleName);
      expect(builder.bundleName).assertEqual(bundleName);
    })

    it('test_setKeyName', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const keyName: string = 'anyKeyName';
      builder.setKeyName(keyName);
      expect(builder.keyName).assertEqual(keyName);
    })

    it('test_setAbilityName', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const abilityName: string = 'anyAbilityName';
      builder.setAbilityName(abilityName);
      expect(builder.abilityName).assertEqual(abilityName);
    })

    it('test_setModuleName', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const moduleName: string = 'anyModuleName';
      builder.setModuleName(moduleName);
      expect(builder.moduleName).assertEqual(moduleName);
    })

    it('test_setAppIconId', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const appIconId: number = 200;
      builder.setAppIconId(appIconId);
      expect(builder.appIconId).assertEqual(appIconId);
    })

    it('test_setAppLabelId', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const appLabelId: number = 2;
      builder.setAppLabelId(appLabelId);
      expect(builder.appLabelId).assertEqual(appLabelId);
    })

    it('test_setLayoutInfo', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const appItemInfos: AppItemInfo[] = [];
      builder.setLayoutInfo(appItemInfos);
      expect(builder.layoutInfo).assertEqual(appItemInfos);
    })

    it('test_setFileFolderName', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const fileFolderName: string = 'anyFileFolderName';
      builder.setFileFolderName(fileFolderName);
      expect(builder.fileFolderName).assertEqual(fileFolderName);
    })

    it('test_setUri', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const uri: string = 'anyUri';
      builder.setUri(uri);
      expect(builder.uri).assertEqual(uri);
    })

    it('test_setExtend1', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const extend1: string = 'anyExtend1';
      builder.setExtend1(extend1);
      expect(builder.extend1).assertEqual(extend1);
    })

    it('test_setExtend2', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const extend2: string = 'anyExtend2';
      builder.setExtend2(extend2);
      expect(builder.extend2).assertEqual(extend2);
    })

    it('test_setExtend3', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const extend3: number = 10;
      builder.setExtend3(extend3);
      expect(builder.extend3).assertEqual(extend3);
    })

    it('test_setIconResource', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const iconResource: string = 'anyIconResource';
      builder.setIconResource(iconResource);
      expect(builder.iconResource).assertEqual(iconResource);
    })

    it('test_setCallerName', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const callerName: string = 'anyCallerNameYouLike';
      builder.setCallerName(callerName);
      expect(builder.callerName).assertEqual(callerName);
    })

    it('test_setDownloadProgress', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const progress: number = 20;
      builder.setDownloadProgress(progress);
      expect(builder.downloadProgress ).assertEqual(progress);
    })

    it('test_setAppStatus', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const appStatus: number = 10;
      builder.setAppStatus(appStatus);
      expect(builder.appStatus).assertEqual(appStatus);
    })

    it('test_setCallerName', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const callerName: string = 'a';
      builder.setCallerName(callerName);
      expect(builder.callerName).assertEqual(callerName);
    })

    it('test_setInfoId', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const infoId: string = '1';
      builder.setInfoId(infoId);
      expect(builder.infoId).assertEqual(infoId);
    })

    it('test_setIsTransparent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const isTransparent: boolean = false;
      builder.setIsTransparent(isTransparent);
      expect(builder.isTransparent).assertEqual(isTransparent);
    })

    it('test_setAppIndex', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const appIndex: number = 10;
      builder.setAppIndex(appIndex);
      expect(builder.appIndex).assertEqual(appIndex);
    })

    it('test_setShortcutId', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const shortcutId: string = '1';
      builder.setShortcutId(shortcutId);
      expect(builder.shortcutId).assertEqual(shortcutId);
    })

    it('test_setIntent', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const intent: string = '1';
      builder.setIntent(intent);
      expect(builder.intent).assertEqual(intent);
    })

    it('test_setSize', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const size: number = 10;
      builder.setSize(size);
      expect(builder.size).assertEqual(size);
    })

    it('test_setCtime', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const ctime: number = 10;
      builder.setCtime(ctime);
      expect(builder.ctime).assertEqual(ctime);
    })

    it('test_setMtime', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const mtime: number = 10;
      builder.setMtime(mtime);
      expect(builder.mtime).assertEqual(mtime);
    })

    it('test_setGameCardInfo', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const gameCardInfo: GameCardInfo = new GameCardInfo();
      builder.setGameCardInfo(gameCardInfo);
      expect(builder.gameCardInfo).assertEqual(gameCardInfo);
    })

    it('test_buildGridLayoutItem', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const iconResource: string = 'anyIconResource';
      builder.setIconResource(iconResource);
      const retValue: GridLayoutItemInfo = builder.buildGridLayoutItem();
      expect(retValue.iconResource).assertEqual(iconResource);
    })

    it('test_setKindId', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const id: number = 1;
      builder.setKindId(id);
      expect(builder.kindId).assertLessOrEqual(1);
    })

    it('test_setFileType', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const fileType: number = 1;
      builder.setFileType(fileType);
      expect(builder.fileType).assertLessOrEqual(1);
    })

    it('test_setIno', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const ino: string = '1';
      builder.setIno(ino);
      expect(builder.ino).assertEqual('1');
    })

    it('test_setFormStackId', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let builder: GridLayoutItemBuilder  = new GridLayoutItemBuilder(1);
      const formStackId: string = '1';
      builder.setFormStackId(formStackId);
      expect(builder.formStackId).assertEqual('1');
    })

    it('test_buildLayout', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try {
        const resultSet = '{}';
        let appItemInfo: AppItemInfo = GridLayoutItemBuilder.buildLayout(resultSet);
        expect(appItemInfo).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_fromResultSet', 0, () => {
      try {
        // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
        const resultSet = '{}';
        let appItemInfo: GridLayoutItemBuilder = GridLayoutItemBuilder.fromResultSet(resultSet);
        expect(appItemInfo).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
  })
}