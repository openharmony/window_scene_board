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
import { FixedDockResource } from '../common/constants/FixedDockConstants';
import { PCDockUtils } from '../utils/PCDockUtils';

const TAG = 'DockBackgroundView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

@Component
export struct DockBackgroundView {
  @Link isFullScreenLayout: boolean;
  @Link currColorMode: number;

  public aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
  }

  public aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
  }

  private isDarkMode(): boolean {
    return this.currColorMode === 0;
  }

  private getBrightnessOptions(): BrightnessOptions {
    log.showInfo(`currColorMode: ${this.currColorMode}`);
    if (this.isFullScreenLayout) {
      return this.isDarkMode() ? FixedDockResource.dockBackgroundBrightnessDarkFullParam :
        FixedDockResource.dockBackgroundBrightnessLightFullParam;
    }
    if (this.currColorMode === 0) {
      return FixedDockResource.dockBackgroundBrightnessDarkParam;
    }
    if (this.currColorMode === 1) {
      return FixedDockResource.dockBackgroundBrightnessLightParam;
    }
    return FixedDockResource.dockBackgroundBrightnessHuaParam;
  }

  build() {
    Row() {
      Row()
        .width('100%')
        .height('100%')
        .margin({ top: 1 })
        .border({
          width: { top: 1 },
          color: '#26FFFFFF',
        })
        .outline({
          width: { top: 1 },
          color: this.isDarkMode() ? '#66000000' : '#26000000',
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFFFF')
    .backgroundBrightnessInternal(this.getBrightnessOptions())
    .backgroundEffect({
      radius: 60
    })
  }
}