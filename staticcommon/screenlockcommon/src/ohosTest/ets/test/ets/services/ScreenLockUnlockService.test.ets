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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when, ArgumentMatchers } from '@ohos/hypium'
import { sSCBOobeManager } from '@ohos/windowscene';
import { HandleResult, LockState,LockStateInfo,LockUnlockCallback,LockUnlockRequestHandler,PageState,
  ScreenLockStateManager,ScreenLockUnlockService,SlServerHelper,StrongAuthStateManager,SystemParamUtils } from '../../../../../main/ets/TsIndex'


export default function ScreenLockUnlockServiceTest() {
  describe('ScreenLockUnlockServiceTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('ScreenLockUnlockServiceTest_isInRequestUnlock_001', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      let result = screenLock.isInRequestUnlock;
      expect(result).assertFalse();
    })

    it('ScreenLockUnlockServiceTest_lockUnlockRequestHandler_002', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      let lockhandler: LockUnlockRequestHandler = {
        onRequestUnlock: (callback?: ((result: HandleResult) => void) | undefined): void => { },
        onRequestLock: (): void => { }
      };
      screenLock.lockUnlockRequestHandler = lockhandler;
      expect(screenLock['_lockUnlockRequestHandler']).not().assertNull();
    })

    it('ScreenLockUnlockServiceTest_enterSystem_003', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager, sSCBOobeManager.isEnable);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result = screenLock.enterSystem();
      expect(result == null).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      result = screenLock.enterSystem();
      expect(result == null).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
    })

    it('ScreenLockUnlockServiceTest_requestLock_004', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      let result = screenLock.requestLock();
      expect(result == null).assertTrue();
    })

    it('ScreenLockUnlockServiceTest_requestUnlock_005', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      let lockhandler: LockUnlockHandler = new LockUnlockHandler();
      screenLock.lockUnlockRequestHandler = lockhandler;
      let callback: LockUnlockCallback = {
        success: () => {},
        cancel: () => {},
        fail: () => {}
      };
      let result = screenLock.requestUnlock(callback);
      expect(result).assertInstanceOf('Boolean');

      if(lockhandler.handleCallback){
        lockhandler.handleCallback(HandleResult.SUCCESS);
        expect(result).assertInstanceOf('Boolean');

        lockhandler.handleCallback(HandleResult.FAIL);
        expect(result).assertInstanceOf('Boolean');

        lockhandler.handleCallback(HandleResult.WAITING);
        expect(result).assertInstanceOf('Boolean');

        lockhandler.handleCallback(HandleResult.CANCEL);
        expect(result).assertInstanceOf('Boolean');

        lockhandler.handleCallback(4);
        expect(result).assertInstanceOf('Boolean');
      }
    })

    it('ScreenLockUnlockServiceTest_delayHideRootView_006', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      let result = screenLock.delayHideRootView();
      expect(result == null).assertTrue();
    })

    it('ScreenLockUnlockServiceTest_hideRootView_007', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      let result = screenLock.hideRootView();
      expect(result == null).assertTrue();
    })

    it('ScreenLockUnlockServiceTest_notifyEarlyUnlockTransition_008', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      let result = screenLock.notifyEarlyUnlockTransition();
      expect(result == null).assertTrue();
    })

    it('ScreenLockUnlockServiceTest_doInit_009', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      let result = screenLock['doInit']();
      expect(result == null).assertTrue();
    })

    it('ScreenLockUnlockServiceTest_doRelease_010', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      screenLock['_voteTimeoutId '] = 1;
      let result = screenLock['doRelease']();
      expect(result == null).assertTrue();

      screenLock['_voteTimeoutId '] = 0;
      result = screenLock['doRelease']();
      expect(result == null).assertTrue();
    })

    it('ScreenLockUnlockServiceTest_doRelease_010', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      let result = screenLock['updateRequestUnlockCount'](true);
      expect(result == null).assertTrue();

      result = screenLock['updateRequestUnlockCount'](false);
      expect(result == null).assertTrue();
    })

    it('ScreenLockUnlockServiceTest_doScreenLockInner_011', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SlServerHelper.getInstance(), SlServerHelper.getInstance().isScreenLockDisabled);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result = screenLock['doScreenLockInner']();
      expect(result == null).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      screenLock['_firstLockScreen '] = true;
      result = screenLock['doScreenLockInner']();
      expect(result == null).assertTrue();

      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      result = screenLock['doScreenLockInner']();
      expect(result == null).assertTrue();

      mocker.clear(SlServerHelper.getInstance());
      mocker.clear(StrongAuthStateManager.getInstance());
      mocker.clearAll();
    })

    it('ScreenLockUnlockServiceTest_doScreenUnlockInner_001', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      let result = screenLock['doScreenUnlockInner']();
      expect(result == null).assertTrue();
    })

    it('ScreenLockUnlockServiceTest_doScreenUnlockInner_002', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      screenLock['_delayHideViewHelper']['_delayHideViewTimeout'] = 1;
      let result = screenLock['doScreenUnlockInner']();
      expect(result == null).assertTrue();
    })

    it('ScreenLockUnlockServiceTest_publishEvent_013', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      let result = screenLock['publishEvent'](EventName.LOCK_SCREEN);
      expect(result == null).assertTrue();
    })

    it('ScreenLockUnlockServiceTest_voteBootEvent_014', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SystemParamUtils, SystemParamUtils.setSystemParam);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result = screenLock['voteBootEvent']();
      expect(result == null).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      result = screenLock['voteBootEvent']();
      expect(result == null).assertTrue();

      mocker.clear(SystemParamUtils);
      mocker.clearAll();
    })

    it('ScreenLockUnlockServiceTest_015', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();

      let result = screenLock['_delayHideViewHelper']['delayHideView']();
      expect(result == null).assertTrue();

      screenLock['_delayHideViewHelper']['_delayHideViewTimeout'] = 1;
      result = screenLock['_delayHideViewHelper']['hideView']();
      expect(result == null).assertTrue();

      screenLock['_delayHideViewHelper']['_delayHideViewTimeout'] = 1;
      result = screenLock['_delayHideViewHelper']['clearDelayHideView']();
      expect(result == null).assertTrue();

      screenLock['_delayHideViewHelper']['_delayHideViewTimeout'] = 0;
      result = screenLock['_delayHideViewHelper']['hideView']();
      expect(result == null).assertTrue();

      screenLock['_delayHideViewHelper']['_delayHideViewTimeout'] = 0;
      result = screenLock['_delayHideViewHelper']['clearDelayHideView']();
      expect(result == null).assertTrue();
    })

    it('ScreenLockUnlockServiceTest_lockStateChangeListener_014', Level.LEVEL0, () => {
      let screenLock = ScreenLockUnlockService.getInstance();
      ScreenLockStateManager.getInstance().lockStateInfo['pageState'] = PageState.NONE;
      let info: LockStateInfo = new LockStateInfo();
      if (screenLock['_lockStateChangeListener'].onLockStateChange) {
        let result = screenLock['_lockStateChangeListener'].onLockStateChange(info);
        expect(result == null).assertTrue();
      }

      info['pageState'] = PageState.SHOW;
      if (screenLock['_lockStateChangeListener'].onLockStateChange) {
        let result = screenLock['_lockStateChangeListener'].onLockStateChange(info);
        expect(result == null).assertTrue();
      }

      info['pageState'] = PageState.HIDE;
      if (screenLock['_lockStateChangeListener'].onLockStateChange) {
        let result = screenLock['_lockStateChangeListener'].onLockStateChange(info);
        expect(result == null).assertTrue();
      }

      ScreenLockStateManager.getInstance().lockStateInfo['pageState'] = PageState.SHOW;
      info['pageState'] = PageState.NONE;
      if (screenLock['_lockStateChangeListener'].onLockStateChange) {
        let result = screenLock['_lockStateChangeListener'].onLockStateChange(info);
        expect(result == null).assertTrue();
      }

    })

  })

  class LockUnlockHandler implements LockUnlockRequestHandler {
    public handleCallback?: (result: HandleResult) => void;
    onRequestUnlock(callback?: ((result: HandleResult) => void) | undefined) : void {
      this.handleCallback = callback;
    };
    onRequestLock() : void {

    }
  }
  enum  EventName {
    LOCK_SCREEN = 'common.event.LOCK_SCREEN',
    UNLOCK_SCREEN = 'common.event.UNLOCK_SCREEN',
  }

}