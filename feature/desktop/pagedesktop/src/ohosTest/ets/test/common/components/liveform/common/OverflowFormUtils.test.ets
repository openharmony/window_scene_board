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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  TestType,
  Level,
  expect,
  describe,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium'
import { AppStatus, CommonConstants, GridLayoutItemInfo } from '@ohos/launchercommon';
import { GameCardInfo } from '@ohos/launchercommon/src/main/ets/bean/GameCardInfo';
import OverflowFormUtils
  from '../../../../../../../main/ets/default/common/components/liveform/common/OverflowFormUtils';

function createGameCardInfo(): GameCardInfo {
  let gameCardInfo: GameCardInfo = new GameCardInfo();
  gameCardInfo.gameType = 'quick';
  gameCardInfo.formBindGame = 'game';
  return gameCardInfo;
}

function createGameCardInfo1(): GameCardInfo {
  let gameCardInfo: GameCardInfo = new GameCardInfo();
  gameCardInfo.gameType = 'quick';
  gameCardInfo.formBindGame = 'game';
  gameCardInfo.disabledDesktopBehaviors = '';
  return gameCardInfo;
}

function createGameCardInfo2(): GameCardInfo {
  let gameCardInfo: GameCardInfo = new GameCardInfo();
  gameCardInfo.gameType = 'quick';
  gameCardInfo.formBindGame = 'game';
  gameCardInfo.disabledDesktopBehaviors = 'clear';
  return gameCardInfo;
}

function createGameCardInfo3(): GameCardInfo {
  let gameCardInfo: GameCardInfo = new GameCardInfo();
  gameCardInfo.gameType = 'quick';
  gameCardInfo.formBindGame = 'game';
  gameCardInfo.disabledDesktopBehaviors = 'clear | clean';
  return gameCardInfo;
}

function createGameCardInfo4(): GameCardInfo {
  let gameCardInfo: GameCardInfo = new GameCardInfo();
  gameCardInfo.gameType = 'quick';
  gameCardInfo.formBindGame = 'game';
  gameCardInfo.disabledDesktopBehaviors = 'PULL_DOWN_SEARCH | LONG_CLICK';
  return gameCardInfo;
}

function createGameCardInfo401(): GameCardInfo {
  let gameCardInfo: GameCardInfo = new GameCardInfo();
  gameCardInfo.gameType = 'quick';
  gameCardInfo.formBindGame = 'game';
  gameCardInfo.disabledDesktopBehaviors = 'PULL_DOWN_SEARCH';
  return gameCardInfo;
}

function createGameCardInfo402(): GameCardInfo {
  let gameCardInfo: GameCardInfo = new GameCardInfo();
  gameCardInfo.gameType = 'quick';
  gameCardInfo.formBindGame = 'game';
  gameCardInfo.disabledDesktopBehaviors = 'LONG_CLICK | SWIPE_DESKTOP';
  return gameCardInfo;
}

function createGameCardInfo5(): GameCardInfo {
  let gameCardInfo: GameCardInfo = new GameCardInfo();
  gameCardInfo.formBindGame = 'game';
  gameCardInfo.extensionType = 'funInteraction';
  return gameCardInfo;
}

function createGameCardInfo6(): GameCardInfo {
  let gameCardInfo: GameCardInfo = new GameCardInfo();
  gameCardInfo.formBindGame = 'game';
  gameCardInfo.extensionType = 'sceneAnimation';
  gameCardInfo.disabledDesktopBehaviors = 'PULL_DOWN_SEARCH';
  return gameCardInfo;
}

function createGameCardInfo7(): GameCardInfo {
  let gameCardInfo: GameCardInfo = new GameCardInfo();
  gameCardInfo.formBindGame = 'game';
  gameCardInfo.extensionType = 'sceneAnimation';
  gameCardInfo.disabledDesktopBehaviors = 'LONG_CLICK';
  return gameCardInfo;
}

function createGridLayoutItemInfo01(): GridLayoutItemInfo {
  let info: GridLayoutItemInfo = new GridLayoutItemInfo();
  info.bundleName = 'com.ohos.vassistant.launcher';
  info.abilityName = 'openharmony';
  info.moduleName = 'com';
  info.keyName = 'com';
  info.row = 1;
  info.column = 0;
  info.appStatus = AppStatus.WAIT_FOR_HARMONY;
  info.folderId = '996';
  info.formStackId = '996';
  info.typeId = CommonConstants.TYPE_APP;
  info.area = [2, 1];
  info.gameCardInfo = undefined;
  return info;
}

function createGridLayoutItemInfo02(): GridLayoutItemInfo {
  let info: GridLayoutItemInfo = new GridLayoutItemInfo();
  info.row = 1;
  info.column = 0;
  info.appStatus = AppStatus.WAIT_FOR_HARMONY;
  info.folderId = '996';
  info.formStackId = '996';
  info.typeId = CommonConstants.TYPE_APP;
  info.area = [2, 1];
  info.gameCardInfo = createGameCardInfo401();
  return info;
}

function createGridLayoutItemInfo03(): GridLayoutItemInfo {
  let info: GridLayoutItemInfo = new GridLayoutItemInfo();
  info.row = 1;
  info.column = 0;
  info.appStatus = AppStatus.WAIT_FOR_HARMONY;
  info.folderId = '996';
  info.formStackId = '996';
  info.typeId = CommonConstants.TYPE_APP;
  info.area = [2, 1];
  info.gameCardInfo = createGameCardInfo5();
  return info;
}

function createGridLayoutItemInfo04(): GridLayoutItemInfo {
  let info: GridLayoutItemInfo = new GridLayoutItemInfo();
  info.row = 1;
  info.column = 0;
  info.appStatus = AppStatus.WAIT_FOR_HARMONY;
  info.folderId = '996';
  info.formStackId = '996';
  info.typeId = CommonConstants.TYPE_APP;
  info.area = [2, 1];
  info.gameCardInfo = createGameCardInfo6();
  return info;
}

function createGridLayoutItemInfo05(): GridLayoutItemInfo {
  let info: GridLayoutItemInfo = new GridLayoutItemInfo();
  info.row = 1;
  info.column = 0;
  info.appStatus = AppStatus.WAIT_FOR_HARMONY;
  info.folderId = '996';
  info.formStackId = '996';
  info.typeId = CommonConstants.TYPE_APP;
  info.area = [2, 1];
  info.gameCardInfo = createGameCardInfo7();
  return info;
}

let gesture_swipe: string = 'SWIPE_DESKTOP';
let gesture_pull: string = 'PULL_DOWN_SEARCH';
let gesture_long: string = 'LONG_CLICK';
let gesture_drag: string = 'DRAG';
let gesture_clean: string = 'CLEAN';
let gesture_some: string = 'LONG_CLICK | SWIPE_DESKTOP';

export function OverflowFormUtilsTest() {
  describe('OverflowFormUtilsTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_isSystemApp', TestType.FUNCTION | Level.LEVEL0, () => {
      let bundleName: string = 'com.ohos.litegamelauncher';
      const result = OverflowFormUtils.isSystemApp(bundleName);
      expect(result).assertEqual(true);
    });

    it('test_isSystemApp_01', TestType.FUNCTION | Level.LEVEL0, () => {
      let bundleName: string = 'com.openharmony.ohos.clear';
      const result = OverflowFormUtils.isSystemApp(bundleName);
      expect(result).assertEqual(false);
    });

    it('test_isBehaviorDisabled_activeForm_undefined', TestType.FUNCTION | Level.LEVEL0, () => {
      let controller: boolean =
        OverflowFormUtils.isBehaviorDisabled(gesture_swipe, undefined);
      expect(controller).assertFalse();
    })

    it('test_isBehaviorDisabled_gameCardInfo_undefined', TestType.FUNCTION | Level.LEVEL0, () => {
      let itemFormItem: GridLayoutItemInfo = createGridLayoutItemInfo01();
      let controller: boolean =
        OverflowFormUtils.isBehaviorDisabled(gesture_swipe, itemFormItem);
      expect(controller).assertFalse();
    })

    it('test_isBehaviorDisabled_gameType_quick', TestType.FUNCTION | Level.LEVEL0, () => {
      let itemFormItem: GridLayoutItemInfo = createGridLayoutItemInfo02();
      let controller: boolean = OverflowFormUtils.isBehaviorDisabled(gesture_pull, itemFormItem);
      expect(controller).assertTrue();
    })

    it('test_isBehaviorDisabled_isFunInteraction_true', TestType.FUNCTION | Level.LEVEL0, () => {
      let itemFormItem: GridLayoutItemInfo = createGridLayoutItemInfo03();
      let controller: boolean = OverflowFormUtils.isBehaviorDisabled(gesture_swipe, itemFormItem);
      expect(controller).assertTrue();
    })

    it('test_isBehaviorDisabled_isAnimationType', TestType.FUNCTION | Level.LEVEL0, () => {
      let itemFormItem: GridLayoutItemInfo = createGridLayoutItemInfo04();
      const mocker: MockKit = new MockKit();
      let mockFunc2: Function = mocker.mockFunc(OverflowFormUtils, OverflowFormUtils.isSystemApp);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      let controller: boolean = OverflowFormUtils.isBehaviorDisabled(gesture_pull, itemFormItem);
      expect(controller).assertTrue();
      mocker.clearAll();
    })

    it('test_isBehaviorDisabled_extensionType_disabledDesktopBehaviors_mismatch', TestType.FUNCTION | Level.LEVEL0,
      () => {
        let itemFormItem: GridLayoutItemInfo = createGridLayoutItemInfo05();
        const mocker: MockKit = new MockKit();
        let mockFunc2: Function = mocker.mockFunc(OverflowFormUtils, OverflowFormUtils.isSystemApp);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
        let controller: boolean = OverflowFormUtils.isBehaviorDisabled(gesture_pull, itemFormItem);
        expect(controller).assertFalse();
        mocker.clearAll();
      })

    it('test_isBehaviorDisabled_isSystemApp_false', TestType.FUNCTION | Level.LEVEL0, () => {
      let itemFormItem: GridLayoutItemInfo = createGridLayoutItemInfo04();
      const mocker: MockKit = new MockKit();
      let mockFunc2: Function = mocker.mockFunc(OverflowFormUtils, OverflowFormUtils.isSystemApp);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      let controller: boolean = OverflowFormUtils.isBehaviorDisabled(gesture_pull, itemFormItem);
      expect(controller).assertFalse();
      mocker.clearAll();
    })

    it('test_isBehaviorDisabled_hasBehaviorDisabled_mismatch', TestType.FUNCTION | Level.LEVEL0, () => {
      let itemFormItem: GridLayoutItemInfo = createGridLayoutItemInfo04();
      const mocker: MockKit = new MockKit();
      let mockFunc2: Function = mocker.mockFunc(OverflowFormUtils, OverflowFormUtils.isSystemApp);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      let controller: boolean = OverflowFormUtils.isBehaviorDisabled(gesture_swipe, itemFormItem);
      expect(controller).assertFalse();
      mocker.clearAll();
    })
  })
}