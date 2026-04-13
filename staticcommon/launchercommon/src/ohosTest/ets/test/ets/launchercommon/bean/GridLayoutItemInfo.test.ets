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
import { GridLayoutItemBuilder } from '../../../../../../main/ets/TsIndex'
import { AppItemInfo, GridLayoutItemInfo } from '../../../../../../main/ets/TsIndex'

export default function GridLayoutItemInfoTest() {
  describe('GridLayoutItemInfoTest', () => {
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
    it('test_member', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let layoutInfo = new GridLayoutItemInfo();
      const bundleName = 'anyBundleName';
      const abilityName: string = 'anyAbilityName';
      const isSelected: boolean = true;
      const isTransparent: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number = 0;
      layoutInfo.bundleName = bundleName;
      layoutInfo.abilityName = abilityName;
      layoutInfo.isSelect = isSelected;
      layoutInfo.isTransparent = isTransparent;
      layoutInfo.enterEditing = enterEditing;
      layoutInfo.downloadProgress = downloadProgress;
      layoutInfo.appStatus = appStatus;

      expect(layoutInfo.bundleName).assertEqual(bundleName);
    })

    it('test_setInfo', 0, () => {
      const id: number = 100;
      const cardId: string = '999';
      const folderId = 'anyFolderId';
      const formStackId = 'anyFormStackId';
      const container = 10;
      const folderName = 'anyFolderName';
      const fileFolderName = 'anyFileFolderName';
      const builder: GridLayoutItemBuilder = new GridLayoutItemBuilder(id);
      builder.setCardId(cardId)
        .setFolderId(folderId)
        .setFormStackId(formStackId)
        .setContainer(container)
        .setFolderName(folderName)
        .setFileFolderName(fileFolderName)

      let layoutInfo = new GridLayoutItemInfo();
      layoutInfo.setInfo(builder);
      expect(layoutInfo.cardId).assertEqual(cardId);
      expect(layoutInfo.folderId).assertEqual(folderId);
      expect(layoutInfo.formStackId).assertEqual(formStackId);
      expect(layoutInfo.container).assertEqual(container);
      expect(layoutInfo.folderName).assertEqual(folderName);
      expect(layoutInfo.fileFolderName).assertEqual(fileFolderName);
    });

    it('test_fillInfoWithAppItem', 0, () => {
      const appItem : AppItemInfo = new AppItemInfo();
      const appName: string = 'anyAppName';
      const appIconId: number = 101;
      const appLabelId = 100;
      const bundleName = 'anyBundleName';
      const abilityName = 'anyAbilityName';
      const moduleName = 'anyModuleName';
      const typeId = 99;
      const area: number[] = [1, 1];
      const page = 1;
      const column = 2;
      const kindId = 1;

      const bundleType = 2;
      const applicationName = 'anyApplicationName';
      const downloadProgress = 20;
      const appStatus = 3;
      const iconResource =  'anyIconResource';
      const callerName = 'anyCallerName';

      appItem.appName = appName;
      appItem.appIconId = appIconId;
      appItem.bundleName = bundleName;
      appItem.abilityName = abilityName;
      appItem.moduleName = moduleName;
      appItem.typeId = typeId;
      appItem.area = area;
      appItem.page = page;
      appItem.column = column;
      appItem.kindId = kindId;

      appItem.bundleType = bundleType;
      appItem.applicationName = applicationName;
      appItem.downloadProgress = downloadProgress;
      appItem.appStatus = appStatus;
      appItem.iconResource = iconResource;
      appItem.callerName = callerName;

      let layoutInfo = new GridLayoutItemInfo();
      layoutInfo.fillInfoWithAppItem(appItem);

      expect(layoutInfo.appName).assertEqual(appName);
      expect(layoutInfo.appIconId).assertEqual(appIconId);
      expect(layoutInfo.bundleName).assertEqual( bundleName);
      expect(layoutInfo.abilityName).assertEqual( abilityName);
      expect(layoutInfo.moduleName).assertEqual( moduleName);
      expect(layoutInfo.typeId).assertEqual( typeId);
      expect(layoutInfo.area).assertEqual( area);
      expect(layoutInfo.page ).assertEqual( page);
      expect(layoutInfo.column ).assertEqual( column);
      expect(layoutInfo.kindId ).assertEqual( kindId);

      expect(layoutInfo.bundleType ).assertEqual( bundleType);
      expect(layoutInfo.applicationName ).assertEqual( applicationName);
      expect(layoutInfo.downloadProgress ).assertEqual( downloadProgress);
      expect(layoutInfo.appStatus ).assertEqual( appStatus);
      expect(layoutInfo.iconResource ).assertEqual( iconResource);
      expect(layoutInfo.callerName ).assertEqual( callerName);
    });

  })
}