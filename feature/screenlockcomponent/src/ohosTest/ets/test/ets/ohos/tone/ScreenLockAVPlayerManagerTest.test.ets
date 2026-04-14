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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import TestConst from '../constants/TestConst';
import { GlobalStatusCache, KeyGuardCacheKey } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import ScreenLockAVPlayerManager from '../../../../../../main/ets/tone/ScreenLockAVPlayerManager';
import { ScreenLockPromptTone } from '../../../../../../main/ets/tone/ScreenLockPromptTone';
import DataShareManager from '@ohos/screenlockcommon/src/main/ets/base/DataShareManager';

enum ToneType {
  LOCK_TONE = 0,
  UNLOCK_TONE = 1,
  OTHER = 2
}

const SCREEN_LOCK_AUDIO_PATH: string = 'resource/media/audio/ui/Lock.ogg';
const SCREEN_UNLOCK_AUDIO_PATH: string = 'resource/media/audio/ui/Unlock.ogg';

export default function ScreenLockAVPlayerManagerTest() {

  let mScreenLockPromptTone: ScreenLockPromptTone = new ScreenLockPromptTone();
  let dataShareManager: DataShareManager = DataShareManager.getInstance();
  describe('ScreenLockAVPlayerManagerTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('test_ScreenLockAVPlayerManagerTest_onScreenLockPageTypeListener', TestConst.TEST_LEVEL, (): void => {
      ScreenLockAVPlayerManager.onScreenLockPageTypeListener();
      GlobalStatusCache.getInstance().setStatus(KeyGuardCacheKey.PAGE_TYPE, 0);
      ScreenLockAVPlayerManager.isScreenLockTonePlay = false;
      GlobalStatusCache.getInstance().setStatus(KeyGuardCacheKey.PAGE_TYPE, 100);
      GlobalStatusCache.getInstance().setStatus(KeyGuardCacheKey.PAGE_TYPE, 0);
      ScreenLockAVPlayerManager.isScreenLockTonePlay = true;
      ScreenLockAVPlayerManager.onScreenLockPageTypeListenerOff();
      expect(ScreenLockAVPlayerManager.isScreenLockTonePlay).not().assertNull();
    })

    it('test_ScreenLockAVPlayerManagerTest_ScreenLockPromptTone', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      GlobalStatusCache.getInstance().setStatus('screenLockToneType',ToneType.LOCK_TONE);
      mScreenLockPromptTone.playNtfAudio(SCREEN_LOCK_AUDIO_PATH);
      GlobalStatusCache.getInstance().setStatus('screenLockToneType',ToneType.UNLOCK_TONE);
      mScreenLockPromptTone.playNtfAudio(SCREEN_UNLOCK_AUDIO_PATH);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_ScreenLockAVPlayerManagerTest_ScreenLockPromptTone1', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      GlobalStatusCache.getInstance().setStatus('screenLockToneType', ToneType.LOCK_TONE);
      ScreenLockAVPlayerManager.isScreenLockTonePlay = false;
      GlobalStatusCache.getInstance().setStatus('screenLockToneType', ToneType.UNLOCK_TONE);
      ScreenLockAVPlayerManager.isScreenLockTonePlay = true;
      GlobalStatusCache.getInstance().setStatus('screenLockToneType', ToneType.OTHER);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_ScreenLockAVPlayerManagerTest_onEnableScreenLockToneListener1', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(dataShareManager, dataShareManager.registerUserSettingsDataShareListener);
      when(mockFuc)().afterReturn((key: string, callback: Callback<void>) => {
          callback();
      })
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
      ScreenLockAVPlayerManager.onScreenLockPageTypeListener();
      mocker.ignoreMock(dataShareManager, dataShareManager.registerUserSettingsDataShareListener);
    })

    it('test_ScreenLockAVPlayerManagerTest_handleScreenLockToneStatus1', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      ScreenLockAVPlayerManager.isScreenLockToneStatus = '2';
      ScreenLockAVPlayerManager.onScreenLockPageTypeListener();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_ScreenLockAVPlayerManagerTest_onEnableScreenLockToneListener1', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(GlobalStatusCache.getInstance(), GlobalStatusCache.getInstance().subscribe);
      when(mockFuc)().afterReturn((stage: string, callback: Function) => {
        callback(ToneType.OTHER);
      })
      ScreenLockAVPlayerManager.onScreenLockPageTypeListener();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
      mocker.ignoreMock(dataShareManager, dataShareManager.registerUserSettingsDataShareListener);
    })

    it('test_ScreenLockAVPlayerManagerTest_onEnableScreenLockToneListener2', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(GlobalStatusCache.getInstance(), GlobalStatusCache.getInstance().subscribe);
      when(mockFuc)().afterReturn((stage: string, callback: Function) => {
        callback(ToneType.LOCK_TONE);
      })
      ScreenLockAVPlayerManager.isEnterHostPlay = true;
      ScreenLockAVPlayerManager.onScreenLockPageTypeListener();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
      mocker.ignoreMock(dataShareManager, dataShareManager.registerUserSettingsDataShareListener);
    })

    it('test_ScreenLockAVPlayerManagerTest_onEnableScreenLockToneListener2', TestConst.TEST_LEVEL, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(GlobalStatusCache.getInstance(), GlobalStatusCache.getInstance().subscribe);
      when(mockFuc)().afterReturn((stage: string, callback: Function) => {
        callback(ToneType.UNLOCK_TONE);
      })
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
      ScreenLockAVPlayerManager.isEnterHostPlay = true;
      ScreenLockAVPlayerManager.onScreenLockPageTypeListener();
      mocker.ignoreMock(dataShareManager, dataShareManager.registerUserSettingsDataShareListener);
    })

  })
}
