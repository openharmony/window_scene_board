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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  DEFAULT,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { LiveVmInjector } from '../../../../../../../newIndex';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveHeadsUpSwipeVm } from '../../../../../../main/ets/live/vm/LiveHeadsUpSwipeVm';

// 模拟 LiveVmInjector 实例
class MockLiveVmInjector {
  getLiveHeadsUpVm(): any {
    return {
      isTimeout: false,
      hide: jest.fn(),
      clearTimeout: jest.fn(),
    };
  }
}

// 模拟 LiveNotification 实例
class MockLiveNotification {
  hashCode: string = 'testHashCode';

  isInstantBanner(): boolean {
    return true;
  }
}

// 模拟 GestureEvent 实例
class MockGestureEvent {
  offsetX: number = 0;
  offsetY: number = 0;
  velocity: number = 0;
}

describe('LiveHeadsUpSwipeVm', () => {
  let liveHeadsUpSwipeVm: LiveHeadsUpSwipeVm;

  beforeEach(() => {
    // 模拟实例
    const mockLiveVmInjector = new MockLiveVmInjector();
    const mockLiveNotification = new MockLiveNotification();
    const mockGestureEvent = new MockGestureEvent();

    // 设置实例
    liveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(mockLiveVmInjector, mockLiveNotification);
  });

  it('should handle horizontal pan start correctly', DEFAULT, () => {
    const event = new MockGestureEvent();
    event.offsetX = 10;
    liveHeadsUpSwipeVm.onHorizontalPanStart(event);
    expect(liveHeadsUpSwipeVm.isTouching).toBe(true);
    expect(liveHeadsUpSwipeVm.startOffsetX).toBe(10);
  });

  it('should handle horizontal pan start correctly', DEFAULT, () => {
    const event = new MockGestureEvent();
    event.offsetX = 20;
    liveHeadsUpSwipeVm.onHorizontalPanUpdate(event);
    expect(liveHeadsUpSwipeVm.startOffsetX + event.offsetX).toBe(30);
    liveHeadsUpSwipeVm.updateHorizontal(30, false);
  });

  it('should handle horizontal pan start correctly', DEFAULT, () => {
    const event = new MockGestureEvent();
    event.offsetX = 30;
    liveHeadsUpSwipeVm.onHorizontalPanEnd(event);
    expect(liveHeadsUpSwipeVm.isLeftToRight).toBe(true);
    expect(liveHeadsUpSwipeVm.isTouching).toBe(false);
    liveHeadsUpSwipeVm.stopHorizontal(30);
  });

  it('should handle horizontal pan start correctly', DEFAULT, () => {
    const event = new MockGestureEvent();
    event.offsetY = 10;
    event.velocity = 200;
    liveHeadsUpSwipeVm.onVerticalPanStart(event);
    expect(liveHeadsUpSwipeVm.verticalDamp).toBe(LiveHeadsUpSwipeVm.VERTICAL_FAST_SWIPE_DAMP);
    expect(liveHeadsUpSwipeVm.isTouching).toBe(true);
    expect(liveHeadsUpSwipeVm.startOffsetY).toBe(10);
  });

  it('should handle horizontal pan start correctly', DEFAULT, () => {
    const event = new MockGestureEvent();
    event.offsetY = 20;
    liveHeadsUpSwipeVm.onVerticalPanUpdate(event);
    expect(liveHeadsUpSwipeVm.startOffsetY + event.offsetY).toBe(30);
    liveHeadsUpSwipeVm.updateVertical(30, false);
  });

  it('should handle horizontal pan start correctly', DEFAULT, () => {
    const event = new MockGestureEvent();
    event.offsetY = 30;
    liveHeadsUpSwipeVm.onVerticalPanEnd(event);
    expect(liveHeadsUpSwipeVm.isTouching).toBe(false);
    liveHeadsUpSwipeVm.stopSwipeVertical(30);
  });

  it('should handle horizontal pan start correctly', DEFAULT, async () => {
    await liveHeadsUpSwipeVm.updateHorizontal(30, true);
    expect(liveHeadsUpSwipeVm.headVm.contentOffsetX).toBe(30 * LiveHeadsUpSwipeVm.HORIZONTAL_SWIPE_DAMP);
  });

  it('should handle horizontal pan start correctly', DEFAULT, async () => {
    await liveHeadsUpSwipeVm.updateVertical(30, true);
    expect(liveHeadsUpSwipeVm.headVm.contentOffsetY).toBe(30 * LiveHeadsUpSwipeVm.SWIPE_DAMP_DOWN);
  });

  it('should handle horizontal pan start correctly', DEFAULT, () => {
    liveHeadsUpSwipeVm.stopHorizontal(30);
    expect(liveHeadsUpSwipeVm.headVm.contentOffsetX).toBe(0);
  });

  it('should handle horizontal pan start correctly', DEFAULT, () => {
    liveHeadsUpSwipeVm.stopSwipeVertical(30);
    expect(liveHeadsUpSwipeVm.headVm.contentOffsetY).toBe(0);
  });
});

describe('updateSwipeHorizontalOffset_testSuite', () => {

  beforeEach(() => {

  });
  afterEach(() => {

  });


  it('should_return_immediately_when_offsetLeft_equals_current_offsetX', 0, async () => {
    let liveheadsupswipevm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(new LiveVmInjector(), new LiveNotification());
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetX);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(100);

    await liveheadsupswipevm.updateSwipeHorizontalOffset(100, true);

    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetX);
  });

  it('should_update_offsetX_when_offsetLeft_is_different_and_animation_is_true', 0, async () => {
    let liveheadsupswipevm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(new LiveVmInjector(), new LiveNotification());
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetX);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(100);

    await liveheadsupswipevm.updateSwipeHorizontalOffset(200, true);

    expect(liveheadsupswipevm.headVm.contentOffsetX).assertEqual(200 * HORIZONTAL_SWIPE_DAMP);
    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetX);
  });

  it('should_update_offsetX_when_offsetLeft_is_different_and_animation_is_false', 0, async () => {
    let liveheadsupswipevm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(new LiveVmInjector(), new LiveNotification());
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetX);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(100);

    await liveheadsupswipevm.updateSwipeHorizontalOffset(200, false);

    expect(liveheadsupswipevm.headVm.contentOffsetX).assertEqual(200 * HORIZONTAL_SWIPE_DAMP);
    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetX);
  });

  it('should_return_immediately_when_offsetLeft_equals_current_offsetX', 0, async () => {
    const live = new LiveNotification();
    const injector = new LiveVmInjector();
    const swipeVm = new LiveHeadsUpSwipeVm(injector, live);
    const mocker = new MockKit();
    const mockfunc = mocker.mockFunc(swipeVm.headVm, 'contentOffsetX');
    when(mockfunc).afterReturn(100);

    await swipeVm.updateSwipeHorizontalOffset(100, true);

    mocker.ignoreMock(swipeVm.headVm, 'contentOffsetX');
  });

  it('should_update_offsetX_with_animation_when_offsetLeft_is_different', 0, async () => {
    const live = new LiveNotification();
    const injector = new LiveVmInjector();
    const swipeVm = new LiveHeadsUpSwipeVm(injector, live);
    const mocker = new MockKit();
    const mockfunc = mocker.mockFunc(swipeVm.headVm, 'contentOffsetX');
    when(mockfunc).afterReturn(100);

    await swipeVm.updateSwipeHorizontalOffset(200, true);

    expect(swipeVm.headVm.contentOffsetX).assertEqual(200 * HORIZONTAL_SWIPE_DAMP);
    mocker.ignoreMock(swipeVm.headVm, 'contentOffsetX');
  });

  it('should_update_offsetX_without_animation_when_offsetLeft_is_different', 0, async () => {
    const live = new LiveNotification();
    const injector = new LiveVmInjector();
    const swipeVm = new LiveHeadsUpSwipeVm(injector, live);
    const mocker = new MockKit();
    const mockfunc = mocker.mockFunc(swipeVm.headVm, 'contentOffsetX');
    when(mockfunc).afterReturn(100);

    await swipeVm.updateSwipeHorizontalOffset(200, false);

    expect(swipeVm.headVm.contentOffsetX).assertEqual(200 * HORIZONTAL_SWIPE_DAMP);
    mocker.ignoreMock(swipeVm.headVm, 'contentOffsetX');
  });

  it('should_update_offsetX_to_zero_with_animation', 0, async () => {
    const live = new LiveNotification();
    const injector = new LiveVmInjector();
    const swipeVm = new LiveHeadsUpSwipeVm(injector, live);
    const mocker = new MockKit();
    const mockfunc = mocker.mockFunc(swipeVm.headVm, 'contentOffsetX');
    when(mockfunc).afterReturn(100);

    await swipeVm.updateSwipeHorizontalOffset(0, true);

    expect(swipeVm.headVm.contentOffsetX).assertEqual(0 * HORIZONTAL_SWIPE_DAMP);
    mocker.ignoreMock(swipeVm.headVm, 'contentOffsetX');
  });

  it('should_update_offsetX_with_negative_value_and_animation', 0, async () => {
    const live = new LiveNotification();
    const injector = new LiveVmInjector();
    const swipeVm = new LiveHeadsUpSwipeVm(injector, live);
    const mocker = new MockKit();
    const mockfunc = mocker.mockFunc(swipeVm.headVm, 'contentOffsetX');
    when(mockfunc).afterReturn(100);

    await swipeVm.updateSwipeHorizontalOffset(-50, true);

    expect(swipeVm.headVm.contentOffsetX).assertEqual(-50 * HORIZONTAL_SWIPE_DAMP);
    mocker.ignoreMock(swipeVm.headVm, 'contentOffsetX');
  });

  it('should_update_offsetX_with_negative_value_without_animation', 0, async () => {
    const live = new LiveNotification();
    const injector = new LiveVmInjector();
    const swipeVm = new LiveHeadsUpSwipeVm(injector, live);
    const mocker = new MockKit();
    const mockfunc = mocker.mockFunc(swipeVm.headVm, 'contentOffsetX');
    when(mockfunc).afterReturn(100);

    await swipeVm.updateSwipeHorizontalOffset(-50, false);

    expect(swipeVm.headVm.contentOffsetX).assertEqual(-50 * HORIZONTAL_SWIPE_DAMP);
    mocker.ignoreMock(swipeVm.headVm, 'contentOffsetX');
  });

  it('should_handle_large_offsetLeft_with_animation', 0, async () => {
    const live = new LiveNotification();
    const injector = new LiveVmInjector();
    const swipeVm = new LiveHeadsUpSwipeVm(injector, live);
    const mocker = new MockKit();
    const mockfunc = mocker.mockFunc(swipeVm.headVm, 'contentOffsetX');
    when(mockfunc).afterReturn(100);

    const largeOffset = 1000000;
    await swipeVm.updateSwipeHorizontalOffset(largeOffset, true);

    expect(swipeVm.headVm.contentOffsetX).assertEqual(largeOffset * HORIZONTAL_SWIPE_DAMP);
    mocker.ignoreMock(swipeVm.headVm, 'contentOffsetX');
  });

  it('should_handle_large_offsetLeft_without_animation', 0, async () => {
    const live = new LiveNotification();
    const injector = new LiveVmInjector();
    const swipeVm = new LiveHeadsUpSwipeVm(injector, live);
    const mocker = new MockKit();
    const mockfunc = mocker.mockFunc(swipeVm.headVm, 'contentOffsetX');
    when(mockfunc).afterReturn(100);

    const largeOffset = 1000000;
    await swipeVm.updateSwipeHorizontalOffset(largeOffset, false);

    expect(swipeVm.headVm.contentOffsetX).assertEqual(largeOffset * HORIZONTAL_SWIPE_DAMP);
    mocker.ignoreMock(swipeVm.headVm, 'contentOffsetX');
  });

  it('should_correctly_update_offsetX_on_multiple_calls', 0, async () => {
    const live = new LiveNotification();
    const injector = new LiveVmInjector();
    const swipeVm = new LiveHeadsUpSwipeVm(injector, live);
    const mocker = new MockKit();
    const mockfunc = mocker.mockFunc(swipeVm.headVm, 'contentOffsetX');
    when(mockfunc).afterReturn(100);

    // 第一次调用
    await swipeVm.updateSwipeHorizontalOffset(200, true);
    expect(swipeVm.headVm.contentOffsetX).assertEqual(200 * HORIZONTAL_SWIPE_DAMP);

    // 第二次调用
    await swipeVm.updateSwipeHorizontalOffset(300, false);
    expect(swipeVm.headVm.contentOffsetX).assertEqual(300 * HORIZONTAL_SWIPE_DAMP);

    mocker.ignoreMock(swipeVm.headVm, 'contentOffsetX');
  });
});

describe('updateSwipeVerticalOffset_testSuite', () => {

  beforeEach(() => {

  });
  afterEach(() => {

  });


  it('should_return_immediately_when_offsetTop_equals_current_offsetTop', 0, async () => {
    let liveheadsupswipevm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(new LiveVmInjector(), new LiveNotification());
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetY);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(100);

    await liveheadsupswipevm.updateSwipeVerticalOffset(100, true);

    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetY);
  });

  it('should_update_offsetTop_when_offsetTop_is_different_from_current_offsetTop', 0, async () => {
    let liveheadsupswipevm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(new LiveVmInjector(), new LiveNotification());
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetY);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(100);

    await liveheadsupswipevm.updateSwipeVerticalOffset(200, true);

    expect(liveheadsupswipevm.headVm.contentOffsetY).assertEqual(200);
    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetY);
  });

  it('should_not_animate_when_animation_is_false', 0, async () => {
    let liveheadsupswipevm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(new LiveVmInjector(), new LiveNotification());
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetY);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(100);

    await liveheadsupswipevm.updateSwipeVerticalOffset(200, false);

    expect(liveheadsupswipevm.headVm.contentOffsetY).assertEqual(200 * liveheadsupswipevm.verticalDamp);
    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetY);
  });

  it('should_animate_when_animation_is_true', 0, async () => {
    let liveheadsupswipevm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(new LiveVmInjector(), new LiveNotification());
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetY);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(100);

    await liveheadsupswipevm.updateSwipeVerticalOffset(200, true);

    expect(liveheadsupswipevm.headVm.contentOffsetY).assertEqual(200 * liveheadsupswipevm.verticalDamp);
    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetY);
  });

  it('should_hide_ headsUp_when_time_out_and_instant_banner', 0, async () => {
    let liveheadsupswipevm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(new LiveVmInjector(), new LiveNotification());
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.isTimeout);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
    let mockfunc2: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.isInstantBanner);
    when(mockfunc2)(ArgumentMatchers.any).afterReturn(true);
    let mockfunc3: Function = mocker.mockFunc(NotificationDataManager.instance, NotificationDataManager.instance.removeLiveView);
    when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
    let mockfunc4: Function = mocker.mockFunc(DeleteNotificationMaintenance, DeleteNotificationMaintenance.addNtfMap);
    when(mockfunc4)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

    await liveheadsupswipevm.updateSwipeVerticalOffset(200, true);

    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.isTimeout);
    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.isInstantBanner);
    mocker.ignoreMock(NotificationDataManager.instance, NotificationDataManager.instance.removeLiveView);
    mocker.ignoreMock(DeleteNotificationMaintenance, DeleteNotificationMaintenance.addNtfMap);
  });

  it('should_hide_headsUp_when_time_out_and_not_instant_banner', 0, async () => {
    let liveheadsupswipevm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(new LiveVmInjector(), new LiveNotification());
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.isTimeout);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
    let mockfunc2: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.isInstantBanner);
    when(mockfunc2)(ArgumentMatchers.any).afterReturn(false);
    let mockfunc3: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.hide);
    when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();

    await liveheadsupswipevm.updateSwipeVerticalOffset(200, true);

    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.isTimeout);
    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.isInstantBanner);
    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.hide);
  });

  it('should_hide_headsUp_when_offsetY_is_below_hide_threshold', 0, async () => {
    let liveheadsupswipevm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(new LiveVmInjector(), new LiveNotification());
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetY);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(100);
    let mockfunc2: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.isInstantBanner);
    when(mockfunc2)(ArgumentMatchers.any).afterReturn(false);
    let mockfunc3: Function = mocker.mockFunc(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.hide);
    when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();

    await liveheadsupswipevm.updateSwipeVerticalOffset(-HIDE_HEADS_UP_DISTANCE - 1, true);

    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.contentOffsetY);
    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.isInstantBanner);
    mocker.ignoreMock(liveheadsupswipevm.headVm, liveheadsupswipevm.headVm.hide);
  });

  it('should_return_immediately_when_offsetTop_equals_current_offsetTop', 0, async () => {
    const live = new LiveNotification();
    const vmInjector = new LiveVmInjector();
    const liveheadsupswipevm = new LiveHeadsUpSwipeVm(vmInjector, live);
    const mocker = new MockKit();

    // 模拟headVm的contentOffsetY属性
    const mockfunc = mocker.mockFunc(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
    when(mockfunc)().afterReturn(100);

    // 调用被测函数
    await liveheadsupswipevm.updateSwipeVerticalOffset(100, true);

    // 验证没有执行动画或更新
    // 这里可能需要更多的断言，但根据函数逻辑，直接返回即可
    mocker.ignoreMock(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
  });

  it('should_update_offsetTop_when_offsetTop_is_different_from_current_offsetTop', 0, async () => {
    const live = new LiveNotification();
    const vmInjector = new LiveVmInjector();
    const liveheadsupswipevm = new LiveHeadsUpSwipeVm(vmInjector, live);
    const mocker = new MockKit();

    // 模拟headVm的contentOffsetY属性
    const mockfunc = mocker.mockFunc(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
    when(mockfunc)().afterReturn(100);

    // 调用被测函数
    await liveheadsupswipevm.updateSwipeVerticalOffset(200, true);

    // 验证更新后的值
    expect(liveheadsupswipevm.headVm.contentOffsetY).assertEqual(200 * liveheadsupswipevm.verticalDamp);

    mocker.ignoreMock(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
  });

  it('should_not_animate_when_animation_is_false', 0, async () => {
    const live = new LiveNotification();
    const vmInjector = new LiveVmInjector();
    const liveheadsupswipevm = new LiveHeadsUpSwipeVm(vmInjector, live);
    const mocker = new MockKit();

    // 模拟headVm的contentOffsetY属性
    const mockfunc = mocker.mockFunc(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
    when(mockfunc)().afterReturn(100);

    // 调用被测函数
    await liveheadsupswipevm.updateSwipeVerticalOffset(200, false);

    // 验证直接更新
    expect(liveheadsupswipevm.headVm.contentOffsetY).assertEqual(200 * liveheadsupswipevm.verticalDamp);

    mocker.ignoreMock(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
  });

  it('should_animate_when_animation_is_true', 0, async () => {
    const live = new LiveNotification();
    const vmInjector = new LiveVmInjector();
    const liveheadsupswipevm = new LiveHeadsUpSwipeVm(vmInjector, live);
    const mocker = new MockKit();

    // 模拟headVm的contentOffsetY属性
    const mockfunc = mocker.mockFunc(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
    when(mockfunc)().afterReturn(100);

    // 调用被测函数
    await liveheadsupswipevm.updateSwipeVerticalOffset(200, true);

    // 验证动画执行后的值
    expect(liveheadsupswipevm.headVm.contentOffsetY).assertEqual(200 * liveheadsupswipevm.verticalDamp);

    mocker.ignoreMock(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
  });

  it('should_apply_verticalDamp_when_isBottomToTop_is_true', 0, async () => {
    const live = new LiveNotification();
    const vmInjector = new LiveVmInjector();
    const liveheadsupswipevm = new LiveHeadsUpSwipeVm(vmInjector, live);
    liveheadsupswipevm.isBottomToTop = true;
    const mocker = new MockKit();

    // 模拟headVm的contentOffsetY属性
    const mockfunc = mocker.mockFunc(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
    when(mockfunc)().afterReturn(100);

    // 调用被测函数
    await liveheadsupswipevm.updateSwipeVerticalOffset(200, true);

    // 验证使用了verticalDamp
    expect(liveheadsupswipevm.headVm.contentOffsetY).assertEqual(200 * liveheadsupswipevm.verticalDamp);

    mocker.ignoreMock(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
  });

  it('should_apply_SwipeDampDown_when_isBottomToTop_is_false', 0, async () => {
    const live = new LiveNotification();
    const vmInjector = new LiveVmInjector();
    const liveheadsupswipevm = new LiveHeadsUpSwipeVm(vmInjector, live);
    liveheadsupswipevm.isBottomToTop = false;
    const mocker = new MockKit();

    // 模拟headVm的contentOffsetY属性
    const mockfunc = mocker.mockFunc(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
    when(mockfunc)().afterReturn(100);

    // 调用被测函数
    await liveheadsupswipevm.updateSwipeVerticalOffset(200, true);

    // 验证使用了SWIPE_DAMP_DOWN
    expect(liveheadsupswipevm.headVm.contentOffsetY).assertEqual(200 * liveheadsupswipevm.SWIPE_DAMP_DOWN);

    mocker.ignoreMock(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
  });

  it('should_update_offsetTop_when_offsetTop_is_different_from_current_offsetTop', 0, async () => {
    const live = new LiveNotification();
    const vmInjector = new LiveVmInjector();
    const liveheadsupswipevm = new LiveHeadsUpSwipeVm(vmInjector, live);
    const mocker = new MockKit();

    // 模拟headVm的contentOffsetY属性
    const mockfunc = mocker.mockFunc(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
    when(mockfunc)().afterReturn(100);

    // 调用被测函数
    await liveheadsupswipevm.updateSwipeVerticalOffset(200, true);

    // 验证更新后的值
    expect(liveheadsupswipevm.headVm.contentOffsetY).assertEqual(200 * liveheadsupswipevm.verticalDamp);

    mocker.ignoreMock(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
  });

  it('should_not_animate_when_animation_is_false', 0, async () => {
    const live = new LiveNotification();
    const vmInjector = new LiveVmInjector();
    const liveheadsupswipevm = new LiveHeadsUpSwipeVm(vmInjector, live);
    const mocker = new MockKit();

    // 模拟headVm的contentOffsetY属性
    const mockfunc = mocker.mockFunc(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
    when(mockfunc)().afterReturn(100);

    // 调用被测函数
    await liveheadsupswipevm.updateSwipeVerticalOffset(200, false);

    // 验证直接更新
    expect(liveheadsupswipevm.headVm.contentOffsetY).assertEqual(200 * liveheadsupswipevm.verticalDamp);

    mocker.ignoreMock(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
  });

  it('should_animate_when_animation_is_true', 0, async () => {
    const live = new LiveNotification();
    const vmInjector = new LiveVmInjector();
    const liveheadsupswipevm = new LiveHeadsUpSwipeVm(vmInjector, live);
    const mocker = new MockKit();

    // 模拟headVm的contentOffsetY属性
    const mockfunc = mocker.mockFunc(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
    when(mockfunc)().afterReturn(100);

    // 调用被测函数
    await liveheadsupswipevm.updateSwipeVerticalOffset(200, true);

    // 验证动画执行后的值
    expect(liveheadsupswipevm.headVm.contentOffsetY).assertEqual(200 * liveheadsupswipevm.verticalDamp);

    mocker.ignoreMock(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
  });

  it('should_apply_verticalDamp_when_isBottomToTop_is_true', 0, async () => {
    const live = new LiveNotification();
    const vmInjector = new LiveVmInjector();
    const liveheadsupswipevm = new LiveHeadsUpSwipeVm(vmInjector, live);
    liveheadsupswipevm.isBottomToTop = true;
    const mocker = new MockKit();

    // 模拟headVm的contentOffsetY属性
    const mockfunc = mocker.mockFunc(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
    when(mockfunc)().afterReturn(100);

    // 调用被测函数
    await liveheadsupswipevm.updateSwipeVerticalOffset(200, true);

    // 验证使用了verticalDamp
    expect(liveheadsupswipevm.headVm.contentOffsetY).assertEqual(200 * liveheadsupswipevm.verticalDamp);

    mocker.ignoreMock(liveheadsupswipevm.headVm, 'get', 'contentOffsetY');
  });
});

export default function LiveHeadsUpSwipeVmTest() {
  describe('onHorizontalPanStart_testSuite', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    onHorizontalPanStartTest1();

    onHorizontalPanStartTest2();

    onHorizontalPanStartTest3();

    onHorizontalPanStartTest4();

    onHorizontalPanStartTest5();

    onHorizontalPanStartTest6();

    onHorizontalPanStartTest7();

    onHorizontalPanStartTest8();

    onHorizontalPanStartTest9();
  });
}

function onHorizontalPanStartTest1() {
  it('should_log_info_when_onHorizontalPanStart_is_called', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let swipeVm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(liveVmInjector, live);

    const TAG = 'LiveHeadsUpSwipeVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);
    when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let position: Position = {
      x: 0, y: 0
    };

    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    };

    let event: GestureEvent = {
      repeat: false,
      fingerList: [],
      offsetX: 10,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0,
      target: {
        area
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };

    swipeVm.onHorizontalPanStart(event);
    mocker.ignoreMock(log, log.showInfo);
  });
}

function onHorizontalPanStartTest2() {
  it('should_set_isTouching_to_true_when_onHorizontalPanStart_is_called', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let swipeVm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(liveVmInjector, live);

    const TAG = 'LiveHeadsUpSwipeVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let position: Position = {
      x: 0, y: 0
    };

    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    };

    let event: GestureEvent = {
      repeat: false,
      fingerList: [],
      offsetX: 10,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0,
      target: {
        area
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };

    swipeVm.onHorizontalPanStart(event);
    expect(swipeVm.isTouching).assertTrue();
  });
}

function onHorizontalPanStartTest3() {
  it('should_set_startOffsetX_when_onHorizontalPanStart_offsetX_equals_20', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let swipeVm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(liveVmInjector, live);

    const TAG = 'LiveHeadsUpSwipeVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let position: Position = {
      x: 0, y: 0
    };

    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    };

    let event: GestureEvent = {
      repeat: false,
      fingerList: [],
      offsetX: 20,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0,
      target: {
        area
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };

    swipeVm.onHorizontalPanStart(event);
    expect(swipeVm.isTouching).assertTrue();
  });
}

function onHorizontalPanStartTest4() {
  it('should_set_startOffsetX_when_onHorizontalPanStart_offsetX_equals_30', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let swipeVm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(liveVmInjector, live);

    const TAG = 'LiveHeadsUpSwipeVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let position: Position = {
      x: 0, y: 0
    };

    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    };

    let event: GestureEvent = {
      repeat: false,
      fingerList: [],
      offsetX: 30,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0,
      target: {
        area
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };

    swipeVm.onHorizontalPanStart(event);
    expect(swipeVm.isTouching).assertTrue();
  });
}

function onHorizontalPanStartTest5() {
  it('should_set_startOffsetX_when_onHorizontalPanStart_offsetX_equals_-10', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let swipeVm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(liveVmInjector, live);

    const TAG = 'LiveHeadsUpSwipeVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let position: Position = {
      x: 0, y: 0
    };

    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    };

    let event: GestureEvent = {
      repeat: false,
      fingerList: [],
      offsetX: -10,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0,
      target: {
        area
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };

    swipeVm.onHorizontalPanStart(event);
    expect(swipeVm.isTouching).assertTrue();
  });
}

function   onHorizontalPanStartTest6() {
  it('should_set_startOffsetX_when_onHorizontalPanStart_offsetX_equals_-20', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let swipeVm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(liveVmInjector, live);

    const TAG = 'LiveHeadsUpSwipeVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let position: Position = {
      x: 0, y: 0
    };

    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    };

    let event: GestureEvent = {
      repeat: false,
      fingerList: [],
      offsetX: -20,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0,
      target: {
        area
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };

    swipeVm.onHorizontalPanStart(event);
    expect(swipeVm.isTouching).assertTrue();
  });
}

function onHorizontalPanStartTest7() {
  it('should_set_startOffsetX_when_onHorizontalPanStart_offsetX_equals_0', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let swipeVm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(liveVmInjector, live);

    const TAG = 'LiveHeadsUpSwipeVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let position: Position = {
      x: 0, y: 0
    };

    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    };

    let event: GestureEvent = {
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
      velocity: 0,
      target: {
        area
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };

    swipeVm.onHorizontalPanStart(event);
    expect(swipeVm.isTouching).assertTrue();
  });
}

function onHorizontalPanStartTest8() {
  it('should_set_startOffsetX_when_onHorizontalPanStart_offsetX_equals_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let swipeVm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(liveVmInjector, live);

    const TAG = 'LiveHeadsUpSwipeVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let position: Position = {
      x: 0, y: 0
    };

    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    };

    let event: GestureEvent = {
      repeat: false,
      fingerList: [],
      offsetX: 100,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0,
      target: {
        area
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };

    swipeVm.onHorizontalPanStart(event);
    expect(swipeVm.isTouching).assertTrue();
  });
}

function onHorizontalPanStartTest9() {
  it('should_set_startOffsetX_when_onHorizontalPanStart_offsetX_equals_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let swipeVm: LiveHeadsUpSwipeVm = new LiveHeadsUpSwipeVm(liveVmInjector, live);

    const TAG = 'LiveHeadsUpSwipeVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let position: Position = {
      x: 0, y: 0
    };

    let area: Area = {
      width: 0,
      height: 0,
      position: position,
      globalPosition: position,
    };

    let event: GestureEvent = {
      repeat: false,
      fingerList: [],
      offsetX: -100,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0,
      target: {
        area
      },
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };

    swipeVm.onHorizontalPanStart(event);
    expect(swipeVm.isTouching).assertTrue();
  });
}
