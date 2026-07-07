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
} from '@ohos/hypium';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import {
  FormLayoutCacheManager,
  GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { LauncherCardInfo } from '../../../../../../../main/ets/default/bean/LauncherCardInfo';
import { CommandConsumer } from '../../../../../../../main/ets/default/command/CommandConsumer';
import { CreateFormStackCommand } from '../../../../../../../main/ets/default/command/imp/CreateFormStackCommand';
import { AbilityFormUtil } from '../../../../../../../main/ets/default/utils/AbilityFormUtil';

class BaseCardInfo {
  recId: string = '1';
  subRecId: number = 1;
  optType: number = 1;
  stackId: string = '3';
  operateFormId: string = '';
  portrait: LauncherDisplayCardInfo = {
    recItems: [],
    rowsTemplate: '',
    columnsTemplate: '',
    sceneSpanX: 1,
    sceneSpanY: 1,
    row: 1,
    column: 1,
    patternId: '',
    headerHeight: 0,
    columnGap: 0,
    rowGap: 0,
    gridPadding: 0
  };
  landscapeOrExpand: LauncherDisplayCardInfo = {
    recItems: [],
    rowsTemplate: '',
    columnsTemplate: '',
    sceneSpanX: 1,
    sceneSpanY: 1,
    row: 1,
    column: 1,
    patternId: '',
    headerHeight: 0,
    columnGap: 0,
    rowGap: 0,
    gridPadding: 0
  };

  featureVersion: number = 1;
};

export default function CreateFormStackCommandTest() {
  describe('CreateFormStackCommandTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('CreateFormStackCommandTest_canExecute_01', 0, (): void => {
      let commandObj: CreateFormStackCommand = new CreateFormStackCommand('123');
      let results: boolean = (commandObj as object)['canExecute'](undefined);
      expect(results).assertEqual(false);
    });

    it('CreateFormStackCommandTest_canExecute_02', 0, (): void => {
      let mocker: MockKit = new MockKit();
      const endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      endLayoutInfo.cardId = '329379';
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getCardBelongFormStack);
      when(func1)('329379').afterReturn(true);

      let commandObj: CreateFormStackCommand = new CreateFormStackCommand('123');
      let results: boolean = (commandObj as object)['canExecute'](endLayoutInfo);
      expect(results).assertEqual(false);
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('CreateFormStackCommandTest_canExecute_03', 0, (): void => {
      let mocker: MockKit = new MockKit();
      const endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      endLayoutInfo.cardId = '329379';
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getCardBelongFormStack);
      when(func1)('329379').afterReturn(false);

      let commandObj: CreateFormStackCommand = new CreateFormStackCommand('123');
      let results: boolean = (commandObj as object)['canExecute'](endLayoutInfo);
      expect(results).assertEqual(true);
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('CreateFormStackCommandTest_execute_01', 0, (): void => {
      const commandId = '123';
      let commandObj: CreateFormStackCommand = new CreateFormStackCommand(commandId);
      const lists: (LauncherCardInfo | undefined)[] = [];
      lists.push(undefined);
      commandObj.data = lists;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: CommandConsumer = CommandConsumer.getInstance();
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(manager, manager.finishCommand);
      when(func)(commandId).afterAction(action);

      commandObj.execute();
      expect(called).assertTrue();
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('CreateFormStackCommandTest_execute_02', 0, (): void => {
      const commandId = '123';
      let commandObj: CreateFormStackCommand = new CreateFormStackCommand(commandId);
      const lists: BaseCardInfo[] = [];
      const items: BaseCardInfo = new BaseCardInfo();
      items.operateFormId = '454';
      lists.push(items);
      commandObj.data = lists;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: CommandConsumer = CommandConsumer.getInstance();
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(manager, manager.finishCommand);
      let func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getAiSuggestionItemByCardId);
      when(func)(commandId).afterAction(action);
      when(func1)(items.operateFormId).afterReturn(undefined);

      commandObj.execute();
      expect(called).assertTrue();
      mocker.clear(manager);
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('CreateFormStackCommandTest_execute_03', 0, (): void => {
      const commandId = '123';
      let commandObj: CreateFormStackCommand = new CreateFormStackCommand(commandId);
      const lists: BaseCardInfo[] = [];
      const items: BaseCardInfo = new BaseCardInfo();
      items.operateFormId = '454';
      lists.push(items);
      commandObj.data = lists;
      const endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      endLayoutInfo.cardId = '329379';
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: CommandConsumer = CommandConsumer.getInstance();
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(manager, manager.finishCommand);
      let func1: Function = mocker.mockFunc(FormLayoutCacheManager.getInstance(),
        FormLayoutCacheManager.getInstance().selectGridLayoutItemByCardId);
      let func2: Function = mocker.mockFunc(commandObj, (commandObj as object)['canExecute']);
      when(func)(commandId).afterAction(action);
      when(func1)(items.operateFormId).afterReturn(endLayoutInfo);
      when(func2)(endLayoutInfo).afterReturn(true);

      commandObj.execute();
      expect(called).assertFalse();
      mocker.clear(manager);
      mocker.clear(commandObj);
      mocker.clear(FormLayoutCacheManager.getInstance());
      mocker.clearAll();
    });

  });
}