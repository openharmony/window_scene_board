/**
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { StyleConstants } from '@ohos/launchercommon';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { RecentsStyleConstants, SCBScenePanelManager, SCBScreenProperty } from '@ohos/windowscene';
import { RecentLayoutCalculator } from './RecentLayoutCalculator';
import { RecentLayoutManager } from './RecentLayoutManager';

export class SingleRowRecentLayoutCal implements RecentLayoutCalculator {
  private readonly panelManager: SCBScenePanelManager;

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
  }

  getEnterRecentTargetOffsetX(relativeColumn: number, totalColumn: number, isFromApp: boolean): number {
    if (relativeColumn <= 0) {
      return 0;
    }
    let screenProperty = this.panelManager.getScreenProperty();
    let recentTaskWidth = RecentLayoutManager.getWidthAndSpace(screenProperty);
      // 计算出来的结果为中间显示
    let offsetX = relativeColumn * recentTaskWidth;
    if (isFromApp && relativeColumn === totalColumn) {
      // 如果是最后一张卡片时，需要落位到右侧，则减少一列的距离
      offsetX = offsetX - recentTaskWidth;
    }
    return offsetX;
  }

  getEndIndex(sessionCount: number): number {
    return Math.max(sessionCount - RecentsStyleConstants.RECENT_VIEW_COUNT, 0)
  }

  getRecentLayoutWidth(sessionCountShowInRecent: number, recentPadding: number): number {
    let screenProperty = this.panelManager.getScreenProperty();
    let recentScale = RecentLayoutManager.getSingleRowScale(screenProperty);
    let showInRecentCount = sessionCountShowInRecent;
    return vp2px((showInRecentCount * px2vp(screenProperty.width) * recentScale +
      Number(StyleConstants.RECENT_MARGIN) * (showInRecentCount - 1)) + recentPadding * 2);
  }
}