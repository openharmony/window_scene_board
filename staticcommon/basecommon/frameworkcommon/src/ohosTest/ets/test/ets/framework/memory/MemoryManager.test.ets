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
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { MemoryUtils } from '@hw-ohos/memorytool';
import { MemoryManager, TrimScene } from '../../../../../../main/ets/memory/MemoryManager';
import { DEFAULT_PSS_DECIDER } from '../../../../../../main/ets/memory/GcDecider';
import {
  GcMonitorStrategy,
  StrategyFactory,
  TrimStrategy
} from '../../../../../../main/ets/memory/StrategyFactory';
import {
  ViewCallback,
  viewMgrPolicy,
  ViewType,
  TrimLevel
} from '@ohos/frameworkwrapper';
import { BaseViewController } from '../../../../../../main/ets/manager/view/BaseViewController';

export function MemoryManagerTest() {
  describe('MemoryManagerTest', () => {
    class DtViewCallback implements ViewCallback {
      onTrimMemory() {
      }
    }

    let desktopCallback: DtViewCallback = new DtViewCallback();
    let appCenterCallback: DtViewCallback = new DtViewCallback()
    beforeAll((): void => {
      globalThis.MemoryManager = null;
      MemoryManager.getInstance();
      viewMgrPolicy.registerViewController(ViewType.SHUTDOWN_VIEW, new BaseViewController(ViewType.SHUTDOWN_VIEW));
      viewMgrPolicy.registerViewCallback(ViewType.SHUTDOWN_VIEW, desktopCallback);
      viewMgrPolicy.registerViewCallback(ViewType.APP_CENTER, appCenterCallback);
    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('initStrategyMaps', 0, () => {
      MemoryManager.getInstance().initManager(null);
      expect(MemoryManager.getInstance().isInitFinished()).assertInstanceOf('Boolean');
      MemoryManager.getInstance().initManager(new DTStrategyFactory())
      expect(MemoryManager.getInstance().isInitFinished()).assertTrue();
    })

    it('test_checkTrimMemory1', 0, () => {
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(desktopCallback, desktopCallback.onTrimMemory);
      MemoryManager.getInstance().notifyClearRecentMissions();
      expect(MemoryManager.getInstance()['gcStrategyMap'].size).assertLargerOrEqual(0);
      mocker.clear(desktopCallback);
      mocker.clearAll();
    })
  })
}

class DTStrategyFactory extends StrategyFactory {
  protected buildTrimStrategies(): Array<TrimStrategy> {
    let array: Array<TrimStrategy> = new Array<TrimStrategy>();
    array.push(new TrimStrategy(ViewType.SHUTDOWN_VIEW, TrimScene.CLEAR_MISSION, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.SHUTDOWN_VIEW, TrimScene.OPEN_APP, TrimLevel.COMPLETE));
    array.push(new TrimStrategy(ViewType.APP_CENTER, TrimScene.CLEAR_MISSION, TrimLevel.COMPLETE));
    return array;
  }

  protected buildGcMonitorStrategies(): Array<GcMonitorStrategy> {
    let array: Array<GcMonitorStrategy> = new Array<GcMonitorStrategy>();
    array.push(new GcMonitorStrategy(TrimScene.OPEN_APP, DEFAULT_PSS_DECIDER));
    return new Array<GcMonitorStrategy>();
  }
}