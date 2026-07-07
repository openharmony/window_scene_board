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
import { ArrayUtils, TraceUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ViewManagerPolicy } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when,
} from '@ohos/hypium';
import { LauncherAnimUtil } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { BaseCommand } from '../../../../../../main/ets/default/command/BaseCommand';
import { CommandConsumer } from '../../../../../../main/ets/default/command/CommandConsumer';
import { CommandList } from '../../../../../../main/ets/default/command/CommandList';

class MyCommand extends BaseCommand {
  execute(): void {
    console.info('do nothing');
  };
};

/**
 * CommandConsumerTest
 *
 * @since 2024-04-09
 */
export function CommandConsumerTest() {
  describe('CommandConsumerTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('testExecuteCacheCommand', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      let commandList: CommandList = (instance as object)['commandList'];
      const commands: BaseCommand[] = [];
      const items: BaseCommand = new MyCommand();
      items.commandId = '1111111';
      items.commandType = 0;
      items.operateCardId = '111111';
      items.delayTime = 1;
      items.executeTime = Date.now() - 1;
      commands.push(items);
      (commandList as object)['pendingCommandMap'].set('1111111', commands);
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(instance, (instance as object)['executePendingCommands']);
      when(func)().afterAction(action);

      instance.checkAndExecuteCommands();
      expect(called).assertFalse();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('CommandConsumerTest_executeRestCommandsIfNeed', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(func1)(1).afterReturn(true);
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let func2: Function = mocker.mockFunc(instance, (instance as object)['executePendingCommands']);
      when(func2)().afterAction(action);

      (instance as object)['executeRestCommandsIfNeed']();
      expect(called).assertFalse();
      mocker.clear(ViewManagerPolicy);
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('CommandConsumerTest_executePendingCommands', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      let commandList: CommandList = (instance as object)['commandList'];
      (commandList as object)['executeCommandList'] = [];
      (commandList as object)['pendingCommandMap'].set('1111', []);
      (commandList as object)['restCommandMap'].set('1111', []);
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(instance, (instance as object)['executeCommand']);
      when(func)([]).afterAction(action);

      (instance as object)['executePendingCommands']('1111');
      expect(called).assertFalse();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('CommandConsumerTest_executeCommand_01', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      let mocker: MockKit = new MockKit();
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const func: Function = mocker.mockFunc(instance, (instance as object)['doExecute']);
      when(func)(new MyCommand()).afterAction(action);
      (instance as object)['executeCommand']([]);

      expect(called).assertFalse();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('CommandConsumerTest_executeCommand_02', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(func1)([]).afterReturn(false);
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const func2: Function = mocker.mockFunc(instance, (instance as object)['doExecute']);
      when(func2)(new MyCommand()).afterAction(action);

      (instance as object)['executeCommand']([]);
      expect(called).assertFalse();
      mocker.clear(ArrayUtils);
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('CommandConsumerTest_finishCommand', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      let mocker: MockKit = new MockKit();
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const func: Function = mocker.mockFunc(instance, (instance as object)['executePendingCommands']);
      when(func)('123').afterAction(action);

      instance.finishCommand('123', 2);
      expect(called).assertFalse();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('CommandConsumerTest_checkAndExecute', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      let mocker: MockKit = new MockKit();
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const func: Function = mocker.mockFunc(TraceUtil, TraceUtil.traceOnce);
      const func1: Function = mocker.mockFunc(LauncherAnimUtil, LauncherAnimUtil.isUiThreadBusy);
      when(func1)().afterReturn(true);
      when(func)('Home').afterAction(action);
      (instance as object)['checkAndExecute'](new MyCommand());
      expect(called).assertFalse();
      mocker.clear(LauncherAnimUtil);
      mocker.clear(TraceUtil);
      mocker.clearAll();
    });

    it('CommandConsumerTest_checkAndExecuteCommands', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      let commandList: CommandList = (instance as object)['commandList'];
      (commandList as object)['pendingCommandMap'].set('1111111',[]);
      (commandList as object)['executeCommandList'] = [];
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(instance, (instance as object)['executePendingCommands']);
      when(func)().afterAction(action);

      instance.checkAndExecuteCommands();
      expect(called).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('CommandConsumerTest_executeRestCommandsIfNeed_02', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      let mocker: MockKit = new MockKit();
      const func1: Function = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(func1)(1).afterReturn(false);
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      let func2: Function = mocker.mockFunc(instance, (instance as object)['executePendingCommands']);
      when(func2)().afterAction(action);

      (instance as object)['executeRestCommandsIfNeed']();
      expect(called).assertTrue();
      mocker.clear(ViewManagerPolicy);
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('CommandConsumerTest_executeCommand_03', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      const commands: BaseCommand[] = [];
      const items: BaseCommand = new MyCommand();
      items.commandId = '1111111';
      items.commandType = 0;
      items.operateCardId = '111111';
      items.delayTime = 1;
      items.executeTime = Date.now() - 1;
      commands.push(items);
      (instance as object)['commandList']['pendingCommandMap'].set('1111111',commands);
      (instance as object)['commandList']['executeCommandList'] = commands;
      let mocker: MockKit = new MockKit();
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const func: Function = mocker.mockFunc(instance, (instance as object)['doExecute']);
      when(func)(items).afterAction(action);

      (instance as object)['executeCommand'](commands);
      expect(called).assertFalse();
      mocker.clear(ArrayUtils);
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('CommandConsumerTest_finishCommand_02', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      let commandList: CommandList = (instance as object)['commandList'];
      let mocker: MockKit = new MockKit();
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const func: Function = mocker.mockFunc(instance, (instance as object)['executePendingCommands']);
      const func1: Function = mocker.mockFunc(commandList, commandList.removeExecutedCommand);
      const func2: Function = mocker.mockFunc(commandList, commandList.isCommandExecuting);
      when(func1)('123').afterReturn(true);
      when(func2)().afterReturn(true);
      when(func)('123').afterAction(action);

      instance.finishCommand('123', 2);
      expect(called).assertTrue();
      mocker.clear(instance);
      mocker.clear(commandList);
      mocker.clearAll();
    });

    it('CommandConsumerTest_finishCommand_03', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      let commandList: CommandList = (instance as object)['commandList'];
      let mocker: MockKit = new MockKit();
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const func: Function = mocker.mockFunc(instance, (instance as object)['executePendingCommands']);
      const func1: Function = mocker.mockFunc(commandList, commandList.removeExecutedCommand);
      const func2: Function = mocker.mockFunc(commandList, commandList.isCommandExecuting);
      when(func1)('123').afterReturn(true);
      when(func2)().afterReturn(false);
      when(func)('123').afterAction(action);

      instance.finishCommand('123', 2);
      expect(called).assertFalse();
      mocker.clear(instance);
      mocker.clear(commandList);
      mocker.clearAll();
    });

    it('CommandConsumerTest_checkAndExecute_02', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      let mocker: MockKit = new MockKit();
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const func: Function = mocker.mockFunc(TraceUtil, TraceUtil.traceOnce);
      const func1: Function = mocker.mockFunc(LauncherAnimUtil, LauncherAnimUtil.isUiThreadBusy);
      when(func1)().afterReturn(false);
      when(func)('Home').afterAction(action);
      (instance as object)['checkAndExecute'](new MyCommand());
      expect(called).assertTrue();
      mocker.clear(LauncherAnimUtil);
      mocker.clear(TraceUtil);
      mocker.clearAll();
    });

    it('CommandConsumerTest_doExecute_01', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      const items: BaseCommand = new MyCommand();
      items.commandId = '1111111';
      items.commandType = 0;
      items.operateCardId = '111111';
      items.delayTime = 1;
      items.executeTime = Date.now() - 1;
      let mocker: MockKit = new MockKit();
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const func: Function = mocker.mockFunc(instance, (instance as object)['checkAndExecute']);
      when(func)(items).afterAction(action);

      (instance as object)['doExecute'](items);
      expect(called).assertFalse();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('CommandConsumerTest_doExecute_02', 0, () => {
      let instance: CommandConsumer = CommandConsumer.getInstance();
      const items: BaseCommand = new MyCommand();
      items.commandId = '1111111';
      items.commandType = 0;
      items.operateCardId = '111111';
      items.delayTime = 0;
      items.executeTime = Date.now() - 1;
      let mocker: MockKit = new MockKit();
      let called: boolean = false;
      let action: () => void = (): void => { called = true; };
      const func: Function = mocker.mockFunc(instance, (instance as object)['checkAndExecute']);
      when(func)(items).afterAction(action);

      (instance as object)['doExecute'](items);
      expect(called).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    });
  });
}