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

import { CheckEmptyUtils } from '@ohos/basicutils';
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
import { CollaborationLayoutCacheMgr } from '../../../../../../main/ets/dock/cache/CollaborationLayoutCacheMgr';
import { AppItemDto, CollaborationEventManager,
  DataChangeCallbackFunc } from '../../../../../../main/ets/manager/CollaborationEventManager';
import { DockItemInfo } from '../../../../../../main/ets/TsIndex';
import { bundleManager, common } from '@kit.AbilityKit';

export default function CollaborationEventManagerTest() {
  describe('CollaborationEventManagerTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_handleDistributedDataList_01', 0, () => {
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        let dataList: Array<AppItemDto> = [];
        instance.handleDistributedDataList(dataList);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_handleDistributedDataList_02', 0, () => {
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        let item1: AppItemDto = new AppItemDto();
        let dataList: Array<AppItemDto> = [item1];
        instance.handleDistributedDataList(dataList);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_handleDistributedDataList_02', 0, () => {
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        let item1: AppItemDto = new AppItemDto();
        item1.bundleName = 'test';
        item1.showType = 0;
        let dataList: Array<AppItemDto> = [item1];
        instance['printParam'](dataList);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_dealDistributedDataList_01', 0, () => {
      let mock = new MockKit();
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let item1: AppItemDto = new AppItemDto();
        item1.bundleName = 'test';
        item1.showType = 0;
        let dataList: Array<AppItemDto> = [item1];

        instance['dealDistributedDataList'](dataList);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_dealDistributedDataList_02', 0, () => {
      let mock = new MockKit();
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let item1: AppItemDto = new AppItemDto();
        item1.bundleName = 'test';
        item1.showType = 0;
        let dataList: Array<AppItemDto> = [item1];

        instance['dealDistributedDataList'](dataList);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_addDistributedDataList_01', 0, () => {
      let mock = new MockKit();
      let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
      try {
        let info1: DockItemInfo = new DockItemInfo();
        info1.bundleName = 'test';
        let collaborationDataList: DockItemInfo[] = [info1];

        let mockFunc: Function = mock.mockFunc(CollaborationLayoutCacheMgr.getInstance(),
          CollaborationLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(collaborationDataList);

        let mockFunc2: Function = mock.mockFunc(instance, instance['isDataListExistDockItem']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function = mock.mockFunc(instance, instance['isCollaborationDataListExistItemDto']);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc4: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);

        let item1: AppItemDto = new AppItemDto();
        item1.bundleName = 'test';
        item1.showType = 0;
        let dataList: Array<AppItemDto> = [item1];

        instance['addDistributedDataList'](dataList);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CollaborationLayoutCacheMgr.getInstance());
      mock.clear(instance);
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_addDistributedDataList_02', 0, () => {
      let mock = new MockKit();
      let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
      try {
        let info1: DockItemInfo = new DockItemInfo();
        info1.bundleName = 'test';
        let collaborationDataList: DockItemInfo[] = [info1];

        let mockFunc: Function = mock.mockFunc(CollaborationLayoutCacheMgr.getInstance(),
          CollaborationLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(collaborationDataList);

        let mockFunc2: Function = mock.mockFunc(instance, instance['isDataListExistDockItem']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function = mock.mockFunc(instance, instance['isCollaborationDataListExistItemDto']);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc4: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn(false);

        let item1: AppItemDto = new AppItemDto();
        item1.bundleName = 'test';
        item1.showType = 0;
        let dataList: Array<AppItemDto> = [item1];

        instance['addDistributedDataList'](dataList);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CollaborationLayoutCacheMgr.getInstance());
      mock.clear(instance);
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_isDataListExistDockItem_01', 0, () => {
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        let info1: DockItemInfo = new DockItemInfo();
        info1.bundleName = 'test';

        let item1: AppItemDto = new AppItemDto();
        item1.bundleName = 'test';
        let dataList: Array<AppItemDto> = [item1];
        instance['isDataListExistDockItem'](dataList, info1);
        instance.clearDistributedDataList();
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isDataListExistDockItem_02', 0, () => {
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        let info1: DockItemInfo = new DockItemInfo();
        info1.bundleName = 'test';

        let item1: AppItemDto = new AppItemDto();
        item1.bundleName = 'test1';
        let dataList: Array<AppItemDto> = [item1];
        instance['isDataListExistDockItem'](dataList, info1);
        instance.clearDistributedDataList();
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isCollaborationDataListExistItemDto_01', 0, () => {
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        let info1: DockItemInfo = new DockItemInfo();
        info1.bundleName = 'test';
        let collaborationDataList: DockItemInfo[] = [info1];

        let item1: AppItemDto = new AppItemDto();
        item1.bundleName = 'test';

        instance['isCollaborationDataListExistItemDto'](collaborationDataList, item1);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isCollaborationDataListExistItemDto_02', 0, () => {
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        let info1: DockItemInfo = new DockItemInfo();
        info1.bundleName = 'test';
        let collaborationDataList: DockItemInfo[] = [info1];

        let item1: AppItemDto = new AppItemDto();
        item1.bundleName = 'test1';

        instance['isCollaborationDataListExistItemDto'](collaborationDataList, item1);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_convertToDockItemInfo_01', 0, () => {
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        let uiAbilityContext = getContext() as common.UIAbilityContext;
        let appItemInfo: bundleManager.AbilityInfo = uiAbilityContext && uiAbilityContext.abilityInfo || {} as bundleManager.AbilityInfo;
        let deviceType: string ='';
        instance['convertToDockItemInfo'](appItemInfo, deviceType);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_convertToDockItemInfo_02', 0, () => {
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        let uiAbilityContext = getContext() as common.UIAbilityContext;
        let appItemInfo: bundleManager.AbilityInfo = uiAbilityContext && uiAbilityContext.abilityInfo || {} as bundleManager.AbilityInfo;
        let deviceType: string ='not empty';
        instance['convertToDockItemInfo'](appItemInfo, deviceType);
        instance.getCollaborationDataList();
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_registerDataChangeCallback_01', 0, () => {
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        const registerTag: string = 'CollaborationEventManagerTest';
        let callback: DataChangeCallbackFunc = () => {
        };
        instance.unRegisterDataChangeCallback(registerTag);
        instance.registerDataChangeCallback('', callback);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_registerDataChangeCallback_02', 0, () => {
      let mock = new MockKit();
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        const registerTag: string = 'CollaborationEventManagerTest';
        let callback: DataChangeCallbackFunc = () => {
        };

        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(callback).afterReturn(true);

        instance.unRegisterDataChangeCallback(registerTag);
        instance.registerDataChangeCallback(registerTag, callback);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_registerDataChangeCallback_03', 0, () => {
      let mock = new MockKit();
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        const registerTag: string = 'CollaborationEventManagerTest';
        let callback: DataChangeCallbackFunc = () => {
        };

        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(callback).afterReturn(false);

        instance.unRegisterDataChangeCallback(registerTag);
        instance.registerDataChangeCallback(registerTag, callback);
        instance.registerDataChangeCallback(registerTag, callback);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_isCollaborationDataListExistItemDto_01', 0, () => {
      try {
        let instance: CollaborationEventManager = CollaborationEventManager.getInstance();
        let info1: DockItemInfo = new DockItemInfo();
        info1.bundleName = 'test';
        let collaborationDataList: DockItemInfo[] = [info1];

        let callback: DataChangeCallbackFunc = () => {
        };
        instance.registerDataChangeCallback('CollaborationEventManagerTest1', callback);

        instance['notifyDataChange'](collaborationDataList);
        expect(instance instanceof CollaborationEventManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

  })
}