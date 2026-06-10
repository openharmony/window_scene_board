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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { ImmersiveType, ImmersiveTypeScene, immersiveKgMgr, ImmersiveState, } from '@ohos/systemuicommon';
import { ImmersiveListHandle,
  ListTouchConst } from '../../../../../../main/ets/viewmodel/viewevent/ImmersiveListHandle';
import { immersiveVm } from '../../../../../../main/ets/viewmodel/ImmersiveVm';
import { ImmersiveListVm } from '../../../../../../main/ets/viewmodel/ImmersiveListVm';
import { ImmersiveAnimManager } from '../../../../../../main/ets/viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveEventStopHandle } from '../../../../../../main/ets/viewmodel/viewevent/ImmersiveEventStopHandle';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveListHandleTest() {
  let mocker: MockKit;
  describe('ImmersiveListHandleTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });
    beforeEach((): void => {

    });
    afterAll((): void => {
    });
    afterEach((): void => {

    });

    let eventArea: Area = {
      width: 0,
      height: 0,
      position: {
        x: 0, y: 0
      },
      globalPosition: {
        x: 0, y: 0
      }
    };
    let eventTarget: EventTarget = {
      area: eventArea
    };
    let gestureEvent: GestureEvent = {
      target: eventTarget,
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: 0,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0
    };

    let historicalPoint: HistoricalPoint = {
      touchObject: {
        type: TouchType.Down,
        id: 0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0
      },
      size: 0,
      force: 0,
      timestamp: 0
    }

    let touchEvent: TouchEvent = {
      target: {
        area: {
          width: 0,
          height: 0,
          position: {
            x: 0, y: 0
          },
          globalPosition: {
            x: 0, y: 0
          }
        }
      },
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      type: TouchType.Down,
      touches: [{
        y: 100,
        id: 1,
        displayX: 11,
        displayY: 12,
        windowX: 13,
        windowY: 14,
        type: TouchType.Up,
        screenX: 10,
        screenY: 10,
        x: 100
      }],
      changedTouches: [{
        id: 0,
        type: 0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0
      }],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [historicalPoint, historicalPoint];
      },
      preventDefault: () => {
      }
    }

    let listVm: ImmersiveListVm = immersiveVm.getImmersiveListVm();
    let manager: ImmersiveAnimManager = new ImmersiveAnimManager();
    const eventStopHandle: ImmersiveEventStopHandle = new ImmersiveEventStopHandle();
    let listHandle: ImmersiveListHandle = new ImmersiveListHandle();

    it('test_listEvent', Level.LEVEL0, (): void => {
      listHandle.onListTouchEvent(touchEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_setListHeight', Level.LEVEL0, (): void => {
      listHandle.setListHeight(0);
      listHandle.setListHeight(10);
      listHandle.setListHeight(100);
      expect(listHandle).not().assertNull();
    });

    it('test_onGestureStart', Level.LEVEL0, (): void => {
      (listHandle as object)['gestureId'] = undefined;
      listHandle.onGestureStart(PanDirection.None, gestureEvent);
      (listHandle as object)['gestureId'] = 10000;
      listHandle.onGestureStart(PanDirection.None, gestureEvent);
      listHandle.onGestureStart(PanDirection.Horizontal, gestureEvent);
      listHandle.onGestureStart(PanDirection.Left, gestureEvent);
      listHandle.onGestureStart(PanDirection.Right, gestureEvent);
      listHandle.onGestureStart(PanDirection.Vertical, gestureEvent);
      listHandle.onGestureStart(PanDirection.Up, gestureEvent);
      listHandle.onGestureStart(PanDirection.Down, gestureEvent);
      listHandle.onGestureStart(PanDirection.All, gestureEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_onGestureUpdate', Level.LEVEL0, (): void => {
      listHandle.onGestureUpdate(PanDirection.Up, gestureEvent);
      listHandle.onGestureUpdate(PanDirection.Down, gestureEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_onGestureEnd_01', Level.LEVEL0, (): void => {
      listHandle.onGestureEnd(PanDirection.Up, false, gestureEvent);
      listHandle.onGestureEnd(PanDirection.Down, false, gestureEvent);
      listHandle.onGestureEnd(PanDirection.Vertical, false, gestureEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_onGestureEnd_02', Level.LEVEL0, (): void => {
      listHandle.onGestureEnd(PanDirection.Up, true, gestureEvent);
      listHandle.onGestureEnd(PanDirection.Down, true, gestureEvent);
      listHandle.onGestureEnd(PanDirection.Vertical, true, gestureEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_onGestureEnd_03', Level.LEVEL0, (): void => {
      listHandle.onGestureEnd(PanDirection.Up, false);
      listHandle.onGestureEnd(PanDirection.Down, false);
      listHandle.onGestureEnd(PanDirection.Vertical, false);
      expect(listHandle).not().assertNull();
    });

    it('test_onGestureEnd_04', Level.LEVEL0, (): void => {
      listHandle.onGestureEnd(PanDirection.Up, true);
      listHandle.onGestureEnd(PanDirection.Down, true);
      listHandle.onGestureEnd(PanDirection.Vertical, true);
      expect(listHandle).not().assertNull();
    });

    it('test_downGestureEndRunnable', Level.LEVEL0, (): void => {
      (listHandle as object)['downGestureEndRunnable']();
      expect(listHandle).not().assertNull();
    });

    it('test_scrollStart', Level.LEVEL0, (): void => {
      listHandle.scrollStart();
      (listHandle as object)['upEnd'](true);
      (listHandle as object)['upStart'](gestureEvent);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      expect(listHandle).not().assertNull();
    });

    it('test_scrollReachStartEnd', Level.LEVEL0, (): void => {
      listHandle.scrollReachStartEnd();
      expect(listHandle).not().assertNull();
    });

    it('test_downUpdate', Level.LEVEL0, (): void => {
      (listHandle as object)['isDownScrollEnable'] = true;
      (listHandle as object)['downUpdate'](gestureEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_downUpdate_02', Level.LEVEL0, (): void => {
      (listHandle as object)['isDownScrollEnable'] = false;
      (listHandle as object)['downUpdate'](gestureEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_downUpdate_03', Level.LEVEL0, (): void => {
      (listHandle as object)['isStopEvent'] = true;
      (listHandle as object)['downUpdate'](gestureEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_downUpdate_04', Level.LEVEL0, (): void => {
      (listHandle as object)['isStopEvent'] = false;
      (listHandle as object)['downUpdate'](gestureEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_downEnd', Level.LEVEL0, (): void => {
      (listHandle as object)['gestureId'] = 100;
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      (listHandle as object)['downEnd'](true, gestureEvent);
      (listHandle as object)['downEnd'](true);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      expect(listHandle).not().assertNull();
    });

    it('test_downEnd_02', Level.LEVEL0, (): void => {
      (listHandle as object)['gestureId'] = 100;
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      (listHandle as object)['downEnd'](false, gestureEvent);
      (listHandle as object)['downEnd'](false);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      expect(listHandle).not().assertNull();
    });

    it('test_startList2CapsuleAnim', Level.LEVEL0, (): void => {
      (listHandle as object)['startList2CapsuleAnim'](10, true);
      (listHandle as object)['startList2CapsuleAnim'](10, false);
      expect(listHandle).not().assertNull();
    });

    it('test_setItemTouchValue', Level.LEVEL0, (): void => {
      (listHandle as object)['setItemTouchValue'](0);
      (listHandle as object)['setItemTouchValue'](10);
      (listHandle as object)['setItemTouchValue'](100);
      expect(listHandle).not().assertNull();
    });

    it('test_TouchAnim', Level.LEVEL0, (): void => {
      (listHandle as object)['startTouchAnim']();
      (listHandle as object)['endTouchAnim']();
      expect(listHandle).not().assertNull();
    });

    it('test_leftRightStart', Level.LEVEL0, (): void => {
      (listHandle as object)['leftRightStart']();
      expect(listHandle).not().assertNull();
    });

    it('test_getValidVelocity', Level.LEVEL0, (): void => {
      let res: number = (listHandle as object)['getValidVelocity'](0, 0);
      expect(res).assertEqual(0);
    });

    it('test_getValidVelocity_02', Level.LEVEL0, (): void => {
      let res: number = (listHandle as object)['getValidVelocity'](1000, 10);
      expect(res).assertEqual(ListTouchConst.VEL_MAX);
    });

    it('test_getValidVelocity_03', Level.LEVEL0, (): void => {
      let res: number = (listHandle as object)['getValidVelocity'](140, 10);
      expect(res).assertEqual(14);
    });

    it('test_isInterceptDownScroll', Level.LEVEL0, (): void => {
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      let res: boolean = (listHandle as object)['isInterceptDownScroll']();
      expect(res).assertTrue();
    });

    it('test_isInterceptDownScroll_02', Level.LEVEL0, (): void => {
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      let res: boolean = (listHandle as object)['isInterceptDownScroll']();
      expect(res).assertFalse();
    });

    it('test_isAnimating', Level.LEVEL0, (): void => {
      let res: boolean = (listHandle as object)['isAnimating']();
      expect(res).assertTrue();
    });

    it('test_isAtTop', Level.LEVEL0, (): void => {
      let res: boolean = (listHandle as object)['isAtTop']();
      expect(res).assertTrue();
    });

    it('test_isAtEnd', Level.LEVEL0, (): void => {
      let res: boolean = (listHandle as object)['isAtEnd']();
      expect(res).assertUndefined();
    });

    it('test_getScroller', Level.LEVEL0, (): void => {
      (listHandle as object)['getScroller']();
      expect(listHandle).not().assertNull();
    });

    it('test_getStaticState', Level.LEVEL0, (): void => {
      (listHandle as object)['getStaticState']();
      expect(listHandle).not().assertNull();
    });

    it('test_getBindState', Level.LEVEL0, (): void => {
      (listHandle as object)['getBindState']();
      expect(listHandle).not().assertNull();
    });

    it('test_resetTran', Level.LEVEL0, (): void => {
      (listHandle as object)['resetTran']();
      expect(listHandle).not().assertNull();
    });

    it('test_resetListScrollEnable', Level.LEVEL0, (): void => {
      (listHandle as object)['resetListScrollEnable'](true);
      (listHandle as object)['resetListScrollEnable'](false);
      expect(listHandle).not().assertNull();
    });

    it('test_resetListScrollEnable_02', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAtEnd']);
      when(mockFun1)().afterReturn(false);
      (listHandle as object)['resetListScrollEnable'](true);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_resetListScrollEnable_03', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAtEnd']);
      when(mockFun1)().afterReturn(true);
      (listHandle as object)['resetListScrollEnable'](true);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_scrollFrameBegin_01', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAtEnd']);
      when(mockFun1)().afterReturn(false);
      listHandle.scrollFrameBegin(5);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_scrollFrameBegin_02', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAtEnd']);
      when(mockFun1)().afterReturn(false);
      listHandle.scrollFrameBegin(35);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_scrollFrameBegin_03', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAtEnd']);
      when(mockFun1)().afterReturn(true);
      listHandle.scrollFrameBegin(5);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_scrollFrameBegin_04', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAtEnd']);
      when(mockFun1)().afterReturn(true);
      listHandle.scrollFrameBegin(-5);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_scrollList', Level.LEVEL0, (): void => {
      (listHandle as object)['scrollList'](30);
      expect(listHandle).not().assertNull();
    });

    it('test_scrollList_02', Level.LEVEL0, (): void => {
      (listHandle as object)['scrollList'](30, true);
      expect(listHandle).not().assertNull();
    });

    it('test_scrollList_03', Level.LEVEL0, (): void => {
      (listHandle as object)['scrollList'](30, false);
      expect(listHandle).not().assertNull();
    });


    it('test_eventStopListener_02', Level.LEVEL0, (): void => {
      (listHandle as object)['isDownScrollEnable'] = true;
      (listHandle as object)['eventStopListener'].onEventStop(false);
      expect(listHandle).not().assertNull();
    });

    it('test_eventStopListener_03', Level.LEVEL0, (): void => {
      (listHandle as object)['isDownScrollEnable'] = false;
      (listHandle as object)['eventStopListener'].onEventStop(false);
      expect(listHandle).not().assertNull();
    });

    it('test_init', Level.LEVEL0, (): void => {
      (listHandle as object)['eventStopHandle'] = undefined;
      listHandle.init();
      expect(listHandle).not().assertNull();
    });

    it('test_init_02', Level.LEVEL0, (): void => {
      (listHandle as object)['eventStopHandle'] = new ImmersiveEventStopHandle();
      listHandle.init();
      expect(listHandle).not().assertNull();
    });

    it('test_init_03', Level.LEVEL0, (): void => {
      (listHandle as object)['eventStopHandle'] = undefined;
      (listHandle as object)['onImmStateChange'] = () => {};
      listHandle.init();
      expect(listHandle).not().assertNull();
    });

    it('test_init_04', Level.LEVEL0, (): void => {
      (listHandle as object)['eventStopHandle'] = new ImmersiveEventStopHandle();
      (listHandle as object)['onImmStateChange'] = () => {};
      listHandle.init();
      expect(listHandle).not().assertNull();
    });

    it('test_init_05', Level.LEVEL0, (): void => {
      (listHandle as object)['eventStopHandle'] = undefined;
      (listHandle as object)['immersiveState'] = { immersiveType: ImmersiveType.TYPE_LIST };
      listHandle.init();
      expect(listHandle).not().assertNull();
    });

    it('test_init_06', Level.LEVEL0, (): void => {
      (listHandle as object)['eventStopHandle'] = new ImmersiveEventStopHandle();
      (listHandle as object)['immersiveState'] = { immersiveType: ImmersiveType.TYPE_CAPSULE };
      listHandle.init();
      expect(listHandle).not().assertNull();
    });

    it('test_onListTouchEvent_01', Level.LEVEL0, (): void => {
      touchEvent.changedTouches[0].id = 0;
      listHandle.onListTouchEvent(touchEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_onListTouchEvent_02', Level.LEVEL0, (): void => {
      touchEvent.changedTouches[0].id = 10;
      listHandle.onListTouchEvent(touchEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_onListTouchEvent_03', Level.LEVEL0, (): void => {
      touchEvent.changedTouches[0].id = 0;
      touchEvent.type = TouchType.Down;
      listHandle.onListTouchEvent(touchEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_onListTouchEvent_04', Level.LEVEL0, (): void => {
      touchEvent.changedTouches[0].id = 10;
      touchEvent.type = TouchType.Down;
      listHandle.onListTouchEvent(touchEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_onItemTouchIntercept_01', Level.LEVEL0, (): void => {
      let res: HitTestMode = listHandle.onItemTouchIntercept(touchEvent);
      expect(res).assertEqual(HitTestMode.Default);
    });

    it('test_onItemTouchIntercept_02', Level.LEVEL0, (): void => {
      let res: HitTestMode = listHandle.onItemTouchIntercept(touchEvent, 'test');
      expect(res).assertEqual(HitTestMode.Block);
    });

    it('test_onItemTouchIntercept_03', Level.LEVEL0, (): void => {
      let itemKey = 'test'
      let list = listVm.getListBindState().getNtfAnimPara(itemKey);
      list.ntfItemClipHeight = 0;
      list.ntfItemTranslateX = 10;
      list.clearAnimScale = 5;
      let res: HitTestMode = listHandle.onItemTouchIntercept(touchEvent, 'test');
      expect(res).assertEqual(HitTestMode.Default);
    });

    it('test_onItemTouchIntercept_04', Level.LEVEL0, (): void => {
      let itemKey = 'test'
      let list = listVm.getListBindState().getNtfAnimPara(itemKey);
      list.ntfItemClipHeight = 10;
      list.ntfItemClipOffsetY = 10;
      touchEvent.touches[0].y = 15;
      let res: HitTestMode = listHandle.onItemTouchIntercept(touchEvent, 'test');
      expect(res).assertEqual(HitTestMode.Default);
    });

    it('test_onItemTouchIntercept_05', Level.LEVEL0, (): void => {
      let itemKey = 'test'
      let list = listVm.getListBindState().getNtfAnimPara(itemKey);
      list.ntfItemClipHeight = 10;
      list.ntfItemClipOffsetY = 10;
      touchEvent.touches[0].y = 30;
      let res: HitTestMode = listHandle.onItemTouchIntercept(touchEvent, 'test');
      expect(res).assertEqual(HitTestMode.Block);
    });



    it('test_destroy', Level.LEVEL0, (): void => {
      (listHandle as object)['eventStopHandle'] = eventStopHandle;
      listHandle.destroy();
      expect(listHandle).not().assertNull();
    });

    it('test_destroy_undefined', Level.LEVEL0, (): void => {
      (listHandle as object)['eventStopHandle'] = undefined;
      listHandle.destroy();
      expect(listHandle).not().assertNull();
    });

    it('test_checkChangeImmType_01', Level.LEVEL0, (): void => {
      let immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
      immersiveState.immersiveType = ImmersiveType.TYPE_CAPSULE;
      (listHandle as object)['interruptImmType'] = ImmersiveType.TYPE_LIST;
      (listHandle as object)['checkChangeImmType']();
      expect(listHandle).not().assertNull();
    });

    it('test_checkChangeImmType_02', Level.LEVEL0, (): void => {
      let immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
      immersiveState.immersiveType = ImmersiveType.TYPE_CAPSULE;
      (listHandle as object)['interruptImmType'] = ImmersiveType.TYPE_IMMERSIVE;
      (listHandle as object)['checkChangeImmType']();
      expect(listHandle).not().assertNull();
    });

    it('test_checkChangeImmType_03', Level.LEVEL0, (): void => {
      let immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
      immersiveState.immersiveType = ImmersiveType.TYPE_LIST;
      (listHandle as object)['interruptImmType'] = ImmersiveType.TYPE_LIST;
      (listHandle as object)['checkChangeImmType']();
      expect(listHandle).not().assertNull();
    });

    it('test_checkChangeImmType_04', Level.LEVEL0, (): void => {
      let immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
      immersiveState.immersiveType = ImmersiveType.TYPE_LIST;
      (listHandle as object)['interruptImmType'] = ImmersiveType.TYPE_IMMERSIVE;
      (listHandle as object)['checkChangeImmType']();
      expect(listHandle).not().assertNull();
    });

    it('test_clearCheckImmRunnable_01', Level.LEVEL0, (): void => {
      (listHandle as object)['checkImmId'] = undefined;
      (listHandle as object)['clearCheckImmRunnable']();
      expect(listHandle).not().assertNull();
    });

    it('test_clearCheckImmRunnable_02', Level.LEVEL0, (): void => {
      (listHandle as object)['checkImmId'] = 1;
      (listHandle as object)['clearCheckImmRunnable']();
      expect(listHandle).not().assertNull();
    });

    it('test_upStart_01', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAtEnd']);
      when(mockFun1)().afterReturn(true);
      (listHandle as object)['upStart'](gestureEvent);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_upStart_02', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAtEnd']);
      when(mockFun1)().afterReturn(false);
      (listHandle as object)['upStart'](gestureEvent);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_upEnd', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAnimating']);
      when(mockFun1)().afterReturn(true);
      (listHandle as object)['upEnd'](true, gestureEvent);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_upEnd_02', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAnimating']);
      when(mockFun1)().afterReturn(true);
      (listHandle as object)['upEnd'](false);
      (listHandle as object)['upEnd'](false, gestureEvent);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_upEnd_03', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAnimating']);
      when(mockFun1)().afterReturn(false);
      (listHandle as object)['upEnd'](true);
      (listHandle as object)['upEnd'](true, gestureEvent);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_upEnd_04', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAnimating']);
      when(mockFun1)().afterReturn(false);
      (listHandle as object)['upEnd'](false);
      (listHandle as object)['upEnd'](false, gestureEvent);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_downStart', Level.LEVEL0, (): void => {
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      (listHandle as object)['downStart'](gestureEvent);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      (listHandle as object)['downStart'](gestureEvent);
      expect(listHandle).not().assertNull();
    });

    it('test_downStart_02', Level.LEVEL0, (): void => {
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAnimating']);
      when(mockFun1)().afterReturn(true);
      (listHandle as object)['downStart'](gestureEvent);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_downStart_03', Level.LEVEL0, (): void => {
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAnimating']);
      when(mockFun1)().afterReturn(false);
      let mockFun2 = mock.mockFunc(listHandle, (listHandle as object)['isAtTop']);
      when(mockFun2)().afterReturn(true);
      (listHandle as object)['downStart'](gestureEvent);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_downStart_04', Level.LEVEL0, (): void => {
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAnimating']);
      when(mockFun1)().afterReturn(false);
      let mockFun2 = mock.mockFunc(listHandle, (listHandle as object)['isAtTop']);
      when(mockFun2)().afterReturn(false);
      (listHandle as object)['downStart'](gestureEvent);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_downStart_05', Level.LEVEL0, (): void => {
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAnimating']);
      when(mockFun1)().afterReturn(false);
      let mockFun2 = mock.mockFunc(listHandle, (listHandle as object)['isAtTop']);
      when(mockFun2)().afterReturn(true);
      (listHandle as object)['isDownScrollEnable'] = true;
      (listHandle as object)['downStart'](gestureEvent);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });

    it('test_downStart_06', Level.LEVEL0, (): void => {
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST, false, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(listHandle, (listHandle as object)['isAnimating']);
      when(mockFun1)().afterReturn(false);
      let mockFun2 = mock.mockFunc(listHandle, (listHandle as object)['isAtTop']);
      when(mockFun2)().afterReturn(true);
      (listHandle as object)['isDownScrollEnable'] = false;
      (listHandle as object)['downStart'](gestureEvent);
      expect(listHandle).not().assertNull();
      mock.clear(listHandle);
    });
  });
}
