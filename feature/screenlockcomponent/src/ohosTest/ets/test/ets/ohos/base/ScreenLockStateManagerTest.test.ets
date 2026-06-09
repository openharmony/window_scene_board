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

import {
  screenLockStateManager,
  ScreenLockState,
  ScreenLockStateListener,
  ComponentType,
  MeshRange
} from '@ohos/screenlockcommon';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, when, MockKit } from '@ohos/hypium';
import TestConst from '../constants/TestConst';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { IUserData } from '@ohos/screenlockcommon';
import { ScreenLockStatus } from '@ohos/screenlockcommon';
import { FaceUnlockConstants, FaceUnlockVerifyState } from '@ohos/screenlockcommon';
import osAccount from '@ohos.account.osAccount';
import { display } from '@kit.ArkUI';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, 'testlog');

export default function ScreenLockStateManagerTest() {

  describe('ScreenLockStateManagerTest', (): void => {
    let mocker: MockKit;
    let screenLockStateListener: ScreenLockStateListener;
    beforeAll((): void => {
      mocker = new MockKit();
      screenLockStateListener = {
        onEnterHost: async () => {
          log.info(`Lock screen`);
        },
        onExitKeyguard: async () => {
          log.info(`Unlocking`);
        }
      };
    })

    beforeEach((): void => {
    })

    afterEach((): void => {

    })

    afterAll((): void => {
      mocker.clearAll();
    })

    it('test_onEnterOtherApp', TestConst.TEST_LEVEL, (): void => {
      screenLockStateManager.onEnterOtherApp();
      expect(screenLockStateManager.currentState).assertEqual(ScreenLockState.ENTER_OTHER_APP);
    });

    it('test_onExitKeyguard', TestConst.TEST_LEVEL, (): void => {
      screenLockStateManager.onExitKeyguard();
      expect(screenLockStateManager.currentState).assertEqual(ScreenLockState.EXIT_KEYGUARD);
    });

    it('test_onEnterBouncer', TestConst.TEST_LEVEL, (): void => {
      screenLockStateManager.onEnterBouncer();
      expect(screenLockStateManager.currentState).assertEqual(ScreenLockState.BOUNCER);
    });

    it('test_onEnterFullEditor', TestConst.TEST_LEVEL, (): void => {
      screenLockStateManager.onEnterFullEditor(ScreenLockState.THEME_EDITOR_FULL);
      expect(screenLockStateManager.currentState).assertEqual(ScreenLockState.THEME_EDITOR_FULL);
    });

    it('test_onEnterThemeEditor', TestConst.TEST_LEVEL, (): void => {
      screenLockStateManager.onEnterThemeEditor();
      expect(screenLockStateManager.currentState).assertEqual(ScreenLockState.THEME_EDITOR);
    });

    it('test_onEnterHost', TestConst.TEST_LEVEL, (): void => {
      screenLockStateManager.currentState = ScreenLockState.THEME_EDITOR;
      screenLockStateManager.onEnterHost(false);
      screenLockStateManager.onEnterHost(true);
      expect(screenLockStateManager.currentState).assertEqual(ScreenLockState.HOST);
    });

    it('test_unregisterScreenLockState', TestConst.TEST_LEVEL, (): void => {
      screenLockStateManager.currentState = ScreenLockState.THEME_EDITOR;
      screenLockStateManager.registerScreenLockState(undefined);
      screenLockStateManager.registerScreenLockState(screenLockStateListener);
      screenLockStateManager.currentState = ScreenLockState.HOST;
      screenLockStateManager.registerScreenLockState(screenLockStateListener);
      screenLockStateManager.currentState = ScreenLockState.THEME_EDITOR_FULL;
      screenLockStateManager.registerScreenLockState(screenLockStateListener);
      screenLockStateManager.unregisterScreenLockState(screenLockStateListener);
      expect(screenLockStateManager.currentState).assertEqual(ScreenLockState.THEME_EDITOR_FULL);
    });

    it('test_unregisterScreenLockState', TestConst.TEST_LEVEL, (): void => {
      screenLockStateManager.currentState = ScreenLockState.THEME_EDITOR;
      screenLockStateManager.requestUseMesh(ComponentType.TOP_HEAD,
        new MeshRange(0, 100));
      screenLockStateManager.requestUseMesh(ComponentType.CENTER_CONTENT,
        new MeshRange(0, 100));
      screenLockStateManager.requestUseMesh('729958', new MeshRange(0, 100));
      expect(screenLockStateManager.currentState).assertEqual(ScreenLockState.THEME_EDITOR);
    });

    it('test_unregisterScreenLockState_one', TestConst.TEST_LEVEL, (): void => {
      screenLockStateManager.unregisterScreenLockState(undefined);
      screenLockStateManager.unregisterScreenLockState({});
      expect(true).assertTrue();
    });

    it('test_onEnterOtherAppBorderShow', TestConst.TEST_LEVEL, (): void => {
      screenLockStateManager.onEnterOtherAppBorderShow();
      screenLockStateManager.onEnterOtherAppBorderHide();
      screenLockStateManager.getPreState();
      expect(true).assertTrue();
    });
  })
}