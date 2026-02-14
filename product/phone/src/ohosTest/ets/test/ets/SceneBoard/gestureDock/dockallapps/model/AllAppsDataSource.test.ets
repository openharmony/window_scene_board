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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import {
  AllAppsDataSource
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/model/AllAppsDataSource';
import {
  GestureDockItemInfo
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/model/GestureDockItemInfo';

export default function AllAppsDataSourceTest() {
  describe('AllAppsDataSourceTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
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

    it('should_return_dataSource_length_when_dataSource_is_not_null', 0, () => {
      let dataList: GestureDockItemInfo[] = [new GestureDockItemInfo(), new GestureDockItemInfo()];
      let allAppsDatasource: AllAppsDataSource = new AllAppsDataSource(dataList);
      const result = allAppsDatasource.totalCount();
      expect(result).assertEqual(dataList.length);
    });

    it('should_return_GestureDockItemInfo_when_index_is_valid', 0, () => {
      let mocker: MockKit = new MockKit();
      let allAppsDatasource: AllAppsDataSource = new AllAppsDataSource([]);
      let mockFunc: Function = mocker.mockFunc(allAppsDatasource, allAppsDatasource.totalCount);
      when(mockFunc)().afterReturn(10);
      const result = allAppsDatasource.getData(5);
      expect(result === undefined).assertTrue();
      mocker.ignoreMock(allAppsDatasource, allAppsDatasource.totalCount);
    });

    it('should_return_new_GestureDockItemInfo_when_index_is_invalid', 0, () => {
      let mocker: MockKit = new MockKit();
      let allAppsDatasource: AllAppsDataSource = new AllAppsDataSource([]);
      let mockFunc: Function = mocker.mockFunc(allAppsDatasource, allAppsDatasource.totalCount);
      when(mockFunc)().afterReturn(10);
      const result = allAppsDatasource.getData(15);
      expect(result !== undefined).assertTrue();
      mocker.ignoreMock(allAppsDatasource, allAppsDatasource.totalCount);
    });

    it('should_return_immediately_when_listener_already_exists', 0, () => {
      let gestureDockItemInfoList: GestureDockItemInfo[] = [];
      let allAppsDatasource: AllAppsDataSource = new AllAppsDataSource(gestureDockItemInfoList);
      let listener: DataChangeListener = {
        onDataReloaded: () => {
        }
      } as DataChangeListener;
      allAppsDatasource.registerDataChangeListener(listener);
      allAppsDatasource.registerDataChangeListener(listener);
      expect((allAppsDatasource as object)['dataChangeListeners'].length).assertEqual(1);
    });

    it('should_add_listener_when_listener_does_not_exist_yet', 0, () => {
      let gestureDockItemInfoList: GestureDockItemInfo[] = [];
      let allAppsDatasource: AllAppsDataSource = new AllAppsDataSource(gestureDockItemInfoList);
      let listener: DataChangeListener = {
        onDataReloaded: () => {
        }
      } as DataChangeListener;
      allAppsDatasource.registerDataChangeListener(listener);
      expect((allAppsDatasource as object)['dataChangeListeners'].length).assertEqual(1);
    });

    it('should_remove_listener_when_listener_exists', 0, () => {
      let listener: DataChangeListener = {
        onDataReloaded: () => {
        }
      } as DataChangeListener;
      let allAppsDatasource: AllAppsDataSource = new AllAppsDataSource([]);
      (allAppsDatasource as object)['dataChangeListeners'].push(listener);
      allAppsDatasource.unregisterDataChangeListener(listener);
      expect((allAppsDatasource as object)['dataChangeListeners'].length).assertEqual(0);
    });

    it('should_do_nothing_when_listener_does_not_exist', 0, () => {
      let listener: DataChangeListener = {
        onDataReloaded: () => {
        }
      } as DataChangeListener;
      let allAppsDatasource: AllAppsDataSource = new AllAppsDataSource([]);
      allAppsDatasource.unregisterDataChangeListener(listener);
      expect((allAppsDatasource as object)['dataChangeListeners'].length).assertEqual(0);
    });
  });
}