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
import displaySync from '@ohos.graphics.displaySync';

export class FrameCount {
  public value: number = 0;

  constructor(private callback?: (value: number) => void) {
    this.callback = callback;
  }

  public start(count: number): void {
    let mDisplaySync: displaySync.DisplaySync | undefined = displaySync.create();
    this.value = 0;
    mDisplaySync.start();
    mDisplaySync.on('frame', () => {
      if (++this.value >= count) {
        mDisplaySync!.off('frame');
        mDisplaySync!.stop();
        mDisplaySync = undefined;
      }
      this.callback?.(this.value);
    });
  }

  public reset():void {
    this.callback = undefined;
  }
}
