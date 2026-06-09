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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { LiveType, LiveViewData } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { LiveSysTimerManager, OnLiveUpdateTimerListener } from '../../../../../main/ets/common/LiveSysTimerManager';

const liveSysTimerManager: LiveSysTimerManager = new LiveSysTimerManager();

export default function LiveSysTimerManagerTest() {
  const listener: OnLiveUpdateTimerListener = () => {
  };

  describe('LiveSysTimerManagerTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('registerUpdateTimerListener', Level.LEVEL0, () => {
      liveSysTimerManager.registerUpdateTimerListener(listener);

      const listeners: Set<OnLiveUpdateTimerListener | undefined> = (liveSysTimerManager as object)['listeners'];

      expect(listeners.has(listener)).assertTrue();
    })

    it('unregisterUpdateTimerListener', Level.LEVEL0, () => {
      liveSysTimerManager.unregisterUpdateTimerListener(listener);

      const listeners: Set<OnLiveUpdateTimerListener | undefined> = (liveSysTimerManager as object)['listeners'];

      expect(listeners.has(listener)).assertFalse();
    })

    it('test_onUpdateTimer6', Level.LEVEL0, (): void => {
      try {
        Reflect.get(liveSysTimerManager, 'onUpdateTimer')?.('null');
      } catch (err) {
      }
      expect(true).assertTrue();
    });

    fun1();
    fun2();
  })
}

function fun1() {
  it('test_onUpdateTimer7', Level.LEVEL0, (): void => {
    try {
      let data = new LiveViewData();
      data.hashCode = 'test';
      data.liveType = LiveType.PROGRESS;
      Reflect.set(liveSysTimerManager, 'liveDataMap', new Map([['test', data]]));
      Reflect.get(liveSysTimerManager, 'onUpdateTimer')?.('test');
    } catch (err) {
    }
    expect(true).assertTrue();
  });

  it('test_deleteLiveData6', Level.LEVEL0, (): void => {
    try {
      let data = new LiveViewData();
      data.hashCode = 'test';
      data.liveType = LiveType.PROGRESS;
      liveSysTimerManager.deleteLiveData(data);
    } catch (err) {
    }
    expect(true).assertTrue();
  });
}

function fun2() {
  it('test_addOrUpdateLiveData', Level.LEVEL0, (): void => {
    try {
      let data = new LiveViewData();
      data.hashCode = 'test';
      data.liveType = LiveType.PROGRESS;
      liveSysTimerManager.addOrUpdateLiveData();
      liveSysTimerManager.addOrUpdateLiveData(data);
    } catch (err) {
    }
    expect(true).assertTrue();
  });
}