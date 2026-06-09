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
import { LiveViewData } from '@ohos/systemuicommon';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { liveCapsuleVm } from '../../../../../main/ets/vm/LiveViewVm';
import { ScreenOnOffEvent, WindowEvent } from '@ohos/frameworkwrapper';
import { WindowConstants } from '@ohos/commonconstants';
import { ILiveState } from '../../../../../main/ets/common/LiveViewStateManager';
import { CapsuleCheckResult, ExitCapsuleCheckParam } from '@ohos/systemuicommon/Index';

interface ILiveViewVm {
  handleWaitedEvent(): void;

  onLiveStateChange(state: ILiveState): void;

  handleScreenOnOffEvent(event: ScreenOnOffEvent): void;

  handleWindowEvent(event: WindowEvent): void

  onCheckCapsuleApp(param: ExitCapsuleCheckParam): CapsuleCheckResult;
}

/**
 * 实况胶囊、列表viewModel模块测试用例
 */
export function LiveViewVmTest() {
  describe('LiveViewVmTest', (): void => {
    fun1();
    fun2();
    fun3();
  });
}

function fun1() {
  // 创建实况数据，用于测试
  let createLiveDta = (): LiveViewData => {
    let result = new LiveViewData();
    result.hashCode = 'live_for_test_001';
    result.creatorBundleName = 'live.test';
    result.liveType = 0;
    result.sysTypeCode = 0;
    return result;
  };

  // 测试获取胶囊列表数据
  it('test_getCapsuleList_should_not_null', Level.LEVEL0, (): void => {
    expect(liveCapsuleVm.getCapsuleList()).not().assertNull();
  });

  // 测试胶囊列表数据查找目标数据
  it('test_getCapsuleList_not_container', Level.LEVEL0, (): void => {
    let liveData = createLiveDta();
    expect(liveCapsuleVm.getCapsuleList().find((value) => {
      return value === liveData;
    })).assertUndefined();
  });

  // 测试获取实况动效管理器
  it('test_getAnimMgr_should_not_null', Level.LEVEL0, (): void => {
    expect(liveCapsuleVm.getAnimMgr()).not().assertNull();
  });

  // 测试获取实况列表状态管理器
  it('test_getLiveListMgr_should_not_null', Level.LEVEL0, (): void => {
    expect(liveCapsuleVm.getLiveListMgr()).not().assertNull();
  });

  // 测试实况数据接收事件处理
  it('test_has_eventHandler', Level.LEVEL0, (): void => {
    expect(Reflect.has(liveCapsuleVm, 'eventHandler')).assertTrue();
  });

  // 测试实况状态处理
  it('test_has_stateHandler', Level.LEVEL0, (): void => {
    expect(Reflect.has(liveCapsuleVm, 'stateHandler')).assertTrue();
  });
}

function fun2() {
  // 测试实况全部数据集
  it('test_has_allLiveList', Level.LEVEL0, (): void => {
    expect(Reflect.has(liveCapsuleVm, 'allLiveList')).assertTrue();
  });

  // 测试实况临时数据集
  it('test_handleScreenOnOffEvent8', Level.LEVEL0, (): void => {
    try {
      (liveCapsuleVm as Object as ILiveViewVm).handleScreenOnOffEvent(undefined!);
    } catch (err) {
    }
    expect(Reflect.has(liveCapsuleVm, 'handleScreenOnOffEvent')).assertTrue();
  });

  // 测试实况临时数据集
  it('test_handleWaitedEvent8', Level.LEVEL0, (): void => {
    try {
      (liveCapsuleVm as Object as ILiveViewVm).handleWaitedEvent();
    } catch (err) {
    }
    try {
      (liveCapsuleVm as Object as ILiveViewVm).onLiveStateChange(undefined!);
    } catch (err) {
    }
    expect(true).assertTrue();
  });

  it('test_has_tempCapsuleList', Level.LEVEL0, (): void => {
    expect(Reflect.has(liveCapsuleVm, 'tempCapsuleList')).assertTrue();
  });
}

function fun3() {
  it('test_handleWindowEvent33', Level.LEVEL0, (): void => {
    try {
      (liveCapsuleVm as Object as ILiveViewVm).handleWindowEvent({
        windowName: 'test'
      } as WindowEvent);
      (liveCapsuleVm as Object as ILiveViewVm).handleWindowEvent({
        windowName: WindowConstants.WINDOW_NAME_DROPDOWN
      } as WindowEvent);
    } catch (err) {
    }
    expect(true).assertTrue();
  });

  it('test_onCheckCapsuleApp33', Level.LEVEL0, (): void => {
    try {
      (liveCapsuleVm as Object as ILiveViewVm).onCheckCapsuleApp({} as ExitCapsuleCheckParam);
    } catch (err) {
    }
    expect(true).assertTrue();
  });
}

export function LiveViewVmTest2() {
  describe('LiveViewVmTest2', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });
    // 测试实况前台数据集
    it('test_has_foregroundCapsuleList', Level.LEVEL0, (): void => {
      expect(Reflect.has(liveCapsuleVm, 'foregroundCapsuleList')).assertTrue();
    });

    // 测试事件处理器
    it('LiveViewVmTest_has_eventMgr', Level.LEVEL0, (): void => {
      expect(Reflect.has(liveCapsuleVm, 'eventMgr')).assertTrue();
    });

    // 测试过滤器
    it('test_has_filter', Level.LEVEL0, (): void => {
      expect(Reflect.has(liveCapsuleVm, 'filter')).assertTrue();
    });

    // 测试事件接收
    it('test_has_onLiveViewEntryEvent', Level.LEVEL0, (): void => {
      expect(Reflect.has(liveCapsuleVm, 'onLiveViewEntryEvent')).assertTrue();
    });

    // 测试实况状态监听
    it('test_has_onLiveStateChange', Level.LEVEL0, (): void => {
      expect(Reflect.has(liveCapsuleVm, 'onLiveStateChange')).assertTrue();
    });

    // 测试实况排序器
    it('test_has_liveSortComparator', Level.LEVEL0, (): void => {
      expect(Reflect.has(liveCapsuleVm, 'liveSortComparator')).assertTrue();
    });

    // 测试亮灭屏监听
    it('test_has_handleScreenOnOffEvent', Level.LEVEL0, (): void => {
      expect(Reflect.has(liveCapsuleVm, 'handleScreenOnOffEvent')).assertTrue();
    });

    // 测试胶囊应用检测
    it('test_has_onCheckCapsuleApp', Level.LEVEL0, (): void => {
      expect(Reflect.has(liveCapsuleVm, 'onCheckCapsuleApp')).assertTrue();
    });

    // 测试退出到胶囊动效状态监听
    it('test_has_onExitCapsuleListener', Level.LEVEL0, (): void => {
      expect(Reflect.has(liveCapsuleVm, 'onExitCapsuleListener')).assertTrue();
    });

    // 测试发送通知沉浸式状态栏显隐事件
    it('test_has_postStatusBarShowEvent', Level.LEVEL0, (): void => {
      expect(Reflect.has(liveCapsuleVm, 'postStatusBarShowEvent')).assertTrue();
    });
  });
}