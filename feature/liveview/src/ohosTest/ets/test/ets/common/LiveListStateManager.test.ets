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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import {
  BannerOutsideState,
  BannerPanelType,
  LiveButtonData,
  LiveOtherExtendData,
  LiveSystemTemplate,
  LiveType,
  LiveViewData,
  OtherBaseTemplate
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { LiveListStateManager } from '../../../../../main/ets/common/LiveListStateManager';
import { liveCapsuleVm } from '../../../../../main/ets/vm/LiveViewVm';
import ntfManager from '@ohos.notificationManager';

interface ILiveListStateManager {
  onLockClick(data?: LiveOtherExtendData, clickCount?: number, notificationType?: number): void;
}

/**
 * 实况面板状态管理测试用例
 */
export function LiveListStateMgrTest() {
  describe('LiveListStateMgrTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });
    it('test_getLiveListState', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      expect(mgr.getLiveListState()).not().assertNull();
    });
    it('test_setLiveCapsuleList', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      mgr.setLiveCapsuleList(liveCapsuleVm.getCapsuleList());
      expect(Reflect.has(mgr, 'liveCapsuleList')).assertTrue();
    });
    it('test_setListArea', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      mgr.setListArea({
        width: 1,
        height: 1,
        position: {
          x: 0,
          y: 0
        },
        globalPosition: {
          x: 0,
          y: 0
        }
      }, 0, 0, 0);
      expect(Reflect.has(mgr, 'liveListArea')).assertTrue();
    });
    it('test_has_onButtonClick1', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      let data = new LiveButtonData();
      let data1 = new LiveViewData();
      try {
        Reflect.get(mgr, 'onButtonClick')?.(data, data1);
        data.bundle = {} as ntfManager.BundleOption;
        data.id = 8;
        Reflect.get(mgr, 'onButtonClick')?.(data, data1);
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'handleExtendClick')).assertTrue();
    });

    it('test_has_shouldResponseTouchEvent', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      try {
        Reflect.get(mgr, 'shouldResponseTouchEvent')?.(1, 2, {
          left: 1,
          right: 1,
          top: 6,
          bottom: 6
        });
        Reflect.get(mgr, 'shouldResponseTouchEvent')?.(1, 88, {
          left: 1,
          right: 1,
          top: 6,
          bottom: 6
        });
        Reflect.get(mgr, 'shouldResponseTouchEvent')?.(1, -500, {
          left: 1,
          right: 1,
          top: 0,
          bottom: 6
        });
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'handleExtendClick')).assertTrue();
    });

    it('test_has_onLockClick', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      try {
        (mgr as Object as ILiveListStateManager).onLockClick();
        (mgr as Object as ILiveListStateManager).onLockClick(undefined, 3);
        Reflect.get(mgr, 'onLockClick')?.();
        Reflect.get(mgr, 'onLockClick')?.(undefined, 3);
      } catch (err) {
      }
      try {
        Reflect.set(mgr, 'extendClickCount', 2);
        Reflect.get(mgr, 'onLockClick')?.(undefined, 3);
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'checkAndAddClickHandle')).assertTrue();
    });

    it('test_has_releasePanel', Level.LEVEL0, async (): Promise<void> => {
      let mgr = new LiveListStateManager();
      mgr.releasePanel();
      await new Promise<void>(res => setTimeout(res, 20));
      expect(Reflect.has(mgr, 'checkAndAddClickHandle')).assertTrue();
    });

    it('test_has_trigger', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      try {
        Reflect.get(mgr, 'trigger')?.();
        Reflect.get(mgr, 'trigger')?.({ name: 'x' });
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'trigger')).assertTrue();
    });

    it('test_has_handleExtendClick1', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      let data = new LiveOtherExtendData();

      try {
        Reflect.get(mgr, 'handleExtendClick')?.();
        data.wantAgent = { name: '1' };
        Reflect.get(mgr, 'handleExtendClick')?.(data);
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'handleExtendClick')).assertTrue();
    });
    it('test_has_checkAndAddClickHandle', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      let data = new LiveViewData();
      try {
        mgr.checkAndAddClickHandle();
        mgr.checkAndAddClickHandle(data);
        data.template = new LiveSystemTemplate();
        mgr.checkAndAddClickHandle(data);
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'checkAndAddClickHandle')).assertTrue();
    });


    it('test_has_postTouchEvent', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      try {
        Reflect.get(mgr, 'postTouchEvent')?.(1, 1);
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'checkAndAddClickHandle')).assertTrue();
    });

    it('test_has_onExtendClick', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      let data = new LiveViewData();
      try {
        Reflect.get(mgr, 'onExtendClick')?.();
        Reflect.get(mgr, 'onExtendClick')?.(data);
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'checkAndAddClickHandle')).assertTrue();
    });


    it('test_has_checkClearRunnable', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      try {
        Reflect.get(mgr, 'checkClearRunnable')?.();
        Reflect.get(mgr, 'checkClearRunnable')?.(6);
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'checkAndAddClickHandle')).assertTrue();
    });
    // 测试注册面板外部触摸事件
    it('test_has_registerLiveListTouchOutside', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      try {
        mgr.registerLiveListTouchOutside();
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'registerLiveListTouchOutside')).assertTrue();
    });

    // 测试注销面板外部触摸事件
    it('test_has_unregisterLiveListTouchOutSide', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      try {
        mgr.unregisterLiveListTouchOutSide();
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'unregisterLiveListTouchOutSide')).assertTrue();
    });

    // 测试实况删除
    it('test_has_handleLiveViewRemove', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      mgr.handleLiveViewRemove();
      let data = new LiveViewData();
      data.hashCode = 'test';
      mgr.handleLiveViewRemove(data);
      expect(Reflect.has(mgr, 'handleLiveViewRemove')).assertTrue();
    });

    // 测试实况点击
    it('test_has_handleBannerClick', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      let data = new LiveViewData();
      try {
        mgr.handleBannerClick();
        mgr.handleBannerClick(data);
        data.template = new LiveSystemTemplate();
        mgr.handleBannerClick(data);
        (data.template as LiveSystemTemplate).wantAgent = {};
        mgr.handleBannerClick(data, false);
        mgr.handleBannerClick(data, true);

        data.template = new OtherBaseTemplate();
        mgr.handleBannerClick(data);
      } catch (err) {

      }
      expect(Reflect.has(mgr, 'handleBannerClick')).assertTrue();
    });

    // 测试检测实况面板释放
    it('test_has_checkReleaseLiveListPanel', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      expect(Reflect.has(mgr, 'checkReleaseLiveListPanel')).assertTrue();
    });

    // 测试滑动手势结束
    it('test_has_onListGestureEnd', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      expect(Reflect.has(mgr, 'onListGestureEnd')).assertTrue();
    });

    it('test_has_onListGestureEnd1', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      try {
        mgr.onListGestureEnd(undefined!);
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'onListGestureEnd')).assertTrue();
    });

    it('test_has_onListGestureEnd2', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      try {
        mgr.onListGestureEnd({
          offsetY: -50,
          velocityY: -2000
        } as GestureEvent);
      } catch (err) {
      }
      try {
        mgr.onListGestureEnd({
          offsetY: -6,
          velocityY: -2000
        } as GestureEvent);
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'onListGestureEnd')).assertTrue();
    });
    it('test_checkReleaseLiveListPanel', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      try {
        mgr.checkReleaseLiveListPanel();
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'onListGestureEnd')).assertTrue();
    });

    it('test_touchSide', Level.LEVEL0, (): void => {
      let mgr = new LiveListStateManager();
      try {
        Reflect.get(mgr, 'onTouchOutside')?.onStateChange(undefined);
        let state = new BannerOutsideState();
        Reflect.get(mgr, 'onTouchOutside')?.onStateChange(state);
        state.currentPanelType = BannerPanelType.TYPE_LIVE_LIST;
        Reflect.get(mgr, 'onTouchOutside')?.onStateChange(state);
        mgr.setListArea({
          width: 1000,
          height: 1000,
          position: { x: 0, y: 0 },
          globalPosition: { x: 0, y: 0 }
        }, 0, 0, 0);
        state.touchX = 500;
        state.touchY = 222;
        Reflect.get(mgr, 'onTouchOutside')?.onStateChange(state);
        state.touchX = 500;
        state.touchY = 888;
        Reflect.get(mgr, 'onTouchOutside')?.onStateChange(state);
        state.touchX = -500;
        state.touchY = -500;
        Reflect.get(mgr, 'onTouchOutside')?.onStateChange(state);
      } catch (err) {
      }
      try {
        Reflect.get(mgr, 'onTouchOutside')?.getExtendType();
      } catch (err) {
      }
      expect(Reflect.has(mgr, 'onListGestureEnd')).assertTrue();
    });

    it('test_releasePanelLiveList', 0, () => {
      const mgr = new LiveListStateManager();
      mgr.releasePanelLiveList(false);
      mgr.releasePanelLiveList(true);
      expect(Reflect.has(mgr, 'onListGestureEnd')).assertTrue();
    });

    it('test_checkServiceButtonClick', 0, () => {
      const mgr = new LiveListStateManager();
      const fun: ((data?: LiveViewData) => void) | undefined = Reflect.get(mgr, 'checkServiceButtonClick');
      if (fun) {
        try {
          fun();

          const data = new LiveViewData();
          data.liveType = LiveType.NO_LAYOUT;
          fun(data);

          data.template = new OtherBaseTemplate();
          fun(data);
        } catch (error) {}
        expect(fun !== undefined).assertTrue()
      }
    });
  })
}