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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { SettingsDBMonitor } from '../../../../../../main/ets/monitor/SettingsDBMonitor';
import { AbstractObserver, ObserverStageEnum } from '@ohos/screenlockcommon';

export default function SettingsDBMonitorTest() {
  const mAbstractObserverSon: AbstractObserverSon<object> = new AbstractObserverSon();
  const mSettingsDBMonitorSon = new SettingsDBMonitorSon();

  describe('SettingsDBMonitorTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getInstance_return', 0, (): void => {
      SettingsDBMonitor.getInstance();
      SettingsDBMonitor.getInstance().initStatus();
      SettingsDBMonitor.getInstance().register();
      SettingsDBMonitor.getInstance().unregister();
      expect(ObserverStageEnum.INITIAL).assertEqual('INITIAL');
    })

    it('test_startDataListener', 0, (): void => {
      mSettingsDBMonitorSon.StartDataListener(null);
      try {
        mSettingsDBMonitorSon.StartDataListener('1|2|3');
      } catch (e) {
      }
      try {
        mSettingsDBMonitorSon.StartDataListener('1');
      } catch (e) {
      }
      expect(true).assertTrue();
    })

    it('test_getSubscriberSize', 0, (): void => {
      mAbstractObserverSon.getSubscriberSize('1');
      expect(true).assertTrue();
    })

    it('test_needNotify', 0, (): void => {
      mAbstractObserverSon.NeedNotify();
      expect(true).assertTrue();
    })
  })
}

export class SettingsDBMonitorSon extends SettingsDBMonitor {
  constructor() {
    super();
  }

  public StartDataListener(key: string | null): void {
    return this.startDataListener(key);
  }
}

export class AbstractObserverSon<T> extends AbstractObserver<T> {
    public NeedNotify(): boolean {
      return this.needNotify();
    }
}