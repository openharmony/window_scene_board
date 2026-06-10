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

import { GlassBannerPanelManager } from '../manager/GlassBanerPanelManager';
import { GlassBannerContent } from '../componets/GlassBannerContent';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassSystemSceneType, GlassSystemSceneManager } from '../../scene/common/GlassSystemSceneManager';

const TAG = 'GlassBannerPanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export struct GlassBannerPanel {
  aboutToAppear(): void {
    log.info(`aboutToAppear`);
    GlassBannerPanelManager.getInstance().init();
    GlassBannerPanelManager.getInstance().setNtfWindowVisibility(false);
    GlassBannerPanelManager.getInstance().registerAttrChanged(() => {
      this.setBannerWindowLayout();
    });

    this.setBannerWindowLayout();
  }

  aboutToDisappear() {
    log.info(`aboutToDisappear`);
  }

  private setBannerWindowLayout(): void {
    const rect = GlassBannerPanelManager.getInstance().getPanelRect();
    if (rect) {
      GlassSystemSceneManager.getInstance().updateWindowRect(GlassSystemSceneType.GLASS_BANNER, rect);
    }
  }

  build() {
    GlassBannerContent();
  }
}