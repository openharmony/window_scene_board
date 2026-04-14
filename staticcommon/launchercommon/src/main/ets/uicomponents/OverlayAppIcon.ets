/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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
import { ResourceManager } from '@ohos/frameworkwrapper';

const TAG = 'OverlayAppIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export default struct OverlayAppIcon {
  public iconSize: number = 0;
  public appIcon: string = '';
  public bundleName: string = '';
  public icon: string = '';

  // 0.9(pressed scaleSize) / 1.05(hover scaleSize) = 0.8571
  @State scaleSize: number = 0.8571;
  useCache: boolean = true;
  public badgeNumber: number = 0;
  @State badge: number = 0;
  private mResourceManager?: ResourceManager;

  public aboutToAppear(): void {
    this.mResourceManager = ResourceManager.getInstance();
  }

  build() {
    Column() {
     Image(this.icon).draggable(false)
       .id(`${TAG}_Image_${this.bundleName}`)
      .width(this.iconSize)
      .height(this.iconSize)
      .onComplete(() => {
        log.showInfo('OverlayAppIcon complete');
        this.scaleSize = 1;
        AppStorage.setOrCreate('isOverlayComplete', true);
       })
    }
    .width(this.iconSize)
    .height(this.iconSize)
    .scale({ x: this.scaleSize, y: this.scaleSize })
    .animation({ duration: 100 })
  }
}