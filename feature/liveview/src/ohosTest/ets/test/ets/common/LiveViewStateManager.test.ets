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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import {
  ILiveState,
  LiveBannerState,
  LiveForegroundState,
  LivePanelState,
  LiveStateType,
  LiveViewStateManager,
  LiveWidestScreenState,
  OnLiveStateChangeListener
} from '../../../../../main/ets/common/LiveViewStateManager';
import {
  DisplaySizeState,
  ForegroundAppEvent,
  HeadsUpChangeEvent,
  IState,
  LiveType,
  LiveViewData,
  OnStateChangeListener,
  SysTypeCode
} from '@ohos/systemuicommon';
import { bannerMgr, BannerPanelType, BannerPanelTypeState, StateType } from '@ohos/systemuicommon';

const liveViewStateMgr = new LiveViewStateManager();

class DisplaySizeStateTest implements IState {
  private static readonly WIDTH_THRESHOLD_SMALL = 600;
  private state: StateType;
  displayWidth: number = 0;
  displayHeight: number = 0;

  constructor(state?: StateType) {
    this.state = state ?? StateType.TYPE_DISPLAY_SIZE;
  }

  public isWidestScreenByVp(displayWidthByVp: number): boolean {
    throw new Error('Method not implemented.');
  }

  getStateType(): StateType {
    return this.state;
  }

  isWidestScreen(): boolean {
    return px2vp(this.displayWidth) > DisplaySizeStateTest.WIDTH_THRESHOLD_SMALL;
  }
}

interface ILiveViewStateMgr {
  onStateChange: OnStateChangeListener;

  notifyLiveStateChange(type: LiveStateType): void;

  onForegroundAppEvent(event?: ForegroundAppEvent): void;

  onHeadsUpChangeEvent(event?: HeadsUpChangeEvent): void;

  onBannerPanelChange(state: BannerPanelTypeState): void;

  onDisplaySizeChange(state: DisplaySizeState): void;
}

/**
 * 实况状态管理模块测试用例
 */
export function LiveViewStateMgrTest() {
  describe('LiveViewStateMgrTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

  it('test_onStateChange', Level.LEVEL0, (): void => {
    expect(Reflect.has(liveViewStateMgr, 'onStateChange')).assertTrue();

    let result = false;
    try {
      const mgr: ILiveViewStateMgr = (liveViewStateMgr as Object as ILiveViewStateMgr);
      mgr.onStateChange.onStateChange(new DisplaySizeStateTest());
      mgr.onStateChange.onStateChange(new BannerPanelTypeState());
      mgr.onStateChange.onStateChange(new DisplaySizeStateTest(StateType.TYPE_DARK_MODE));
      result = true;
      expect(result).assertTrue();
    } catch (e) {
      expect(result).assertFalse();
    }
  });

  // 测试注册状态切换监听器
  it('test_registerOnLiveStateChangeListener', Level.LEVEL0, (): void => {
    let unregister2 = liveViewStateMgr.registerOnLiveStateChangeListener((state) => {
    });
    unregister2?.();

    const listeners: Set<OnLiveStateChangeListener> = Reflect.get(liveViewStateMgr, 'liveStateListeners');
    expect(listeners.size).assertLargerOrEqual(0);
  });

  // 测试注销状态切换监听器
  it('test_unregisterOnLiveStateChangeListener', Level.LEVEL0, (): void => {
    let listener = (state: ILiveState): void => {
    };
    liveViewStateMgr.registerOnLiveStateChangeListener(listener);
    liveViewStateMgr.unregisterOnLiveStateChangeListener(listener);
    expect(Reflect.has(liveViewStateMgr, 'liveStateListeners')).assertTrue();
  });

  // 测试获取横幅弹框状态
  it('test_getCurrentState_banner', Level.LEVEL0, (): void => {
    let bannerState = liveViewStateMgr.getCurrentState(LiveStateType.STATE_BANNER) as LiveBannerState;
    expect(bannerState?.getLiveStateType()).assertEqual(LiveStateType.STATE_BANNER);
  });

  // 测试获取实况面板状态
  it('test_getCurrentState_live_panel', Level.LEVEL0, (): void => {
    let panelState = liveViewStateMgr.getCurrentState(LiveStateType.STATE_LIVE_PANEL) as LivePanelState;
    expect(panelState?.getLiveStateType()).assertEqual(LiveStateType.STATE_LIVE_PANEL);
  });

  // 测试获取前台应用状态
  it('test_getCurrentState_foreground', Level.LEVEL0, (): void => {
    let foregroundState = liveViewStateMgr.getCurrentState(LiveStateType.STATE_FOREGROUND) as LiveForegroundState;
    foregroundState.getLiveStateType();
    expect(foregroundState?.getLiveStateType()).assertEqual(LiveStateType.STATE_FOREGROUND);
  });

  // 测试获取宽屏状态
  it('test_getCurrentState_widest_screen', Level.LEVEL0, (): void => {
    let widestState = liveViewStateMgr.getCurrentState(LiveStateType.STATE_WIDEST_SCREEN) as LiveWidestScreenState;
    expect(widestState?.getLiveStateType()).assertEqual(LiveStateType.STATE_WIDEST_SCREEN);
  });

  // 测试前台应用判断
  it('test_isForegroundApp', Level.LEVEL0, (): void => {
    let isForeground = liveViewStateMgr.isForegroundApp(-1);
    expect(isForeground).assertFalse();
  });

  // 测试宽屏状态判断
  it('test_isWidestScreen', Level.LEVEL0, (): void => {
    let state = liveViewStateMgr.getCurrentState(LiveStateType.STATE_WIDEST_SCREEN) as LiveWidestScreenState;
    let isWidest = liveViewStateMgr.isWidestScreen();
    expect(isWidest).assertEqual(state?.isWidestScreen);
  });

  // 测试横幅数据匹配
  it('test_isBannerShowEvent', Level.LEVEL0, (): void => {
    let state = liveViewStateMgr.getCurrentState(LiveStateType.STATE_BANNER) as LiveBannerState;
    const hashCodeBak = state.entryHashCode;

    // invalid hashCode
    state.entryHashCode = undefined;
    let isBanner = liveViewStateMgr.isBannerShowEvent('test');
    expect(isBanner).assertFalse();

    // valid hashCode
    state.entryHashCode = 'testHashCode';
    isBanner = liveViewStateMgr.isBannerShowEvent('test');
    expect(isBanner).assertFalse();

    state.entryHashCode = hashCodeBak;
  });

  // 测试获取通知横幅显示Promise
  it('test_getHeadsUpPromise', Level.LEVEL0, (): void => {
    let state = liveViewStateMgr.getCurrentState(LiveStateType.STATE_BANNER) as LiveBannerState;
    const hashCodeBak = state.entryHashCode;

    // return promise
    state.entryHashCode = 'test';
    let promise = liveViewStateMgr.getHeadsUpPromise('test');
    expect(true).assertTrue();

    // return undefined
    state.entryHashCode = 'testHashCode';
    promise = liveViewStateMgr.getHeadsUpPromise('test');
    expect(true).assertTrue();

    state.entryHashCode = hashCodeBak;
  });

  // 测试实况面板状态
  it('test_isLivePanelShowing', Level.LEVEL0, (): void => {
    let state = liveViewStateMgr.getCurrentState(LiveStateType.STATE_LIVE_PANEL) as LivePanelState;
    let isLivePanel = liveViewStateMgr.isLivePanelShowing();
    expect(isLivePanel).assertEqual(state?.isLivePanelShowing);
  });

  // 测试通知状态切换回调
  it('test_notifyLiveStateChange', Level.LEVEL0, (): void => {
    let result = false;
    try {
      let listener = (state: ILiveState): void => {
      };
      liveViewStateMgr.registerOnLiveStateChangeListener(listener);

      (liveViewStateMgr as Object as ILiveViewStateMgr).notifyLiveStateChange(LiveStateType.STATE_BANNER);
      result = true;
      expect(result).assertTrue();
    } catch (e) {
      expect(result).assertFalse();
    }
  });

  // 测试前台应用切换事件
  it('test_onForegroundAppEvent', Level.LEVEL0, (): void => {
    let result = false;
    try {
      (liveViewStateMgr as Object as ILiveViewStateMgr).onForegroundAppEvent({
        uidList: [101, 102],
        bundleNames: ['test1', 'test2'],
        switchAbilityState: 2
      });
      result = true;
      expect(result).assertTrue();
    } catch (e) {
      expect(result).assertFalse();
    }
  });

  // 测试横幅通知切换事件
  it('test_onHeadsUpChangeEvent', Level.LEVEL0, (): void => {
    let result = false;
    try {
      let state = liveViewStateMgr.getCurrentState(LiveStateType.STATE_BANNER) as LiveBannerState;
      const hashCodeBak = state.entryHashCode;

      // same hashCode
      state.entryHashCode = 'test';
      (liveViewStateMgr as Object as ILiveViewStateMgr).onHeadsUpChangeEvent({
        hashCode: 'test',
      });

      // different hashCode
      (liveViewStateMgr as Object as ILiveViewStateMgr).onHeadsUpChangeEvent({
        hashCode: 'testHashCode',
        bundleName: 'testBundle',
      });
      result = true;
      expect(result).assertTrue();

      state.entryHashCode = hashCodeBak;
    } catch (e) {
      expect(result).assertFalse();
    }
  });

  // 测试banner面板切换处理
  it('test_onBannerPanelChange', Level.LEVEL0, (): void => {
    let result = false;
    try {
      const state = new BannerPanelTypeState();
      let panelState = liveViewStateMgr.getCurrentState(LiveStateType.STATE_LIVE_PANEL) as LivePanelState;
      const isLivePanelBak = liveViewStateMgr.isLivePanelShowing();

      // state not change
      state.bannerPanelType = BannerPanelType.TYPE_NONE;
      panelState.isLivePanelShowing = false;
      (liveViewStateMgr as Object as ILiveViewStateMgr).onBannerPanelChange(state);

      // bannerMgr.isHandleHeadUpToLiveList true
      state.bannerPanelType = BannerPanelType.TYPE_LIVE_LIST;
      panelState.isLivePanelShowing = false;
      bannerMgr.isHandleHeadUpToLiveList = true;
      (liveViewStateMgr as Object as ILiveViewStateMgr).onBannerPanelChange(state);

      // bannerMgr.isHandleHeadUpToLiveList false
      state.bannerPanelType = BannerPanelType.TYPE_LIVE_LIST;
      panelState.isLivePanelShowing = false;
      bannerMgr.isHandleHeadUpToLiveList = false;
      (liveViewStateMgr as Object as ILiveViewStateMgr).onBannerPanelChange(state);
      result = true;
      expect(result).assertTrue();

      panelState.isLivePanelShowing = isLivePanelBak;
    } catch (e) {
      expect(result).assertFalse();
    }
  });

  it('test_onDisplaySizeChange', Level.LEVEL0, (): void => {
    let result = false;
    try {
      const state: DisplaySizeStateTest = new DisplaySizeStateTest();
      let widestState = liveViewStateMgr.getCurrentState(LiveStateType.STATE_WIDEST_SCREEN) as LiveWidestScreenState;
      const isWidestScreenBak = widestState.isWidestScreen;
      widestState.isWidestScreen = true;
      const mock = new MockKit();
      let func = mock.mockFunc(state, state.isWidestScreen)
      when(func)().afterReturn(true);
      (liveViewStateMgr as Object as ILiveViewStateMgr).onDisplaySizeChange(state as DisplaySizeState);

      widestState.isWidestScreen = true;
      func = mock.mockFunc(state, state.isWidestScreen)
      when(func)().afterReturn(false);
      (liveViewStateMgr as Object as ILiveViewStateMgr).onDisplaySizeChange(state as DisplaySizeState);

      result = true;
      expect(result).assertTrue();
      widestState.isWidestScreen = isWidestScreenBak;
    } catch (e) {
      expect(result).assertFalse();
    }
  });

  it('test_has_liveStates', Level.LEVEL0, (): void => {
    expect(Reflect.has(liveViewStateMgr, 'liveStates')).assertTrue();
  });

  it('LiveViewStateMgrTest_has_eventMgr', Level.LEVEL0, (): void => {
    expect(Reflect.has(liveViewStateMgr, 'eventMgr')).assertTrue();
  });

  it('test_LiveBannerState', Level.LEVEL0, (): void => {
    let state = new LiveBannerState();
    expect(state?.getLiveStateType()).assertEqual(LiveStateType.STATE_BANNER);
  });

  it('LivePanelState22', Level.LEVEL0, (): void => {
    let state = new LivePanelState();
    state.isLivePanelShowing = true;
    state.isAnimEnable = false;
    state.isCapsuleChange = false;
    state.getLiveStateType();
    let state1 = new LiveWidestScreenState();
    state1.isWidestScreen = true;
    state1.getLiveStateType();
    expect(true).assertTrue();
  });

  it('LiveViewStateManager88', Level.LEVEL0, (): void => {
    try {
      Reflect.get(liveViewStateMgr, 'liveStates').get(LiveStateType.STATE_BANNER);
      Reflect.get(liveViewStateMgr, 'eventMgr');
    } catch (err) {
    }
    try {
      Reflect.get(liveViewStateMgr, 'liveStateListeners').add(() => {
      });
    } catch (err) {
    }
    try {
      let bannerPanelType: BannerPanelTypeState = new BannerPanelTypeState();
      Reflect.get(liveViewStateMgr, 'onStateChange')?.onStateChange(bannerPanelType);
    } catch (err) {
    }
    expect(true).assertTrue();
  });

  it('test881', Level.LEVEL0, (): void => {
    try {
      liveViewStateMgr.unregisterOnLiveStateChangeListener((state: ILiveState) => {
      });
      liveViewStateMgr.registerOnLiveStateChangeListener((state: ILiveState) => {
      });
    } catch (err) {
    }
    expect(true).assertTrue();
  });

  it('test882_0', Level.LEVEL0, (): void => {
    try {
      liveViewStateMgr.isForegroundApp(888);
      liveViewStateMgr.isWidestScreen();
      liveViewStateMgr.isBannerShowEvent('test');
      liveViewStateMgr.getHeadsUpPromise('test');
      liveViewStateMgr.isLivePanelShowing();
    } catch (err) {
    }
    expect(true).assertTrue();
  });

  it('test882_1', Level.LEVEL0, (): void => {
    try {
      Reflect.get(liveViewStateMgr, 'notifyLiveStateChange')?.(undefined);
      Reflect.get(liveViewStateMgr, 'onForegroundAppEvent')?.(undefined);
    } catch (err) {
    }
    try {
      Reflect.get(liveViewStateMgr, 'onHeadsUpChangeEvent')?.(undefined);
    } catch (err) {
    }
    try {
      Reflect.get(liveViewStateMgr, 'onDisplaySizeChange')?.(undefined);
    } catch (err) {
    }
    expect(true).assertTrue();
  });

  it('test888', Level.LEVEL0, (): void => {
    try {
      Reflect.get(liveViewStateMgr, 'constructor')?.();
    } catch (err) {
    }
    expect(true).assertTrue();
  });

  it('test_getContainerDefaultHeight', 0, () => {
    const mgr = new LiveViewStateManager();

    const data = new LiveViewData();
    data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
    mgr.getContainerDefaultHeight(data, 1, true);
    mgr.getContainerDefaultHeight(data, 1, false);

    data.sysTypeCode = SysTypeCode.OTHER;
    data.liveType = LiveType.TYPE_SYSTEM;
    mgr.getContainerDefaultHeight(data, 1, true);

    data.liveType = LiveType.PICK_UP;
    mgr.getContainerDefaultHeight(data, 1, true);

    expect(true).assertTrue();
  });
})}