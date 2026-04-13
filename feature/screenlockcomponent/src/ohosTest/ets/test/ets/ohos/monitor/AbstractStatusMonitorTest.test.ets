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
import { BaseStatusMonitor } from '@ohos/screenlockcommon/src/main/ets/monitor/AbstractStatusMonitor';

export default function AbstractStatusMonitorTest() {
  const mBaseStatusMonitorSon = new BaseStatusMonitorSon<Object>()

  describe('AbstractStatusMonitorTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_init', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mBaseStatusMonitorSon.init();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_initEmptyStatus', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mBaseStatusMonitorSon.InitEmptyStatus();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_registerListener', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mBaseStatusMonitorSon.registerListener();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_unregisterListener', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mBaseStatusMonitorSon.unregisterListener();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_handleStatusChange', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mBaseStatusMonitorSon.HandleStatusChange(undefined,() => {});
      mBaseStatusMonitorSon.HandleStatusChange(undefined, undefined);
      mBaseStatusMonitorSon.HandleStatusChange(undefined, undefined);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })
  })
}

export class BaseStatusMonitorSon<T> extends BaseStatusMonitor<T> {
  public flag: boolean = false

  public initStatus(): void {
  };

  public register(): void {
  };

  public unregister(): void {
  };

  public InitEmptyStatus() {
    return this.initEmptyStatus();
  }

  public HandleStatusChange(data?: T, specialHandleFunc?: Function) {
    return this.handleStatusChange(data, specialHandleFunc);
  }

  public needNotify(): boolean {
    this.flag = !this.flag
    return this.flag
  }
}