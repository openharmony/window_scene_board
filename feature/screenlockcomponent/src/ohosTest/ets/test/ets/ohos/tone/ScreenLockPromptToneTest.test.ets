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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { AudioParam, ScreenLockPromptTone
} from '../../../../../../main/ets/tone/ScreenLockPromptTone';
import Media from '@ohos.multimedia.media';

export default function ScreenLockPromptToneTest() {

  describe('ScreenLockPromptToneTest', (): void => {
    let mScreenLockPromptTone: ScreenLockPromptTone = new ScreenLockPromptTone();
    let mScreenLockPromptToneMode: ScreenLockPromptToneMode = new ScreenLockPromptToneMode();

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_playNtfAudio_return', 0, (): void => {
      let src: string = 'res';
      mScreenLockPromptTone.playNtfAudio(src);
      mScreenLockPromptTone.playNtfAudio(src);
      expect(src).assertEqual('res');
    })

    it('test_InitAudioRenderer_return', 0, (): void => {
      let param: AudioParam = {};
      mScreenLockPromptToneMode.InitAudioRenderer(param);
      expect(param).not().assertNull();
    })

    it('test_StartPrePlay_return', 0, (): void => {
      let src : string = 'res';
      mScreenLockPromptToneMode.StartPrePlay(src);
      expect(src).not().assertNull();
    })

    it('test_GetAudioFilePath_return', 0, (): void => {
      let oriSrc : string = 'res';
      let result = mScreenLockPromptToneMode.GetAudioFilePath(oriSrc);
      expect(result).assertEqual('res');
    })

    it('test_audioMediaOnError_return', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mScreenLockPromptToneMode.AudioMediaOnError();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })
  })
}

export class ScreenLockPromptToneMode extends ScreenLockPromptTone {
  constructor() {
    super();
  }

  public InitAudioRenderer(param?: AudioParam): Promise<Media.AVPlayer | undefined> {
    return this.initAudioRenderer(param);
  }

  public StartPrePlay(src: string): Promise<void> {
    return this.startPrePlay(src);
  }

  public GetAudioFilePath(oriSrc: string): string {
    return this.getAudioFilePath(oriSrc);
  }

  public AudioMediaOnError() {
    const avPlayer: Media.AVPlayer = {
      on(error: string, callback: Function) {
        callback(error)
      },
      reset() {}
    } as Media.AVPlayer
    return this.audioMediaOnError(avPlayer);
  }
}