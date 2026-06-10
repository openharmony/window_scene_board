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
} from '@ohos/hypium';
import { CheckEmptyUtils, FileUtils } from '@ohos/basicutils';
import { ThemeActiveManager } from '../../../../main/ets/default/utils/ThemeActiveManager';
import IconEditPageConstants from '../../../../main/ets/default/common/constants/IconEditPageConstants';
import { EditModeConstants, ManifestData } from '../../../../main/ets/default/common/constants/EditModeConstants';

export function ThemeActiveManagerTest() {
  describe('ThemeActiveManagerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getCurrentIconId', 0, () => {
      const themeActiveManager = new ThemeActiveManager();
      let mocker1: MockKit = new MockKit();
      let mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunc1)(EditModeConstants.ACTIVATED_PATH_A + EditModeConstants.ACTIVATED_FLAG).afterReturn(false);
      when(mockFunc1)(EditModeConstants.ACTIVATED_PATH_B + EditModeConstants.ACTIVATED_FLAG).afterReturn(false);
      expect(themeActiveManager.getCurrentIconId([])).assertEqual(IconEditPageConstants.PREVIEW_PATH_DEFAULT);

      expect(themeActiveManager.getCurrentIconId([IconEditPageConstants.PREVIEW_PATH_DEFAULT]))
        .assertEqual(IconEditPageConstants.PREVIEW_PATH_DEFAULT);

      when(mockFunc1)(EditModeConstants.ACTIVATED_PATH_A + EditModeConstants.ACTIVATED_FLAG).afterReturn(true);
      when(mockFunc1)(EditModeConstants.ACTIVATED_PATH_A + EditModeConstants.ACTIVATED_CONFIG).afterReturn(false);
      expect(themeActiveManager.getCurrentIconId([])).assertEqual(IconEditPageConstants.PREVIEW_PATH_DEFAULT);
      expect(themeActiveManager.getCurrentIconId([IconEditPageConstants.PREVIEW_PATH_DEFAULT]))
        .assertEqual(IconEditPageConstants.PREVIEW_PATH_DEFAULT);
    })

     it('test_getCurrentIconId_01', 0, () => {
      const themeActiveManager = new ThemeActiveManager();
      let mocker1: MockKit = new MockKit();
      let mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunc1)(EditModeConstants.ACTIVATED_PATH_A + EditModeConstants.ACTIVATED_FLAG).afterReturn(false);
      when(mockFunc1)(EditModeConstants.ACTIVATED_PATH_B + EditModeConstants.ACTIVATED_FLAG).afterReturn(true);
      when(mockFunc1)(EditModeConstants.ACTIVATED_PATH_B + EditModeConstants.ACTIVATED_CONFIG).afterReturn(false);
      expect(themeActiveManager.getCurrentIconId([])).assertEqual(IconEditPageConstants.PREVIEW_PATH_DEFAULT);
    })

    it('test_getCurrentIconId_02', 0, async () => {
      const themeActiveManager = new ThemeActiveManager();
      let mocker1: MockKit = new MockKit();
      let mockFunc1: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunc1)(EditModeConstants.ACTIVATED_PATH_A + EditModeConstants.ACTIVATED_FLAG).afterReturn(false);
      when(mockFunc1)(EditModeConstants.ACTIVATED_PATH_B + EditModeConstants.ACTIVATED_FLAG).afterReturn(true);
      when(mockFunc1)(EditModeConstants.ACTIVATED_PATH_B + EditModeConstants.ACTIVATED_CONFIG).afterReturn(true);
      let mocker2: MockKit = new MockKit();
      let mockFunc2: Function = mocker2.mockFunc(FileUtils, FileUtils.readTextSync);
      when(mockFunc2)(EditModeConstants.ACTIVATED_PATH_B + EditModeConstants.ACTIVATED_CONFIG)
        .afterReturn('{"id":"","preview":""}');
      expect(themeActiveManager.getCurrentIconId([])).assertEqual(IconEditPageConstants.PREVIEW_PATH_DEFAULT);

      when(mockFunc2)(EditModeConstants.ACTIVATED_PATH_B + EditModeConstants.ACTIVATED_CONFIG)
        .afterReturn('{"id":"1","preview":""}');
      when(mockFunc2)('icon/manifest.json').afterReturn('{"id":"1","preview":""}');
      expect(themeActiveManager.getCurrentIconId(['icon'])).assertEqual('icon');

      when(mockFunc2)('icon/manifest.json').afterReturn('{"id":"2","preview":""}');
      expect(themeActiveManager.getCurrentIconId(['icon'])).assertEqual('icon');
      expect(themeActiveManager.getCurrentIconId([])).assertEqual(IconEditPageConstants.PREVIEW_PATH_DEFAULT);
      mocker1.clear(FileUtils);
      mocker1.clearAll();
      mocker2.clear(FileUtils);
      mocker2.clearAll();
    })

    it('test_readAllThemeResourceSync', 0, () => {
      const themeActiveManager = new ThemeActiveManager();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FileUtils, FileUtils.getFileList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(['Icon', 'aaa']);
      expect((themeActiveManager.readAllIconResourceSync()).length).assertEqual(1);
      mocker.clear(FileUtils);
      mocker.clearAll();
    })

    it('test_readAllThemeResource', 0, async () => {
      const themeActiveManager = new ThemeActiveManager();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FileUtils, FileUtils.getFileList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(['Icon', 'aaa']);
      expect((await themeActiveManager.readAllIconResource()).length).assertEqual(1);
      mocker.clear(FileUtils);
      mocker.clearAll();
    })

    it('test_getCurrentIconId_03', 0, () => {
      const themeActiveManager = new ThemeActiveManager();
      let mocker1: MockKit = new MockKit();
      let mockFunc1: Function =
        mocker1.mockFunc(themeActiveManager, (themeActiveManager as object)['getActivatedThemePath']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(['']);
      let mockFunc2: Function = mocker1.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      themeActiveManager.getCurrentIconId(['getCurrentIconId'])
      expect((themeActiveManager as object)['getIconPath'](['getCurrentIconId']) !== null).assertTrue()
      mocker1.ignoreMock(themeActiveManager, (themeActiveManager as object)['getActivatedThemePath']);
      mocker1.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mocker1.clearAll();
    })

    it('test_getCurrentIconId_04', 0, () => {
      const themeActiveManager = new ThemeActiveManager();
      let mocker1: MockKit = new MockKit();
      let mockFunc1: Function =
        mocker1.mockFunc(themeActiveManager, (themeActiveManager as object)['getActivatedThemePath']);
      let a = when(mockFunc1)(ArgumentMatchers.any).afterReturn(['']);
      let configPath = a + EditModeConstants.ACTIVATED_CONFIG;
      let mockFunc2: Function = mocker1.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunc2)(configPath).afterReturn(false);
      themeActiveManager.getCurrentIconId([''])
      expect((themeActiveManager as object)['getIconPath'](['']) !== null).assertTrue()
      mocker1.ignoreMock(themeActiveManager, (themeActiveManager as object)['getActivatedThemePath']);
      mocker1.ignoreMock(FileUtils, FileUtils.isExist);
      mocker1.clearAll();
    })

    it('test_getCurrentIconId_05', 0, () => {
      const themeActiveManager = new ThemeActiveManager();
      let description: ManifestData = {
        id: 'string',
        preview: 'string'
      }
      let activeIconId: string = description.id;
      let mocker1: MockKit = new MockKit();
      let mockFunc1: Function = mocker1.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc1)(activeIconId).afterReturn(true);
      themeActiveManager.getCurrentIconId([''])
      expect((themeActiveManager as object)['getIconPath'](['']) !== null).assertTrue()
      mocker1.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mocker1.clearAll();
    })

    it('test_getCurrentIconId_06', 0, () => {
      const themeActiveManager = new ThemeActiveManager();
      let mocker1: MockKit = new MockKit();
      let mockFunc1: Function =
        mocker1.mockFunc(themeActiveManager, (themeActiveManager as object)['parseManifest']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn({
        id: 'string',
        preview: 'string'
      });
      let iconPaths = ['abc']
      themeActiveManager.getCurrentIconId(iconPaths)
      expect(iconPaths !== null).assertTrue()
      mocker1.ignoreMock(themeActiveManager, (themeActiveManager as object)['parseManifest']);
      mocker1.clearAll();
    })

    it('test_getCurrentIconId_07', 0, () => {
      const themeActiveManager = new ThemeActiveManager();
      themeActiveManager.getCurrentIconId([''])
      expect((themeActiveManager as object)['getIconPath'](['']) !== null).assertTrue()
    })

    it('test_getActivatedThemePath_01', 0, () => {
      const themeActiveManager = new ThemeActiveManager();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunc)(EditModeConstants.ACTIVATED_PATH_A + EditModeConstants.ACTIVATED_FLAG).afterReturn(true);
      let res: string = (themeActiveManager as object)['getActivatedThemePath']()
      expect(res).assertEqual('/data/themes/a/')
      mocker.ignoreMock(FileUtils, FileUtils.isExist);
      mocker.clearAll();
    })

    it('test_getActivatedThemePath_02', 0, () => {
      const themeActiveManager = new ThemeActiveManager();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunc)(EditModeConstants.ACTIVATED_PATH_B + EditModeConstants.ACTIVATED_FLAG).afterReturn(true);
      let res: string = (themeActiveManager as object)['getActivatedThemePath']()
      expect(res).assertEqual('/data/themes/b/')
      mocker.ignoreMock(FileUtils, FileUtils.isExist);
      mocker.clearAll();
    })

    it('test_getActivatedThemePath_03', 0, () => {
      const themeActiveManager = new ThemeActiveManager();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let res: string = (themeActiveManager as object)['getActivatedThemePath']()
      expect(res).assertEqual('')
      mocker.ignoreMock(FileUtils, FileUtils.isExist);
      mocker.clearAll();
    })
  })
}