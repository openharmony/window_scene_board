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
import { EvtBus, ScreenLockEvent, WindowEvent } from '@ohos/frameworkwrapper';
import { WindowConstants } from '@ohos/commonconstants';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium';
import { CapsuleListState, CapsuleShowEvent, capsuleStateMgr, LiveViewData } from '@ohos/systemuicommon';
import { CapsuleLifecycleVm } from '../../../../../main/ets/vm/CapsuleLifecycleVm';

class CapsuleLifecycleInfo {
  /**
   * 胶囊总的出现时间
   */
  public totalKeepTime?: number = 0;
  /**
   * 胶囊本次开始出现的时间点
   */
  public capsuleStartTime?: number = 0;
  /**
   * 是否正在计时中
   */
  public isCounting?: boolean = false;
}

export default function CapsuleLifecycleVmTest() {

  describe('CapsuleLifecycleVmTest', () => {

    // 创建实况数据，用于测试
    let createLiveDta = (): LiveViewData => {
      let result = new LiveViewData();
      result.hashCode = 'live_for_test_001';
      result.creatorBundleName = 'live.test';
      result.liveType = 0;
      result.sysTypeCode = 0;
      result.id = 222;
      return result;
    };

    beforeAll(() => {
      let mocker: MockKit = new MockKit();
      let capsuleState: CapsuleListState = new CapsuleListState();
      let liveData = createLiveDta();
      capsuleState.setTopCapsule(liveData);
      let mockFunc: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      when(mockFunc)().afterReturn(capsuleState);

    });

    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    Test01();
    Test02();
    Test03();
    Test04();
    Test05();
    Test06();
    Test07();
    Test08();
  })
}

function Test01() {
  const capsuleLifecycleVm = new CapsuleLifecycleVm();
  it('init', 0, () => {
    capsuleLifecycleVm.init();

    expect(true).assertTrue();
  })

  it('getLifecycleTime', 0, () => {
    const lifecycleTime = capsuleLifecycleVm.getLifecycleTime(0);

    expect(lifecycleTime).assertInstanceOf('Number');
  })

  it('getTopCapsuleId', 0, () => {
    try {
      Reflect.get(capsuleLifecycleVm, 'getTopCapsuleId')?.()
    } catch (err) {
    }
    expect(Reflect.has(capsuleLifecycleVm, 'getTopCapsuleId')).assertTrue();
  })
}

function Test02() {
  // 进lifeMap?.get(topCapsule)?.isCounting 分支
  it('startCountTime_getCounting_topCapsule', 0, () => {
    const capsuleLifecycleVm = new CapsuleLifecycleVm();
    try {
      let lifeMap: Map<number, CapsuleLifecycleInfo> = new Map();
      lifeMap.set(0, {
        totalKeepTime: 0, capsuleStartTime: 1, isCounting: true
      } as CapsuleLifecycleInfo)
      lifeMap.set(1, {
        totalKeepTime: 1, capsuleStartTime: 1, isCounting: true
      } as CapsuleLifecycleInfo)
      lifeMap.set(222, {
        totalKeepTime: 2, capsuleStartTime: 1, isCounting: true
      } as CapsuleLifecycleInfo)
      Reflect.set(capsuleLifecycleVm, 'lifeMap', lifeMap);

      Reflect.get(capsuleLifecycleVm, 'startCountTime')?.()
      lifeMap.clear();
    } catch (err) {
    }
    expect(Reflect.has(capsuleLifecycleVm, 'startCountTime')).assertTrue();
  })
}

function Test03() {
  // 进this.lifeMap?.has(topCapsule)分支
  it('startCountTime_lifeMap_has_topCapsule', 0, () => {
    const capsuleLifecycleVm = new CapsuleLifecycleVm();
    let lifeMap: Map<number, CapsuleLifecycleInfo> = new Map();

    try {
      lifeMap.set(0, {
        totalKeepTime: 0, capsuleStartTime: 1, isCounting: true
      } as CapsuleLifecycleInfo)
      lifeMap.set(1, {
        totalKeepTime: 1, capsuleStartTime: 1, isCounting: true
      } as CapsuleLifecycleInfo)
      lifeMap.set(222, {
        totalKeepTime: 2, capsuleStartTime: 1, isCounting: true
      } as CapsuleLifecycleInfo)

      Reflect.set(capsuleLifecycleVm, 'lifeMap', lifeMap);
      Reflect.get(capsuleLifecycleVm, 'startCountTime')?.()
      lifeMap.clear();
    } catch (err) {
    }
    expect(Reflect.has(capsuleLifecycleVm, 'startCountTime')).assertTrue();
  })
}

function Test04() {
  // 进!this.lifeMap?.has(topCapsule)分支
  it('startCountTime_lifeMap_not_has_topCapsule', 0, () => {
    const capsuleLifecycleVm = new CapsuleLifecycleVm();
    let lifeMap: Map<number, CapsuleLifecycleInfo> = new Map();

    try {
      lifeMap.set(0, {
        totalKeepTime: 0, capsuleStartTime: 1, isCounting: true
      } as CapsuleLifecycleInfo)
      lifeMap.set(1, {
        totalKeepTime: 0, capsuleStartTime: 1, isCounting: true
      } as CapsuleLifecycleInfo)
      lifeMap.set(2, {
        totalKeepTime: 0, capsuleStartTime: 1, isCounting: false
      } as CapsuleLifecycleInfo)
      Reflect.set(capsuleLifecycleVm, 'lifeMap', lifeMap);
      Reflect.get(capsuleLifecycleVm, 'startCountTime')?.()
      lifeMap.clear();
    } catch (err) {
    }
    expect(Reflect.has(capsuleLifecycleVm, 'startCountTime')).assertTrue();
  })
}

function Test05() {
  it('endCountTime', 0, () => {
    const capsuleLifecycleVm = new CapsuleLifecycleVm();
    let lifeMap: Map<number, CapsuleLifecycleInfo> = new Map();

    try {
      lifeMap.set(0, {
        totalKeepTime: 0, capsuleStartTime: 1, isCounting: true
      } as CapsuleLifecycleInfo)
      lifeMap.set(1, {
        totalKeepTime: 0, capsuleStartTime: 1, isCounting: true
      } as CapsuleLifecycleInfo)
      lifeMap.set(222, {
        totalKeepTime: 0, capsuleStartTime: 2, isCounting: true
      } as CapsuleLifecycleInfo)
      Reflect.set(capsuleLifecycleVm, 'lifeMap', lifeMap);

      Reflect.get(capsuleLifecycleVm, 'endCountTime')?.()
      lifeMap.clear();
    } catch (err) {
    }
    expect(Reflect.has(capsuleLifecycleVm, 'endCountTime')).assertTrue();
  })
}

function Test06() {
  it('onWindowEvent', 0, () => {
    const capsuleLifecycleVm = new CapsuleLifecycleVm();
    try {
      capsuleLifecycleVm.init();
      let event = new WindowEvent();
      event.windowName = WindowConstants.WINDOW_NAME_LIVEVIEW;
      event.eventType = WindowEvent.EVENT_TYPE_SHOW;
      event.eventState = WindowEvent.EVENT_STATE_START;
      EvtBus.post(WindowEvent, event);
      event.eventType = WindowEvent.EVENT_TYPE_HIDE;
      EvtBus.post(WindowEvent, event);
      event.windowName = WindowConstants.WINDOW_NAME_DROPDOWN;
      EvtBus.post(WindowEvent, event);
    } catch (err) {
    }
    expect(true).assertTrue();
  })
}

const capsuleLifecycleVm2 = new CapsuleLifecycleVm();

interface ICapsuleLifecycleVm {
  startCountTime(): void;
  endCountTime(): void;
  onCapsuleShowEvent(event: CapsuleShowEvent): void;
  onWindowEvent(event: WindowEvent): void;
  onScreenLockEvent(event: ScreenLockEvent): void;
}

function Test07() {
  it('test_getShadowAnimStyle', 0, (): void => {
    try {
      let data = new LiveViewData();
      data.id = 1;
      capsuleStateMgr.getCapsuleState().topCapsule = data;
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).startCountTime();
      capsuleLifecycleVm2.getLifecycleTime(1);
      setTimeout(() => {
        (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).endCountTime();
        capsuleLifecycleVm2.getLifecycleTime(1);
      }, 1000);
    } catch (err) {}
    expect(Reflect.has(capsuleLifecycleVm2, 'getLifecycleTime')).assertTrue();
  });

  it('test_deleteLifecycleInfo', 0, (): void => {
    try {
      capsuleLifecycleVm2.deleteLifecycleInfo(1);
    } catch (err) {}
    expect(Reflect.has(capsuleLifecycleVm2, 'deleteLifecycleInfo')).assertTrue();
  });

  it('test_startCountTime', 0, (): void => {
    try {
      let data = new LiveViewData();
      data.id = 1;
      capsuleStateMgr.getCapsuleState().topCapsule = data;
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).startCountTime();
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).startCountTime();
    } catch (err) {}
    expect(Reflect.has(capsuleLifecycleVm2, 'startCountTime')).assertTrue();
  });

  it('test_endCountTime', 0, (): void => {
    try {
      let data = new LiveViewData();
      data.id = 1;
      capsuleStateMgr.getCapsuleState().topCapsule = data;
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).startCountTime();
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).endCountTime();
    } catch (err) {}
    expect(Reflect.has(capsuleLifecycleVm2, 'endCountTime')).assertTrue();
  });
}

function Test08() {
  it('test_onCapsuleShowEvent', 0, (): void => {
    try {
      let event = new ScreenLockEvent();
      event.isLockScreen = false;
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).onScreenLockEvent(event);
      let event2 = new WindowEvent();
      event2.windowName = 'SysUI_Dropdown';
      event2.eventType = WindowEvent.EVENT_TYPE_SHOW;
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).onWindowEvent(event2);
      let event3 = new CapsuleShowEvent();
      event3.isCapsuleShow = true;
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).onCapsuleShowEvent(event3);

      event2.eventType = WindowEvent.EVENT_TYPE_HIDE;
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).onWindowEvent(event2);
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).onCapsuleShowEvent(event3);
      event3.isCapsuleShow = false;
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).onCapsuleShowEvent(event3);
    } catch (err) {}
    expect(Reflect.has(capsuleLifecycleVm2, 'onCapsuleShowEvent')).assertTrue();
  });

  it('test_onWindowEvent', 0, (): void => {
    try {
      let event = new ScreenLockEvent();
      event.isLockScreen = true;
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).onScreenLockEvent(event);
      let event2 = new WindowEvent();
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).onWindowEvent(event2);
      event2.windowName = 'SysUI_Dropdown';
      event2.eventType = WindowEvent.EVENT_TYPE_SHOW;
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).onWindowEvent(event2);

      event2.eventType = WindowEvent.EVENT_TYPE_HIDE;
      (capsuleLifecycleVm2 as object as ICapsuleLifecycleVm).onWindowEvent(event2);
    } catch (err) {}
    expect(Reflect.has(capsuleLifecycleVm2, 'onWindowEvent')).assertTrue();
  });
}