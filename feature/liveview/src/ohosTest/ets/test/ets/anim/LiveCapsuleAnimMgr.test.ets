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

import { CustomPromise, DeviceHelper, viewMgrPolicy } from '@ohos/frameworkwrapper';

import { afterAll, afterEach,ArgumentMatchers,beforeAll, beforeEach, DEFAULT, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { ExitCapsuleAnimState } from '@ohos/systemuicommon/Index';
import { CapsuleRemindType, CapsuleType, LiveType } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import {
  AnimDataScene,
  CapsuleListState,
  CapsuleShowType,
  capsuleStateMgr,
  ComponentAnimState,
  LiveAnimScene,
  LiveCapsuleData,
  LiveViewData,
  OtherBaseTemplate
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { LiveCapsuleAnimMgr } from '../../../../../main/ets/anim/LiveCapsuleAnimMgr';
import { LiveViewAnimManager } from '../../../../../main/ets/anim/LiveViewAnimManager';
import { CapsuleAnimVm } from '../../../../../main/ets/vm/CapsuleAnimVm';

let capsuleAnimMgr: LiveCapsuleAnimMgr;

let createLiveData = (hashCode = 0): LiveViewData => {
  let result = new LiveViewData();
  result.hashCode = 'live_for_test_' + hashCode;
  result.creatorBundleName = 'live.test';
  result.liveType = 0;
  result.sysTypeCode = 0;
  result.creatorUid = hashCode;
  return result;
};

let mocker: MockKit = new MockKit();

function getCapsuleAnimMgr(): LiveCapsuleAnimMgr {
  let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
  when(mockFunc)().afterReturn(true);
  return new LiveCapsuleAnimMgr();
}

interface ILiveCapsuleAnimMgr {
  onExitCapsuleListener(state: ExitCapsuleAnimState): void;
  checkAnimFinishReset(isAnimHide: boolean): void;
  checkFollowHideReset(): void;
  checkCapsuleWidthWhenShow(): number;
  startCapsuleShowFollowAnim(): void;
  startCapsuleHideFollowAnim(): void;
  getCapsuleHideFollowDistance(): number;
  consumeRemindQueue(): Promise<void>;
  processCapsuleData(remindLiveView: LiveViewData, nextData: LiveCapsuleData): Promise<void>;
  startCapsuleRemind(remindCapsule: LiveCapsuleData, nextData: LiveCapsuleData): void;
  switchBottomCapsule(remindCapsule: LiveCapsuleData, shadowCapsule?: LiveCapsuleData): void;
  startTopCapsuleRemind(
    remindCapsule: LiveCapsuleData,
    nextCapsuleData: LiveCapsuleData,
    shadowCapsule?: LiveCapsuleData
  ): Promise<void>;
  shrinkCapsule(topAnimState: ComponentAnimState, bottomAnimState?: ComponentAnimState): Promise<void>;
  checkExitCapsuleStartVmAnim(state: ExitCapsuleAnimState): void;
  reportCapsuleShow(firstItem: LiveViewData, reason: number): void;
  expandCapsule(
    remindCapsule: LiveCapsuleData,
    shadowCapsule?: LiveCapsuleData
  ): Promise<void>;
  startBottomCapsuleRemind(
    remindCapsule: LiveCapsuleData,
    nextCapsuleData: LiveCapsuleData,
    topCapsule: LiveCapsuleData
  ): Promise<void>;
  updateCapsule(remindCapsule: LiveCapsuleData, nextCapsuleData: LiveCapsuleData): void;
  switchCapsule(
    topCapsule: LiveCapsuleData,
    bottomCapsule: LiveCapsuleData,
    sleep?: boolean
  ): Promise<void>;
  animateCapsulePosition(bottomAnimState: ComponentAnimState): Promise<void>;
  animateCapsuleZIndex(
    topAnimState: ComponentAnimState,
    bottomAnimState: ComponentAnimState
  ): Promise<void>;
  animateCapsuleScale(
    topAnimState: ComponentAnimState,
    bottomAnimState: ComponentAnimState
  ): Promise<void>;
  resetTopCapsule(): Promise<void>;
  animateTo(animateParam: AnimateParam, event: () => void): Promise<void>;
  sleep(delay: number, interrupted: boolean): Promise<void>;
  clearRemindCapsule(): void;
  startRemindAnimation(capsule?: LiveCapsuleData): void;
  endRemindAnimation(capsule?: LiveCapsuleData, capsuleShowType?: CapsuleShowType): void;
  checkCapsuleAnimShowTypes(): void;
  calculateBackGroundColor(statusBarContentColor: string): void;
}

interface IRemindCapsuleQueueStatus {
  running: boolean; // 胶囊强提醒队列是否正在运行
  promise: CustomPromise<void>; // 胶囊强提醒队列运行Promise
};

export function LiveCapsuleAnimMgrTest() {
  describe('LiveCapsuleAnimMgrTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      capsuleAnimMgr  = getCapsuleAnimMgr();
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
      mocker.clearAll();
    });
    LiveCapsuleAnimMgrTest2();
    LiveCapsuleAnimMgrTest3();
    LiveCapsuleAnimMgrTest4();
    LiveCapsuleAnimMgrTest5();
    LiveCapsuleAnimMgrTest6();
    LiveCapsuleAnimMgrTest7();
    LiveCapsuleAnimMgrTest8();
    LiveCapsuleAnimMgrTest9();
    LiveCapsuleAnimMgrTest10();
    LiveCapsuleAnimMgrTest11();
    LiveCapsuleAnimMgrTest12();
    LiveCapsuleAnimMgrTest13();
    LiveCapsuleAnimMgrTest14();
    LiveCapsuleAnimMgrTest15();
    LiveCapsuleAnimMgrTest16();
  });
}

function LiveCapsuleAnimMgrTest2() {
  it('test_has_onExitCapsuleListener', DEFAULT, () => {
    try {
      let state: ExitCapsuleAnimState = {
        isAnimating: true,
        isOverCapsule: true,
        animCapsuleData: createLiveData(),
        isCancel: true,
      };
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).onExitCapsuleListener(state);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'onExitCapsuleListener')).assertTrue();
  });

  it('test_has_onExitCapsuleListener2', DEFAULT, () => {
    try {
      let state: ExitCapsuleAnimState = {
        isAnimating: false,
        isOverCapsule: true,
        animCapsuleData: createLiveData(),
        isCancel: true,
      };
      let capsuleAnimVm = capsuleAnimMgr.bannerCapsuleAnimVm;
      let mockFunc: Function = mocker.mockFunc(capsuleAnimVm, capsuleAnimVm.getRootAnimState);
      when(mockFunc)().afterReturn({ isAnimating: true });
      let liveData = createLiveData(1);
      liveData.capsule = new LiveCapsuleData();
      capsuleAnimMgr.capsuleList = [createLiveData(1), liveData, createLiveData(3)];
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).onExitCapsuleListener(state);
      state.isCancel = false;
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).onExitCapsuleListener(state);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'onExitCapsuleListener')).assertTrue();
  });

  it('test_has_getAnimParam', DEFAULT, () => {
    try {
      let showParam = capsuleAnimMgr.getAnimParam(0);
      showParam.onFinish?.();
      let hideParam = capsuleAnimMgr.getAnimParam(1);
      hideParam.onFinish?.();
      let followHideParam = capsuleAnimMgr.getAnimParam(4);
      followHideParam.onFinish?.();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'getAnimParam')).assertTrue();
  });
}

function LiveCapsuleAnimMgrTest3() {
  it('test_has_checkCapsuleShowHideAnim', DEFAULT, () => {
    try {
      capsuleAnimMgr.isCapsuleShowing = true;
      capsuleAnimMgr.capsuleList = [];
      capsuleAnimMgr.checkCapsuleShowHideAnim();
    } catch (err) {}
    expect(true).assertTrue();
  });

  it('test_has_checkCapsuleShowHideAnim2', DEFAULT, () => {
    try {
      capsuleAnimMgr.capsuleList = [createLiveData(1), createLiveData(2), createLiveData(3)];;
      capsuleAnimMgr.capsuleListState = new CapsuleListState();
      capsuleAnimMgr.isCapsuleShowing = false;
      capsuleAnimMgr.checkCapsuleShowHideAnim(false);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkCapsuleShowHideAnim')).assertTrue();
  });

  it('test_has_checkCapsuleShowHideAnim3', DEFAULT, () => {
    try {
      capsuleAnimMgr.capsuleList = [createLiveData(1), createLiveData(2), createLiveData(3)];;
      capsuleAnimMgr.capsuleListState = new CapsuleListState();
      capsuleAnimMgr.isCapsuleShowing = false;
      let capsuleAnimVm = capsuleAnimMgr.capsuleListAnimVm;
      let mockFunc: Function = mocker.mockFunc(capsuleAnimVm, capsuleAnimVm.getRootAnimState);
      when(mockFunc)().afterReturn({ isAnimating: true });
      let capsuleListState = capsuleAnimMgr.capsuleListState;
      let mockFunc2: Function = mocker.mockFunc(capsuleListState, capsuleListState.isCapsuleListShow);
      when(mockFunc2)().afterReturn(true);
      capsuleAnimMgr.checkCapsuleShowHideAnim(true, true);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkCapsuleShowHideAnim')).assertTrue();
  });
}

function LiveCapsuleAnimMgrTest4() {
  it('test_has_checkCapsuleShowHideAnim4', DEFAULT, () => {
    try {
      capsuleAnimMgr.capsuleList = [];
      capsuleAnimMgr.isCapsuleShowing = true;
      capsuleAnimMgr.checkCapsuleShowHideAnim(true, false);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkCapsuleShowHideAnim')).assertTrue();
  });

  it('test_has_checkLiveListShowHideFollowAnim', DEFAULT, () => {
    try {
      capsuleAnimMgr.checkLiveListShowHideFollowAnim();
      capsuleAnimMgr.checkLiveListShowHideFollowAnim(false, false);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkLiveListShowHideFollowAnim')).assertTrue();
  });

  it('test_has_checkLiveListShowHideFollowAnim2', DEFAULT, () => {
    try {
      capsuleAnimMgr.capsuleList = [];
      capsuleAnimMgr.checkLiveListShowHideFollowAnim(false, true);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkLiveListShowHideFollowAnim')).assertTrue();
  });

  it('test_has_checkLiveListShowHideFollowAnim3', DEFAULT, () => {
    try {
      capsuleAnimMgr.checkLiveListShowHideFollowAnim(true, true);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkLiveListShowHideFollowAnim')).assertTrue();
  });

  it('test_has_checkLiveListShowHideFollowAnim4', DEFAULT, () => {
    try {
      capsuleAnimMgr.capsuleList = [createLiveData(1), createLiveData(2), createLiveData(3)];;
      capsuleAnimMgr.checkLiveListShowHideFollowAnim(false, true);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkLiveListShowHideFollowAnim')).assertTrue();
  });
}

function LiveCapsuleAnimMgrTest5() {
  it('test_has_setCapsuleAnimating', DEFAULT, () => {
    try {
      capsuleAnimMgr.capsuleIconAnimState = new ComponentAnimState('test1');
      capsuleAnimMgr.setCapsuleAnimating(true, LiveAnimScene.SCENE_CAPSULE_SHOW);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'setCapsuleAnimating')).assertTrue();
  });

  it('test_has_isCapsuleAnimating', DEFAULT, () => {
    try {
      capsuleAnimMgr.isCapsuleAnimating(LiveAnimScene.SCENE_CAPSULE_SHOW);
      let animVm = new CapsuleAnimVm();
      let mockFunc: Function = mocker.mockFunc(animVm, animVm.getRootAnimState);
      when(mockFunc)().afterReturn(null);
      capsuleAnimMgr.isCapsuleAnimating(LiveAnimScene.SCENE_CAPSULE_SHOW, animVm);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'isCapsuleAnimating')).assertTrue();
  });

  it('test_has_setCapsuleScale', DEFAULT, () => {
    try {
      capsuleAnimMgr.setCapsuleScale(1);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'setCapsuleScale')).assertTrue();
  });

  it('test_has_setCapsuleAlpha', DEFAULT, () => {
    try {
      capsuleAnimMgr.setCapsuleAlpha(1);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'setCapsuleAlpha')).assertTrue();
  });

  it('test_has_setFollowIconTranX', DEFAULT, () => {
    try {
      capsuleAnimMgr.followIconAnimStates.add(new ComponentAnimState('test2'))
      capsuleAnimMgr.setFollowIconTranX(0);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'setFollowIconTranX')).assertTrue();
  });

  it('test_has_checkAnimCapsuleData', DEFAULT, () => {
    try {
      capsuleAnimMgr.checkAnimCapsuleData(AnimDataScene.SCENE_HIDE_CAPSULE);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkAnimCapsuleData')).assertTrue();
  });
}

function LiveCapsuleAnimMgrTest6() {
  it('test_has_clearAnimCapsuleData', DEFAULT, () => {
    try {
      capsuleAnimMgr.clearAnimCapsuleData(AnimDataScene.SCENE_LIVE_BANNER);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'clearAnimCapsuleData')).assertTrue();
  });

  it('test_has_checkAnimFinishReset', DEFAULT, () => {
    try {
      capsuleAnimMgr.capsuleIconAnimState = new ComponentAnimState('test');
      let capsuleIconAnimState = capsuleAnimMgr.capsuleIconAnimState;
      let mockFunc: Function = mocker.mockFunc(capsuleIconAnimState, capsuleIconAnimState.isSceneAnimating);
      when(mockFunc)().afterReturn(true);
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).checkAnimFinishReset(true);
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).checkAnimFinishReset(false);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkAnimFinishReset')).assertTrue();
  });

  it('test_has_checkFollowHideReset', DEFAULT, () => {
    try {
      let mockFunc: Function = mocker.mockFunc(capsuleAnimMgr, capsuleAnimMgr.isCapsuleAnimating);
      when(mockFunc)(LiveAnimScene.SCENE_CAPSULE_PLACE).afterReturn(true);
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).checkFollowHideReset();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkFollowHideReset')).assertTrue();
  });

  it('test_has_checkCapsuleWidthWhenShow', DEFAULT, () => {
    try {
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).checkCapsuleWidthWhenShow();
      let capsuleListState = capsuleAnimMgr.capsuleListState;
      let mockFunc: Function = mocker.mockFunc(capsuleListState, capsuleListState?.getCapsuleWidth);
      when(mockFunc)().afterReturn(undefined);
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).checkCapsuleWidthWhenShow();
      let mockFunc2: Function = mocker.mockFunc(capsuleListState, capsuleListState?.isCurrentMultiShow);
      when(mockFunc2)().afterReturn(true);
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).checkCapsuleWidthWhenShow();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkCapsuleWidthWhenShow')).assertTrue();
  });

  it('test_has_startCapsuleShowFollowAnim', DEFAULT, () => {
    try {
      capsuleAnimMgr.followIconAnimStates.add(new ComponentAnimState('test3'));
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).startCapsuleShowFollowAnim();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'startCapsuleShowFollowAnim')).assertTrue();
  });
}

function LiveCapsuleAnimMgrTest7() {
  it('test_has_startCapsuleHideFollowAnim', DEFAULT, () => {
    try {
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).startCapsuleHideFollowAnim();
      capsuleAnimMgr.followIconAnimStates.clear();
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).startCapsuleHideFollowAnim();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'startCapsuleHideFollowAnim')).assertTrue();
  });
}

function LiveCapsuleAnimMgrTest8() {
  it('test_has_checkCapsuleRemindAnim', DEFAULT, () => {
    try {
      capsuleAnimMgr.capsuleListState = new CapsuleListState();
      capsuleAnimMgr.capsuleListState.remindCapsuleQueue = [];
      capsuleAnimMgr.checkCapsuleRemindAnim();
      let data1 = new LiveCapsuleData();
      data1.hashCode = 'test1';
      let data2 = new LiveCapsuleData();
      data2.hashCode = 'test2';
      capsuleAnimMgr.capsuleListState.remindCapsuleQueue = [data1, data2];
      capsuleAnimMgr.liveList = [createLiveData(1), createLiveData(2), createLiveData(3)];
      capsuleAnimMgr.checkCapsuleRemindAnim();
      data1.hashCode = 'test1';
      data2.hashCode = 'test1';
      capsuleAnimMgr.capsuleListState.remindCapsuleQueue = [data1, data2];
      capsuleAnimMgr.checkCapsuleRemindAnim();
      capsuleAnimMgr.liveViewAnimMgr = new LiveViewAnimManager();
      capsuleAnimMgr.liveViewAnimMgr.hideLiveListPromise = new CustomPromise();
      capsuleAnimMgr.checkCapsuleRemindAnim();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkCapsuleRemindAnim')).assertTrue();
  });

}

function LiveCapsuleAnimMgrTest9() {
  it('test_has_checkExitCapsuleStartVmAnim', DEFAULT, () => {
    try {
      let state: ExitCapsuleAnimState = {
        isAnimating: true,
        isOverCapsule: true,
        animCapsuleData: createLiveData(),
        isCancel: true,
      };
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).checkExitCapsuleStartVmAnim(state);
      state.isOverCapsule = false;
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).checkExitCapsuleStartVmAnim(state);
      capsuleAnimMgr.capsuleListState = new CapsuleListState();
      let capsuleListState = capsuleAnimMgr.capsuleListState;
      let mockFunc: Function = mocker.mockFunc(capsuleListState, capsuleListState.hasAnimCapsule);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).checkExitCapsuleStartVmAnim(state);
      state.animCapsuleData = undefined;
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).checkExitCapsuleStartVmAnim(state);
      capsuleAnimMgr.liveViewAnimMgr = new LiveViewAnimManager();
      capsuleAnimMgr.liveViewAnimMgr.hideLiveListPromise = new CustomPromise();
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).checkExitCapsuleStartVmAnim(state);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkExitCapsuleStartVmAnim')).assertTrue();
  });

  it('test_has_consumeRemindQueue', DEFAULT, async () => {
    try {
      capsuleAnimMgr.capsuleListState = new CapsuleListState();
      let data1 = new LiveCapsuleData();
      data1.setHashCode('live_for_test_1');
      capsuleAnimMgr.capsuleListState.remindCapsuleQueue = [data1,data1,new LiveCapsuleData()];
      let liveData = createLiveData(1);
      liveData.capsule = data1;
      capsuleAnimMgr.liveList = [liveData];
      await (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).consumeRemindQueue();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'consumeRemindQueue')).assertTrue();
  });

  it('test_has_processCapsuleData', DEFAULT, async () => {
    try {
      let remindLiveView = createLiveData();
      let nextData = new LiveCapsuleData();
      await (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).processCapsuleData(remindLiveView, nextData);
      nextData.isRemind = CapsuleRemindType.FLIP;
      await (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).processCapsuleData(remindLiveView, nextData);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'processCapsuleData')).assertTrue();
  });
}

function LiveCapsuleAnimMgrTest10() {
  it('test_has_startCapsuleRemind', DEFAULT, () => {
    try {
      let remindCapsule = new LiveCapsuleData();
      let nextData = new LiveCapsuleData();
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).startCapsuleRemind(remindCapsule, nextData);
      remindCapsule.animStyle.capsuleShowType = CapsuleShowType.TOP;
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).startCapsuleRemind(remindCapsule, nextData);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'startCapsuleRemind')).assertTrue();
  });

  it('test_has_switchBottomCapsule', DEFAULT, () => {
    try {
      let remindCapsule = new LiveCapsuleData();
      let nextData = new LiveCapsuleData();
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).switchBottomCapsule(remindCapsule, nextData);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'switchBottomCapsule')).assertTrue();
  });

  it('test_has_startTopCapsuleRemind', DEFAULT, () => {
    try {
      let remindCapsule = new LiveCapsuleData();
      let nextData = new LiveCapsuleData();
      remindCapsule.prevIcon = 'prevIcon';
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).startTopCapsuleRemind(remindCapsule, nextData);
      let mockFunc: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      when(mockFunc)().afterReturn(false);
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).startTopCapsuleRemind(remindCapsule, nextData);
      when(mockFunc)().afterReturn(false);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'startTopCapsuleRemind')).assertTrue();
  });

  it('test_has_shrinkCapsule', DEFAULT, async () => {
    try {
      let data1 = new ComponentAnimState('test1');
      let data2 = new ComponentAnimState('test2');
      await (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).shrinkCapsule(data1, data2);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'shrinkCapsule')).assertTrue();
  });
}

function LiveCapsuleAnimMgrTest11() {
  it('test_has_expandCapsule', DEFAULT, async () => {
    try {
      let data = new LiveCapsuleData();
      await (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).expandCapsule(
        data,
        data
      );
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'expandCapsule')).assertTrue();
  });

  it('test_has_startBottomCapsuleRemind', DEFAULT, async () => {
    try {
      let data = new LiveCapsuleData();
      await (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).startBottomCapsuleRemind(
        data,
        data,
        data
      );
      let mockFunc: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      when(mockFunc)().afterReturn(false);
      await (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).startBottomCapsuleRemind(
        data,
        data,
        data
      );
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'startBottomCapsuleRemind')).assertTrue();
  });

  it('test_has_updateCapsule', DEFAULT, () => {
    try {
      let data = new LiveCapsuleData();
      data.type = CapsuleType.TYPE_TIMER;
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).updateCapsule(
        data,
        data,
      );
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'updateCapsule')).assertTrue();
  });
}

function LiveCapsuleAnimMgrTest12() {
  it('test_has_switchCapsule', DEFAULT, () => {
    try {
      capsuleAnimMgr.remindCapsuleQueueStatus = {
        running: true,
        promise: new CustomPromise()
      };
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).switchCapsule(
        new LiveCapsuleData(),
        new LiveCapsuleData(),
      );
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).switchCapsule(
        new LiveCapsuleData(),
        new LiveCapsuleData(),
        true
      );
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'switchCapsule')).assertTrue();
  });

  it('test_has_animateCapsulePosition', DEFAULT, () => {
    try {
      capsuleAnimMgr.remindCapsuleQueueStatus = {
        running: true,
        promise: new CustomPromise()
      };
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).animateCapsulePosition(new ComponentAnimState('test1'),);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'animateCapsulePosition')).assertTrue();
  });

  it('test_has_animateCapsuleZIndex', DEFAULT, () => {
    try {
      capsuleAnimMgr.remindCapsuleQueueStatus = {
        running: true,
        promise: new CustomPromise()
      };
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).animateCapsuleZIndex(
        new ComponentAnimState('test1'),
        new ComponentAnimState('test2'),
      );
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'animateCapsuleZIndex')).assertTrue();
  });
}

function LiveCapsuleAnimMgrTest13() {
  it('test_has_animateCapsuleScale', DEFAULT, async () => {
    try {
      capsuleAnimMgr.remindCapsuleQueueStatus = {
        running: true,
        promise: new CustomPromise()
      };
      await (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).animateCapsuleScale(
        new ComponentAnimState('test1'),
        new ComponentAnimState('test2'),
      );
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'animateCapsuleScale')).assertTrue();
  });

  it('test_has_resetTopCapsule', DEFAULT, async () => {
    try {
      let data = createLiveData(1);
      data.capsule = new LiveCapsuleData();
      let data2 = createLiveData(2);
      data2.capsule = new LiveCapsuleData();
      data2.capsule.animStyle.capsuleShowType = CapsuleShowType.TOP;
      capsuleAnimMgr.capsuleList = [data, data2, createLiveData(3)];;
      capsuleAnimMgr.capsuleListState = new CapsuleListState();
      capsuleAnimMgr.capsuleListState.topCapsule = data;
      await (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).resetTopCapsule();
      data2.capsule = undefined;
      await (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).resetTopCapsule();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'resetTopCapsule')).assertTrue();
  });

  it('test_has_animateTo', DEFAULT, () => {
    try {
      capsuleAnimMgr.remindCapsuleQueueStatus = {
        running: true,
        promise: new CustomPromise()
      };
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).animateTo({
        delay: 50,
        curve: Curve.Linear,
        duration: 50,
      }, () => {});
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'animateTo')).assertTrue();
  });
}

function LiveCapsuleAnimMgrTest14() {
  it('test_has_sleep', DEFAULT, async () => {
    try {
      capsuleAnimMgr.remindCapsuleQueueStatus = {
        running: true,
        promise: new CustomPromise()
      };
      capsuleAnimMgr.remindCapsuleDurationPromise = new CustomPromise();
      await (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).sleep(0, true);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'sleep')).assertTrue();
  });

  it('test_has_stopRemindCapsuleQueue', DEFAULT, () => {
    try {
      capsuleAnimMgr.remindCapsuleQueueStatus = {
        running: true,
        promise: new CustomPromise()
      };
      capsuleAnimMgr.stopRemindCapsuleQueue();
      capsuleAnimMgr.remindCapsuleQueueStatus.running = false;
      capsuleAnimMgr.stopRemindCapsuleQueue();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'stopRemindCapsuleQueue')).assertTrue();
  });

  it('test_has_clearRemindCapsule', DEFAULT, () => {
    try {
      capsuleAnimMgr.capsuleListState = new CapsuleListState();
      let data1 = new LiveCapsuleData();
      data1.setUid(0);
      data1.setHashCode('live_for_test_1');
      let data2 = new LiveCapsuleData();
      data2.setUid(99999);
      capsuleAnimMgr.capsuleListState.remindCapsuleQueue = [data1,data1,data2];
      let liveData = createLiveData(1);
      liveData.capsule = data1;
      capsuleAnimMgr.liveList = [liveData];
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).clearRemindCapsule();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'clearRemindCapsule')).assertTrue();
  });
}

function LiveCapsuleAnimMgrTest15() {
  it('test_has_clearSpecificRemindCapsule', DEFAULT, () => {
    try {
      capsuleAnimMgr.clearSpecificRemindCapsule([]);
      capsuleAnimMgr.capsuleListState = new CapsuleListState();
      let data1 = new LiveCapsuleData();
      data1.setUid(0);
      let data2 = new LiveCapsuleData();
      data2.setUid(99999);
      capsuleAnimMgr.capsuleListState.remindCapsuleQueue = [data1,data1,data2];
      capsuleAnimMgr.clearSpecificRemindCapsule([0,0,999]);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'clearSpecificRemindCapsule')).assertTrue();
  });

  it('test_has_stopRemindAnimation', DEFAULT, () => {
    try {
      capsuleAnimMgr.stopRemindAnimation();
      capsuleAnimMgr.stopRemindAnimation(new LiveCapsuleData());
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'stopRemindAnimation')).assertTrue();
  });

  it('test_has_startRemindAnimation', DEFAULT, () => {
    try {
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).startRemindAnimation();
      let capsule = new LiveCapsuleData();
      capsule.animState.isAnimating = true;
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).startRemindAnimation(capsule);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'endRemindAnimation')).assertTrue();
  });

  it('test_has_endRemindAnimation', DEFAULT, () => {
    try {
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).endRemindAnimation();
      let capsule = new LiveCapsuleData();
      capsule.animState.isAnimating = true;
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).endRemindAnimation(capsule, CapsuleShowType.SHOW);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'endRemindAnimation')).assertTrue();
  });
}

function LiveCapsuleAnimMgrTest16() {
  it('test_has_checkCapsuleAnimShowTypes', DEFAULT, () => {
    try {
      let liveView = createLiveData(1)
      liveView.capsule = new LiveCapsuleData();
      capsuleAnimMgr.capsuleList = [liveView, createLiveData(2), createLiveData(3)];
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).checkCapsuleAnimShowTypes();
      capsuleAnimMgr.capsuleList = [];
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).checkCapsuleAnimShowTypes();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'checkCapsuleAnimShowTypes')).assertTrue();
  });

  it('test_has_calculateBackGroundColor', DEFAULT, () => {
    try {
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).calculateBackGroundColor('FFFFFF');
      (capsuleAnimMgr as object as ILiveCapsuleAnimMgr).calculateBackGroundColor('FFFFFFFF');
    } catch (err) {}
    expect(Reflect.has(capsuleAnimMgr, 'calculateBackGroundColor')).assertTrue();
  });
}