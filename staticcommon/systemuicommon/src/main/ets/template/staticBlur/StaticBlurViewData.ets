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
import { image } from '@kit.ImageKit';
import { DropDownAdapter } from '../../adapter/DropDownAdapter';

const TAG = 'StaticBlurViewData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Observed
export class StaticBlurViewData {

  private shouldShowSnapShot: boolean = false;

  // 用于遮盖下方内容的截图
  private snapshot?: image.PixelMap;

  public getShouldShowSnapShot(): boolean {
    return this.shouldShowSnapShot;
  }

  public setShouldShowSnapShot(shouldShowSnapShot: boolean): void {
    this.shouldShowSnapShot = shouldShowSnapShot;
  }

  public setSnapShot(image: image.PixelMap) {
    if (this.snapshot !== undefined) {
      this.releaseSnapShot();
    }
    if (!DropDownAdapter.isDropDownShow()) {
      log.showWarn(`DropdownPanel is not showing, release snapshot`);
      image?.release();
      return;
    }
    this.snapshot = image;
  }

  public releaseSnapShot() {
    this.snapshot?.release().then(() => {
      log.showInfo(`releaseSnapShot success`);
      this.snapshot = undefined;
    }).catch((err: Error) => {
      log.showError(`releaseSnapShot failed, error: ${err}`);
    });
  }

  public getSnapShot(): image.PixelMap | undefined {
    return this.snapshot;
  }
}