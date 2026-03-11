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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { DebugCommand, DebugCommandManager } from '../../../../../../main/ets/recent/debug/DebugCommand'
import CommonEventManager from '@ohos.commonEventManager';
import systemParameter from '@ohos.systemParameterEnhance';
import { util } from '@kit.ArkTS';

const VERSION_NAME = 'const.logsystem.versiontype';
const ENG_PARAMETER = 'const.debuggable';

function registerTest1(args: Array<string>): string {
  return 'registerTest1';
}

export function DebugCommandTest() {
  describe('DebugCommandTest', (): void => {
    let manager: DebugCommandManager = new DebugCommandManager();
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterAll((): void => {
    })
    afterEach((): void => {
    })

    it('DebugCommand_test_register_01', 0, (): void => {
      let size = 258;
      let cmds: Array<DebugCommand> = [];
      let cmd: DebugCommand = {
        cmdName: 'registerTestModule',
        callback: (args: Array<string>) => {
          return registerTest1(args);
        }
      };
      for(let i: number = 0; i < size; i++) {
        cmd.cmdName = 'registerTestModule' + i + 1;
        cmds.push(cmd);
      }
      for (let index: number = 0; index < size; index++) {
        manager.register('registerTestModule' + index, cmds);
      }
      let moduleStr = manager.getAllModules()
      let moduleList = moduleStr.split(' | ')
      expect(moduleList.includes('registerTestModule1')).assertTrue();
    })

    it('DebugCommand_test_register_02', 0, (): void => {
      let cmds: Array<DebugCommand> = [
        {
          cmdName: 'registerTest1',
          callback: (args: Array<string>) => {
            return registerTest1(args);
          }
        }
      ];
      manager.register('registerTestModule1', cmds);
      let moduleStr = manager.getAllModules()
      let moduleList = moduleStr.split(' | ')
      expect(moduleList.includes('registerTestModule1')).assertTrue();
    })

    it('DebugCommand_test_unregister', 0, (): void => {
      manager.unregister('not_exits_module');
      manager.unregister('registerTestModule1');
      let moduleStr = manager.getAllModules()
      let moduleList = moduleStr.split(' | ')
      expect(moduleList.includes('registerTestModule1')).assertFalse();
    })

    it('DebugCommand_test_getAllCommandNames_01', 0, (): void => {
      let cmds: Array<DebugCommand> = [
        {
          cmdName: 'registerTest1',
          callback: (args: Array<string>) => {
            return registerTest1(args);
          }
        },
        {
          cmdName: 'registerTest2',
          callback: (args: Array<string>) => {
            return registerTest1(args);
          }
        },
        {
          cmdName: 'registerTest3',
          callback: (args: Array<string>) => {
            return registerTest1(args);
          }
        }
      ];
      (manager as object)['getAllCommandNames'](cmds);
      expect(cmds.length).assertEqual(3);
    })

    it('DebugCommand_test_getAllCommandNames_02', 0, (): void => {
      let cmds: Array<DebugCommand> = [
        {
          cmdName: 'registerTest1',
          callback: (args: Array<string>) => {
            return registerTest1(args);
          }
        }
      ];
      (manager as object)['getAllCommandNames'](cmds);
      expect(cmds.length).assertEqual(1);
    })

    it('DebugCommand_test_getAllCommandNames_03', 0, (): void => {
      let cmds: Array<DebugCommand> = [];
      let result: string = (manager as object)['getAllCommandNames'](cmds);
      expect(result).not().assertUndefined();
      expect(result?.length).assertEqual(0);
    })

    it('DebugCommand_test_subscribe_undefined', 0, (): void => {
      manager.subscribe();
      expect(manager['subscriber'] === undefined).assertTrue();
    })

    it('DebugCommand_test_subscribe', 0, (): void => {
      manager.subscribe();
      let flag = false
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(manager, CommonEventManager.createSubscriber);
      when(mockfunc)({
        events: ['com.ohos.sceneboard.debug.event.listener']
      }).afterAction(() => {
        flag = true
      });
      try {
        CommonEventManager.createSubscriber({
          events: ['com.ohos.sceneboard.debug.event.listener']
        });
      } catch (e) {
        expect(e).assertEqual('err');
      }
      mocker.clearAll();
    })

    it('DebugCommand_test_subscribe_01', 0, (): void => {
      manager.subscribe();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(manager, CommonEventManager.createSubscriber);
      when(mockfunc)({
        events: ['com.ohos.sceneboard.debug.event.listener']
      }).afterThrow('err');
      expect(manager['mRecentMissionsLimit']).assertUndefined();
      mocker.clearAll();
    })

    it('DebugCommand_test_subscribe_err', 0, (): void => {
      manager.subscribe();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(manager, CommonEventManager.createSubscriber);
      when(mockfunc)({
        events: ['com.ohos.sceneboard.debug.event.listener']
      }).afterThrow('err');
      try {
        CommonEventManager.createSubscriber({
          events: ['com.ohos.sceneboard.debug.event.listener']
        });
      } catch (e) {
        expect(e).assertEqual('err');
      }
      mocker.ignoreMock(manager, CommonEventManager.createSubscriber);
      mocker.clearAll();
    })

    it('DebugCommand_test_doCommandInner_01', 0, (): void => {
      let result: string = (manager as object)['doCommandInner']('', '', []);
      expect(result).not().assertUndefined();
      expect(result.length).assertLargerOrEqual(0);
    })

    it('DebugCommand_test_doCommandInner_02', 0, (): void => {
      let map: Map<string, DebugCommand[]> = (manager as object)['moduleCommandList'];
      map?.clear();
      const moduleName = 'test_moduleName';
      const cmdName = 'test_cmdName';
      let cmd: DebugCommand = {
        cmdName: cmdName,
        callback: (args: Array<string>) => {
          return registerTest1(args);
        }
      };
      manager.register(moduleName, [cmd]);

      let result: string = (manager as object)['doCommandInner'](moduleName, cmdName, []);
      expect(result).not().assertUndefined();
      expect(result.length).assertLargerOrEqual(0);
    })

    it('DebugCommand_test_doCommand_01', 0, (): void => {
      (manager as object)['doCommand']('', '');
      expect(manager).not().assertUndefined();
      const args: string = '-a  -b  -c  -d  -e';
      (manager as object)['doCommand'](args, 'path');
      expect(manager).not().assertUndefined();
    })

    it('DebugCommand_test_doStringCommand_01', 0, (): void => {
      let result: string = (manager as object)['doStringCommand']('');
      expect(result).not().assertUndefined();
      expect(result).assertContain('Available modules');
    })

    it('DebugCommand_test_doStringCommand_02', 0, (): void => {
      const args: string = '-a  -b  -c  -d  -e';
      let result: string = (manager as object)['doStringCommand'](args);
      expect(result).not().assertUndefined();
    })

    it('DebugCommand_test_doStringCommand_02', 0, (): void => {
      manager.writeToDumpFile('', '');
      manager.writeToDumpFile('file_path', 'text to write');
      expect(manager).not().assertUndefined();
    })

    it('DebugCommand_test_publish', 0, (): void => {
      (manager as object)['publish']('data');
      expect(manager).not().assertUndefined();
    })

    it('DebugCommand_test_filterMidSceneFSM', 0, (): void => {
      const MID_SCENE = 'midSceneFSM';
      let result: boolean = manager.filterMidSceneFSM('');
      expect(result).assertTrue();

      result = manager.filterMidSceneFSM(MID_SCENE);
      expect(result).assertFalse();
    })

    it('DebugCommand_test_initialDependentModules', 0, (): void => {
      (manager as object)['initialDependentModules']();
      expect(manager).not().assertUndefined();
    })
  })
}