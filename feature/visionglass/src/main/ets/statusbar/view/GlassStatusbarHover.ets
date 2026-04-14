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

import { GlassStatusbarManager } from '../manager/GlassStatusbarManager';
import { GlassStatusbarHoverManager } from '../manager/GlassStatusbarHoverManager';
import { GlassLayoutManager } from '../../common/manager/GlassLayoutManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassStatusBarStyle } from './GlassStatusBarStyle';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';

const TAG: string = 'GlassStatusBarHover';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

/**
 * 状态栏hover块
 */
@Component
export default struct GlassStatusBarHover {
  @State barHoverWidth: number = GlassLayoutManager.getInstance().getScreenWidthPx() / 3;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear, barHoverWidth is ${this.barHoverWidth}`);
    GlassStatusbarHoverManager.getInstance().init();
    GlassSystemSceneManager.getInstance().showSystemView(GlassSystemSceneType.GLASS_STATUS_BAR_HOVER);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }

  build() {
    Row()
      .width(`${this.barHoverWidth}px`)
      .height(GlassStatusBarStyle.ICON_SIZE)
      .onHover((isHover: boolean) => {
        log.info('The hover action on the status bar is detected.');
        GlassStatusbarManager.getInstance().onHover(isHover);
      })
      .onAreaChange((oldValue, newValue) => {
        GlassStatusbarHoverManager.getInstance().updateHoverPosition(newValue);
      })
  }
}