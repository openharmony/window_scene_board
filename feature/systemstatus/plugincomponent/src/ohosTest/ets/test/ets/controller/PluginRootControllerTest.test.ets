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
import { describe, it, expect, MockKit, when } from '@ohos/hypium';
import {
  PluginRootController,
  PluginRootControllerConstructor
} from '../../../../../main/ets/controller/PluginRootController';
import { StatusBarType } from '@ohos/systemuicommon';

export function pluginRootControllerTest() {
  describe('pluginRootControllerTest', () => {
    it('initPluginRootControllerTest_TYPE_MAIN_PC_WHITE_01', 0, () => {
      let param: PluginRootControllerConstructor = {
        slot: 'test1',
        statusBarType: StatusBarType.TYPE_MAIN_PC_WHITE,
        callback: (isVisible: boolean) => {
        },
      }
      let pluginRootControllerInstance: PluginRootController = new PluginRootController(param);
      pluginRootControllerInstance.onStart();
      expect(pluginRootControllerInstance instanceof PluginRootController).assertTrue();
    });

    it('initPluginRootControllerTest_TYPE_MAIN_PC_BLACK_02', 0, () => {
      let param: PluginRootControllerConstructor = {
        slot: 'test2',
        statusBarType: StatusBarType.TYPE_MAIN_PC_BLACK,
        callback: () => {
        },
      }
      let pluginRootControllerInstance: PluginRootController = new PluginRootController(param);
      pluginRootControllerInstance.onStart();
      expect(pluginRootControllerInstance instanceof PluginRootController).assertTrue();
    });
    it('initPluginRootControllerTest_TYPE_MAIN_PHONE_LAUNCHER_03', 0, () => {
      let param: PluginRootControllerConstructor = {
        slot: 'test2',
        statusBarType: StatusBarType.TYPE_MAIN_PHONE_LAUNCHER,
        callback: () => {
        },
      }
      let pluginRootControllerInstance: PluginRootController = new PluginRootController(param);
      pluginRootControllerInstance.onStart();
      expect(pluginRootControllerInstance instanceof PluginRootController).assertTrue();
    });

    it('initPluginRootControllerTest_TYPE_MAIN_PHONE_LAUNCHER_NotSlot_04', 0, () => {
      let param: PluginRootControllerConstructor = {
        slot: '',
        statusBarType: StatusBarType.TYPE_MAIN_PHONE_LAUNCHER,
        callback: () => {
        },
      }
      let pluginRootControllerInstance: PluginRootController = new PluginRootController(param);
      pluginRootControllerInstance.onStart();
      expect(pluginRootControllerInstance instanceof PluginRootController).assertTrue();
    });

  });
}

export function pluginRootControllerTest_two() {
  describe('pluginRootControllerTest_two', () => {
    it('initPluginRootControllerTest_TYPE_MAIN_PHONE_DROPDOWN_05', 0, () => {
      let param: PluginRootControllerConstructor = {
        slot: 'test5',
        statusBarType: StatusBarType.TYPE_MAIN_PHONE_DROPDOWN,
        callback: () => {
        },
      }
      let pluginRootControllerInstance: PluginRootController = new PluginRootController(param);
      pluginRootControllerInstance.onStart();
      expect(pluginRootControllerInstance instanceof PluginRootController).assertTrue();
    });
    it('onStopTest', 0, () => {
      let param: PluginRootControllerConstructor = {
        slot: 'onStopTest',
        statusBarType: StatusBarType.TYPE_MAIN_PHONE_DROPDOWN,
        callback: () => {
        },
      }
      let pluginRootControllerInstance: PluginRootController = new PluginRootController(param);
      pluginRootControllerInstance.onStop();
      expect(pluginRootControllerInstance instanceof PluginRootController).assertTrue();
    });
    it('getStatusBarTypeTest', 0, () => {
      let param: PluginRootControllerConstructor = {
        slot: 'onStopTest',
        statusBarType: StatusBarType.TYPE_MAIN_PHONE_DROPDOWN,
        callback: () => {
        },
      }
      let pluginRootControllerInstance: PluginRootController = new PluginRootController(param);
      let testType = pluginRootControllerInstance.getStatusBarType();
      expect(testType).assertEqual(StatusBarType.TYPE_MAIN_PHONE_DROPDOWN);
    });
    it('refreshWhenStatusBarChange_true_Test_01', 0, () => {
      let param: PluginRootControllerConstructor = {
        slot: 'onStopTest',
        statusBarType: StatusBarType.TYPE_MAIN_PHONE_DROPDOWN,
        callback: () => {
        },
      }
      let pluginRootControllerInstance: PluginRootController = new PluginRootController(param);
      (pluginRootControllerInstance as object)['isPureShow'] = true;
      pluginRootControllerInstance.refreshWhenStatusBarChange(StatusBarType.TYPE_MAIN_PHONE_DROPDOWN);
      expect(pluginRootControllerInstance instanceof PluginRootController).assertTrue();
    });
  });
}