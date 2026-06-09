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
import { AppItemInfo } from '../../../../../../main/ets/bean/AppItemInfo';
import { PreviewLayoutCheckTool } from '../../../../../../main/ets/tools/PreviewLayoutCheckTool';
import Account from '@ohos.account.osAccount';
import { GridLayoutItemInfo } from '../../../../../../main/ets/TsIndex';
import { SCBOobeManager } from '@ohos/windowscene';

export function PreviewLayoutCheckToolTest() {
  describe('PreviewLayoutCheckToolTest', () => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    });

    afterAll((): void => {
    });

    it('startCheck', 0, async () => {
      let tool : PreviewLayoutCheckTool = PreviewLayoutCheckTool.getInstance();
      tool.addPromiseEvent('default');
      let ret: boolean = await tool.startCheck('aa');
      expect(!ret).assertTrue();
    })

    it('startCheck2', 0, async () => {
      let tool : PreviewLayoutCheckTool = PreviewLayoutCheckTool.getInstance();
      tool.addPromiseEvent('default');
      let ret: boolean = await tool.startCheck('default');
      expect(ret).assertTrue();
    })

    it('checkLayoutInOOBE2', 0, async () => {
      let tool : PreviewLayoutCheckTool = PreviewLayoutCheckTool.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(SCBOobeManager, SCBOobeManager.isEnable);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      tool.addPromiseEvent('default');
      let ret: boolean = await tool.startCheck('default');
      expect(ret).assertTrue();
      mocker.clear(SCBOobeManager);
      mocker.clearAll();
    })

    it('checkLayoutInOOBE3', 0, async () => {
      let tool : PreviewLayoutCheckTool = PreviewLayoutCheckTool.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(SCBOobeManager, SCBOobeManager.isEnable);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

      tool.addPromiseEvent('default');
      let ret: boolean = await tool.startCheck('default');
      expect(ret).assertTrue();
      mocker.clear(SCBOobeManager);
      mocker.clearAll();
    })

    it('checkLayoutInOOBE4', 0, async () => {
      let tool : PreviewLayoutCheckTool = PreviewLayoutCheckTool.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(SCBOobeManager, SCBOobeManager.isEnable);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      let mockFunc2: Function =
        mocker.mockFunc(tool, tool['checkSame']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

      tool.addPromiseEvent('default');
      let ret: boolean = await tool.startCheck('default');
      expect(ret).assertTrue();
      mocker.clear(SCBOobeManager);
      mocker.clear(tool);
      mocker.clearAll();
    })

    it('checkSame', 0, async () => {
      let tool : PreviewLayoutCheckTool = PreviewLayoutCheckTool.getInstance();
      await tool['checkSame']();
    })

    it('compare', 0, async () => {
      let tool : PreviewLayoutCheckTool = PreviewLayoutCheckTool.getInstance();
      let defaultApps: Set<string> = new Set<string>();
      await tool['compare'](defaultApps);
    })

    it('compare2', 0, async () => {
      let tool : PreviewLayoutCheckTool = PreviewLayoutCheckTool.getInstance();
      let defaultApps: Set<string> = new Set<string>();
      defaultApps.add('bundleName');
      let isSame = await tool['compare'](defaultApps);
      expect(!isSame).assertTrue();
    })

    it('compare3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let tool : PreviewLayoutCheckTool = PreviewLayoutCheckTool.getInstance();
      let mockFunc : Function = mocker.mockFunc(tool, tool['getFirstPageApp']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      let defaultApps: Set<string> = new Set<string>();
      defaultApps.add('bundleName');
      let isSame = await tool['compare'](defaultApps);
      expect(!isSame).assertTrue();
      mocker.clear(tool);
      mocker.clearAll();
    })

    it('compare4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let tool : PreviewLayoutCheckTool = PreviewLayoutCheckTool.getInstance();
      let mockFunc : Function = mocker.mockFunc(tool, tool['getFirstPageApp']);
      let retArr: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = {
        bundleName: 'bundleName1',
        abilityName: 'abilityName',
        moduleName: 'moduleName',
        container: -100,
        page: 0,
        row: 0,
        column: 0,
        appIconId: 0,
        negativeId: 0,
        isSelect: false,
        enterEditing: false,
        downloadProgress: 0,
        appStatus: undefined,
        iconResource: undefined,
        callerName: undefined,
        setInfo: (): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      };
      retArr.push(item);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(retArr);
      let defaultApps: Set<string> = new Set<string>();
      defaultApps.add('bundleName_abilityName_moduleName_-100_0_0_0');
      let isSame = await tool['compare'](defaultApps);
      expect(!isSame).assertTrue();
      mocker.clear(tool);
      mocker.clearAll();
    })

    it('compare5', 0, async () => {
      let mocker: MockKit = new MockKit();
      let tool : PreviewLayoutCheckTool = PreviewLayoutCheckTool.getInstance();
      let mockFunc : Function = mocker.mockFunc(tool, tool['getFirstPageApp']);
      let retArr: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = {
        bundleName: 'bundleName',
        abilityName: 'abilityName',
        moduleName: 'moduleName',
        container: -100,
        page: 0,
        row: 0,
        column: 0,
        appIconId: 0,
        negativeId: 0,
        isSelect: false,
        enterEditing: false,
        downloadProgress: 0,
        appStatus: undefined,
        iconResource: undefined,
        callerName: undefined,
        setInfo: (): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      };
      retArr.push(item);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(retArr);
      let defaultApps: Set<string> = new Set<string>();
      defaultApps.add('bundleName_abilityName_moduleName_-100_0_0_0');
      let isSame = await tool['compare'](defaultApps);
      expect(!isSame).assertTrue();
      mocker.clear(tool);
      mocker.clearAll();
    })

    it('compare6', 0, async () => {
      let mocker: MockKit = new MockKit();
      let tool : PreviewLayoutCheckTool = PreviewLayoutCheckTool.getInstance();
      let mockFunc : Function = mocker.mockFunc(tool, tool['getFirstPageApp']);
      let retArr: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = {
        bundleName: 'bundleName',
        abilityName: 'abilityName',
        moduleName: 'moduleName',
        container: -100,
        page: 0,
        row: 0,
        column: 0,
        appIconId: 0,
        negativeId: 0,
        isSelect: false,
        enterEditing: false,
        downloadProgress: 0,
        appStatus: undefined,
        iconResource: undefined,
        callerName: undefined,
        setInfo: (): void => {
          throw new Error('Function not implemented.');
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.');
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.');
        }
      };
      retArr.push(item);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(retArr);
      let defaultApps: Set<string> = new Set<string>();
      defaultApps.add('bundleName_abilityName_moduleName_-100_0_0_0');
      defaultApps.add('bundleName2_abilityName_moduleName_-100_0_0_0');
      let isSame = await tool['compare'](defaultApps);
      expect(!isSame).assertTrue();
      mocker.clear(tool);
      mocker.clearAll();
    })
  })
}