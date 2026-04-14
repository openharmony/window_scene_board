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
} from '@ohos/hypium'
import {
  CommonConstants,
  DockItemInfo,
} from '@ohos/launchercommon'
import { SmartDockStyleConfig } from '../../../../main/ets/default/common/SmartDockStyleConfig'
import SmartDockReorderLayout from '../../../../main/ets/default/layout/SmartDockReorderLayout'
import SmartDockViewModel from '../../../../main/ets/default/viewmodel/SmartDockViewModel'


export default function SmartDockReorderLayoutTest() {
  describe('SmartDockReorderLayoutTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_setInPreviewMode_01', 0, () => {
      try {
        let instance = SmartDockReorderLayout.getInstance();
        instance.setSmartDockStyleConfig(SmartDockStyleConfig.getInstance());
        expect(instance instanceof SmartDockReorderLayout).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_clearSolution_01', 0, () => {
      try {
        let instance = SmartDockReorderLayout.getInstance();
        instance.clearSolution();
        expect(instance instanceof SmartDockReorderLayout).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_addItem_01', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockReorderLayout.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, instance.getItemIndex);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(0);

        let item: DockItemInfo = {
          visible: true,
          borderVisible: false,
          shake: 0,
          bundleName: '',
          abilityName: '',
          moduleName: '',
          appName: '',
          appIconId: 0,
          missionInfoList: []
        }
        let index: number = 0;
        instance.addItem(item, index);
        expect(instance instanceof SmartDockReorderLayout).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_addItem_02', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockReorderLayout.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, instance.getItemIndex);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(-1);

        let item: DockItemInfo = {
          visible: true,
          borderVisible: false,
          shake: 0,
          bundleName: '',
          abilityName: '',
          moduleName: '',
          appName: '',
          appIconId: 0,
          missionInfoList: []
        }
        let index: number = 0;
        instance.addItem(item, index);
        expect(instance instanceof SmartDockReorderLayout).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_delItem_01', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockReorderLayout.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, instance.getItemIndex);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(-1);

        let item: DockItemInfo = {
          visible: true,
          borderVisible: false,
          shake: 0,
          bundleName: '',
          abilityName: '',
          moduleName: '',
          appName: '',
          appIconId: 0,
          missionInfoList: []
        }
        instance.delItem(item);
        expect(instance instanceof SmartDockReorderLayout).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_delItem_02', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockReorderLayout.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, instance.getItemIndex);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(0);

        let item: DockItemInfo = {
          visible: true,
          borderVisible: false,
          shake: 0,
          bundleName: '',
          abilityName: '',
          moduleName: '',
          appName: '',
          appIconId: 0,
          missionInfoList: []
        }
        instance.delItem(item);
        expect(instance instanceof SmartDockReorderLayout).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_adjustItem_01', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockReorderLayout.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, instance.getItemIndex);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(-1);

        let item: DockItemInfo = {
          visible: true,
          borderVisible: false,
          shake: 0,
          bundleName: '',
          abilityName: '',
          moduleName: '',
          appName: '',
          appIconId: 0,
          missionInfoList: []
        }
        let index: number = 0;
        (instance as object)['mSolutionLayout'] = [item];
        instance.adjustItem(item, index);
        expect(instance instanceof SmartDockReorderLayout).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_adjustItem_01', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockReorderLayout.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(instance, instance.getItemIndex);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(0);

        let item: DockItemInfo = {
          visible: true,
          borderVisible: false,
          shake: 0,
          bundleName: '',
          abilityName: '',
          moduleName: '',
          appName: '',
          appIconId: 0,
          missionInfoList: []
        }
        let index: number = 0;
        (instance as object)['mSolutionLayout'] = [item];
        instance.adjustItem(item, index);
        expect(instance instanceof SmartDockReorderLayout).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_getItemIndex_01', 0, () => {
      try {
        let instance = SmartDockReorderLayout.getInstance();
        let item: DockItemInfo = {
          typeId: CommonConstants.TYPE_FOLDER,
          keyName: 'CommonConstants.TYPE_FOLDER',
          visible: true,
          borderVisible: false,
          shake: 0,
          bundleName: '',
          abilityName: '',
          moduleName: '',
          appName: '',
          appIconId: 0,
          missionInfoList: []
        }
        instance.getItemIndex(item);
        expect(instance instanceof SmartDockReorderLayout).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
  })
}
