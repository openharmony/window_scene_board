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
  GridLayoutItemInfo,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { LauncherCardInfo } from '../../../../../../../main/ets/default/bean/LauncherCardInfo';
import { CommandConsumer } from '../../../../../../../main/ets/default/command/CommandConsumer';
import { UpdateFormsCommand } from '../../../../../../../main/ets/default/command/imp/UpdateFormsCommand';
import { AiSuggestionFormManager } from '../../../../../../../main/ets/default/manager/AiSuggestionFormManager';
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
  cardUniqueTag: string = '';
};

export default function UpdateFormsCommandTest() {
  describe('UpdateFormsCommandTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('UpdateFormsCommandTest_execute_01', 0, (): void => {
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand('123');
      commandObj.data = undefined;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: CommandConsumer = CommandConsumer.getInstance();
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(manager, manager.finishCommand);
      when(func)('123').afterAction(action);

      commandObj.execute();
      expect(called).assertTrue();
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('UpdateFormsCommandTest_execute_02', 0, (): void => {
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand('123');
      let item: LauncherCardInfo = new LauncherCardInfo();
      item.stackId = '3232';
      commandObj.data = item;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(LauncherCardInfo, LauncherCardInfo.isCardInfoInValid);
      const func2: Function = mocker.mockFunc(manager, manager.updateCardInfo);
      when(func1)().afterReturn(true);
      when(func2)('123').afterAction(action);

      commandObj.execute();
      expect(called).assertFalse();
      mocker.clear(LauncherCardInfo);
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('UpdateFormsCommandTest_canExecute_01', 0, (): void => {
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand('123');
      let results: boolean = (commandObj as object)['canExecute']?.(undefined);
      expect(results).assertUndefined();
    });

    it('UpdateFormsCommandTest_canExecute_02', 0, (): void => {
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand('123');
      let newCardInfo: BaseCardInfo = new BaseCardInfo();

      let results: boolean = (commandObj as object)['canExecute']?.(newCardInfo);
      expect(results).assertUndefined();
    });

    it('UpdateFormsCommandTest_canExecute_03', 0, (): void => {
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand('123');
      let newCardInfo: BaseCardInfo = new BaseCardInfo();
      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getFormStackInfoByFormStackId);
      when(func1)('329379').afterReturn([]);

      let results: boolean = (commandObj as object)['canExecute']?.(newCardInfo);
      expect(results).assertUndefined();
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('UpdateFormsCommandTest_execute_03', 0, (): void => {
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand('123');
      let item: LauncherCardInfo = new LauncherCardInfo();
      item.stackId = '3232';
      item.operateFormId = '12345';
      commandObj.data = item;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(LauncherCardInfo, LauncherCardInfo.isCardInfoInValid);
      const func2: Function = mocker.mockFunc(manager, manager.updateCardInfo);
      const func3: Function = mocker.mockFunc(commandObj, (commandObj as object)['canExecute']);
      when(func1)(item.portrait).afterReturn(false);
      when(func3)(item).afterReturn(true);
      when(func2)(item.operateFormId).afterAction(action);

      commandObj.execute();
      expect(called).assertTrue();
      mocker.clear(LauncherCardInfo);
      mocker.clear(commandObj);
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('UpdateFormsCommandTest_execute_04', 0, (): void => {
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand('123');
      let item: LauncherCardInfo = new LauncherCardInfo();
      item.stackId = '3232';
      commandObj.data = item;
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let manager: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      let mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(manager, manager.updateCardInfo);
      when(func)(item.operateFormId).afterAction(action);

      commandObj.execute();
      expect(called).assertFalse();
      mocker.clear(LauncherCardInfo);
      mocker.clear(manager);
      mocker.clear(commandObj);
      mocker.clearAll();
    });

    it('UpdateFormsCommandTest_canExecute_04', 0, (): void => {
      const commandId = '123';
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand(commandId);
      let instance: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      let newCardInfo: BaseCardInfo = new BaseCardInfo();
      const cardList: GridLayoutItemInfo[] = [];
      const items: GridLayoutItemInfo = new GridLayoutItemInfo();
      items.cardId = '123';
      cardList.push(items);

      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getFormStackInfoByFormStackId);
      const func2: Function = mocker.mockFunc(instance, instance.getCardInfo);
      when(func1)(commandId).afterReturn(cardList);
      when(func2)(items.cardId).afterReturn(undefined);

      let results: boolean = (commandObj as object)['canExecute']?.(newCardInfo);
      expect(results).assertUndefined();
      mocker.clear(AbilityFormUtil);
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('UpdateFormsCommandTest_canExecute_05', 0, (): void => {
      const commandId = '123';
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand(commandId);
      let instance: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      let newCardInfo: BaseCardInfo = new BaseCardInfo();
      let oldCardInfo: BaseCardInfo = new BaseCardInfo();

      const cardList: GridLayoutItemInfo[] = [];
      const items: GridLayoutItemInfo = new GridLayoutItemInfo();
      items.cardId = '123';
      cardList.push(items);

      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getFormStackInfoByFormStackId);
      const func2: Function = mocker.mockFunc(instance, instance.getCardInfo);
      when(func1)(commandId).afterReturn(cardList);
      when(func2)(items.cardId).afterReturn(oldCardInfo);

      let results: boolean = (commandObj as object)['canExecute']?.(newCardInfo);
      expect(results).assertUndefined();
      mocker.clear(AbilityFormUtil);
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('UpdateFormsCommandTest_canExecute_06', 0, (): void => {
      const commandId = '123';
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand(commandId);
      let instance: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      let newCardInfo: BaseCardInfo = new BaseCardInfo();
      let oldCardInfo: BaseCardInfo = new BaseCardInfo();

      const cardList: GridLayoutItemInfo[] = [];
      const items: GridLayoutItemInfo = new GridLayoutItemInfo();
      items.cardId = '123';
      cardList.push(items);

      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getFormStackInfoByFormStackId);
      const func2: Function = mocker.mockFunc(instance, instance.getCardInfo);
      when(func1)(commandId).afterReturn(cardList);
      when(func2)(items.cardId).afterReturn(oldCardInfo);

      let results: boolean = (commandObj as object)['canExecute']?.(newCardInfo);
      expect(results).assertUndefined();
      mocker.clear(AbilityFormUtil);
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('UpdateFormsCommandTest_canExecute_07', 0, (): void => {
      const commandId = '123';
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand(commandId);
      let instance: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      let newCardInfo: BaseCardInfo = new BaseCardInfo();
      let oldCardInfo: BaseCardInfo = new BaseCardInfo();

      const cardList: GridLayoutItemInfo[] = [];
      const items: GridLayoutItemInfo = new GridLayoutItemInfo();
      items.cardId = '123';
      cardList.push(items);

      newCardInfo.operateFormId = '123';
      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getFormStackInfoByFormStackId);
      const func2: Function = mocker.mockFunc(instance, instance.getCardInfo);
      when(func1)(commandId).afterReturn(cardList);
      when(func2)(items.cardId).afterReturn(oldCardInfo);

      let results: boolean = (commandObj as object)['canExecute']?.(newCardInfo);
      expect(results).assertUndefined();
      mocker.clear(AbilityFormUtil);
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('UpdateFormsCommandTest_canExecute_08', 0, (): void => {
      const commandId = '123';
      let commandObj: UpdateFormsCommand = new UpdateFormsCommand(commandId);
      let instance: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      let newCardInfo: BaseCardInfo = new BaseCardInfo();
      let oldCardInfo: BaseCardInfo = new BaseCardInfo();
      const cardList: GridLayoutItemInfo[] = [];
      const items: GridLayoutItemInfo = new GridLayoutItemInfo();
      items.cardId = '123';
      cardList.push(items);
      newCardInfo.operateFormId = '123569';
      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getFormStackInfoByFormStackId);
      const func2: Function = mocker.mockFunc(instance, instance.getCardInfo);
      when(func1)(commandId).afterReturn(cardList);
      when(func2)(items.cardId).afterReturn(oldCardInfo);

      let results: boolean = (commandObj as object)['canExecute']?.(newCardInfo);
      expect(results).assertUndefined();
      mocker.clear(AbilityFormUtil);
      mocker.clear(instance);
      mocker.clearAll();
    });

  });
}