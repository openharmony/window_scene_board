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
import { SingleContext } from '@ohos/basicutils';
import { MenuInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import display from '@ohos.display';
import {
  KeyEventConstants,
  keyEventManager,
  EventConstants
} from '@ohos/launchercommon';
import fileFolderManagerFactory from '@ohos/desktopfilefolder/src/main/ets/default/manager/FileFolderManagerFactory';
import FileFolderManager from '@ohos/desktopfilefolder/src/main/ets/default/manager/FileFolderManager';
import {
  DeviceHelper,
  SystemParamUtils
} from '@ohos/frameworkwrapper';
import PcRightMenuViewModel from '../../../../../../main/ets/common/viewmodel/PcRightMenuViewModel';
import PcFileFolderManager from '../../../../../../main/ets/common/controller/PcFileFolderManager';
import { DragGridPosition } from '@ohos/componentdrag';
import { DesktopSortRule, DesktopSortInfo } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';


export default function PcRightMenuViewModelTest() {
  describe('PcRightMenuViewModelTest', () => {
    let mocker: MockKit;
    let pcFileFolderManager: FileFolderManager;
    let vm: PcRightMenuViewModel;
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
      mocker = new MockKit();
      fileFolderManagerFactory.setFileFolderManager(PcFileFolderManager.getInstance());
      pcFileFolderManager = fileFolderManagerFactory.getFileFolderManager();
      vm = new PcRightMenuViewModel();
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

    it('getRightMenuInfoListTest', 0, () => {
      let mockFuncCanUndo: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.canUndo);
      let mockFuncCanRedo: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.canRedo);
      let mockFuncIsHddProduct: Function = mocker.mockFunc(SystemParamUtils, SystemParamUtils.isHddProduct);
      let mockFuncIsEmulator: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isEmulator);

      (vm as object)['screenId'] = 1;
      when(mockFuncIsHddProduct)().afterReturn(false);
      when(mockFuncIsEmulator)().afterReturn(false);
      vm.getRightMenuInfoList();

      (vm as object)['screenId'] = 0;
      when(mockFuncIsHddProduct)().afterReturn(false);
      when(mockFuncIsEmulator)().afterReturn(false);
      when(mockFuncCanUndo)().afterReturn(true);
      when(mockFuncCanRedo)().afterReturn(true);
      vm.getRightMenuInfoList();

      when(mockFuncIsEmulator)().afterReturn(true);
      when(mockFuncCanUndo)().afterReturn(false);
      when(mockFuncCanRedo)().afterReturn(false);
      vm.getRightMenuInfoList();

      expect(vm instanceof PcRightMenuViewModel).assertTrue();
    })

    it('getMenuWidthAdaptiveTest', 0, () => {
      let menuItem: MenuInfo = new MenuInfo();
      menuItem.menuKeyString = 'KEY_UNDO';
      vm.getMenuWidthAdaptive(menuItem);

      menuItem.menuKeyString = 'KEY_REDO';
      vm.getMenuWidthAdaptive(menuItem);

      menuItem.menuKeyString = 'KEY_CREATE_FILE';
      vm.getMenuWidthAdaptive(menuItem);

      menuItem.menuKeyString = 'KEY_COLLABORATION';
      vm.getMenuWidthAdaptive(menuItem);

      menuItem.menuKeyString = 'test';
      vm.getMenuWidthAdaptive(menuItem);

      expect(vm instanceof PcRightMenuViewModel).assertTrue();
    })

    it('keyEventTest', 0, () => {
      vm.registerKeyEvent();
      let mockFuncCanUndo: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.canUndo);
      let mockFuncCanRedo: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.canRedo);
      when(mockFuncCanUndo)().afterReturn(true);
      when(mockFuncCanRedo)().afterReturn(true);
      keyEventManager.sendKeyEvent(KeyEventConstants.EVENT_U);
      keyEventManager.sendKeyEvent(KeyEventConstants.EVENT_R);

      when(mockFuncCanUndo)().afterReturn(false);
      when(mockFuncCanRedo)().afterReturn(false);
      keyEventManager.sendKeyEvent(KeyEventConstants.EVENT_U);
      keyEventManager.sendKeyEvent(KeyEventConstants.EVENT_R);
      vm.unRegisterKeyEvent();
      expect(vm instanceof PcRightMenuViewModel).assertTrue();
    })

    it('checkIfPasteNeededTest', 0, () => {
      (vm as object)['checkIfPasteNeeded']();
      expect(vm instanceof PcRightMenuViewModel).assertTrue();
    })

    it('getRedoMenuTest', 0, () => {
      let menu: MenuInfo = (vm as object)['getRedoMenu']();
      if (menu.onMenuClick) {
        menu.onMenuClick();
      }
      expect(vm instanceof PcRightMenuViewModel).assertTrue();
    })

    it('getNewFileMenuTest', 0, () => {
      (vm as object)['isClicked'] = true;
      let menu: MenuInfo = (vm as object)['getNewFileMenu']();
      let createSubFolderMenu: MenuInfo = menu.subMenuList[menu.subMenuList.length - 1];
      if (createSubFolderMenu.onMenuClick) {
        createSubFolderMenu.onMenuClick();
      }

      (vm as object)['isClicked'] = false;
      let mockFuncGetFileFolderPosition: Function = mocker.mockFunc(pcFileFolderManager, pcFileFolderManager.getFileFolderPosition);
      when(mockFuncGetFileFolderPosition)(ArgumentMatchers.any).afterReturnNothing();
      if (createSubFolderMenu.onMenuClick) {
        createSubFolderMenu.onMenuClick();
      }

      let filePosition: DragGridPosition = { row: 1, column: 1, page: 0 };
      when(mockFuncGetFileFolderPosition)(ArgumentMatchers.any).afterReturn(filePosition);
      if (createSubFolderMenu.onMenuClick) {
        createSubFolderMenu.onMenuClick();
      }
      mocker.clear(pcFileFolderManager);
      expect(vm instanceof PcRightMenuViewModel).assertTrue();
    })

    it('getSortSubMenuTest', 0, () => {
      let menu: MenuInfo = (vm as object)['getSortSubMenu'](DesktopSortRule.SORT_NONE);
      (vm as object)['desktopSortRule'] = DesktopSortRule.SORT_NONE;
      if (menu.onMenuClick) {
        menu.onMenuClick();
      }

      (vm as object)['desktopSortRule'] = DesktopSortRule.SORT_BY_NAME;
      if (menu.onMenuClick) {
        menu.onMenuClick();
      }
      expect(vm instanceof PcRightMenuViewModel).assertTrue();
    })

  })
}