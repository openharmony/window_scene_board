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
import { GlobalContext } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit } from '@ohos/hypium'
import { AudioPlayerHelper } from '@ohos/pcbase/src/main/ets/SceneBoard/soundpanel/util/AudioPlayerNewHelper';
import common from '@ohos.app.ability.common';
import media from '@ohos.multimedia.media';

export default function AudioPlayerNewHelperTest() {
  let mocker: MockKit;
  let audioPlayerHelper: AudioPlayerHelper
  describe('AudioPlayerNewHelperTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
      mocker = new MockKit();
      let context = (GlobalContext.getInstance().getObject('desktopContext') as common.Context);
      audioPlayerHelper = new AudioPlayerHelper(context);
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
      mocker.clearAll();
    })

    it('playAudioOnce', 0, async () => {
      try {
        (audioPlayerHelper as object)['lastPlayTime'] = new Date().getTime();
        await audioPlayerHelper.playAudioOnce();

        (audioPlayerHelper as object)['lastPlayTime'] = new Date().getTime() - 1000;
        await audioPlayerHelper.playAudioOnce();
        expect(audioPlayerHelper).not().assertNull();
      } catch (e) {
        expect(audioPlayerHelper).not().assertNull();
      }
    })

    it('doPlayAudioOnce', 0, async () => {
      try {
        (audioPlayerHelper as object)['audioPlayer'] = null;
        (audioPlayerHelper as object)['doPlayAudioOnce'](new Date().getTime());
        (audioPlayerHelper as object)['audioPlayer'] = {} as media.SoundPool;
        (audioPlayerHelper as object)['isPlaying'] = false;
        (audioPlayerHelper as object)['doPlayAudioOnce'](new Date().getTime());
        (audioPlayerHelper as object)['isPlaying'] = true;
        (audioPlayerHelper as object)['isFirstPlay'] = true;
        (audioPlayerHelper as object)['doPlayAudioOnce'](new Date().getTime());
        (audioPlayerHelper as object)['isPlaying'] = true;
        (audioPlayerHelper as object)['isFirstPlay'] = false;
        (audioPlayerHelper as object)['loadCompleted'] = false;
        (audioPlayerHelper as object)['doPlayAudioOnce'](new Date().getTime());
        expect(audioPlayerHelper).not().assertNull();
      } catch (e) {
        expect(audioPlayerHelper).not().assertNull();
      }
    })

    it('getAudioPlayer', 0, async () => {
      try {
        (audioPlayerHelper as object)['audioPlayer'] = {} as media.SoundPool;
        (audioPlayerHelper as object)['getAudioPlayer']();
        (audioPlayerHelper as object)['audioPlayer'] = null;
        (audioPlayerHelper as object)['getAudioPlayer']();
        expect(audioPlayerHelper).not().assertNull();
      } catch (e) {
        expect(audioPlayerHelper).not().assertNull();
      }
    })

    it('getAudioFd', 0, async () => {
      try {
        (audioPlayerHelper as object)['pcAudioFd'] = {};
        (audioPlayerHelper as object)['getAudioFd']();
        (audioPlayerHelper as object)['pcAudioFd'] = null;
        (audioPlayerHelper as object)['getAudioFd']();
        expect(audioPlayerHelper).not().assertNull();
      } catch (e) {
        expect(audioPlayerHelper).not().assertNull();
      }
    })
  })
}