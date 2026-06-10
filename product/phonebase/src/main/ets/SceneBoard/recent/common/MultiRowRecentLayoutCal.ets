/**
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScenePanelManager, SCBScreenProperty } from '@ohos/windowscene';
import { RecentsStyleConstants } from '@ohos/windowscene';
import { RecentLayoutCalculator } from './RecentLayoutCalculator';
import { RecentLayoutManager } from './RecentLayoutManager';

const TAG = 'MultiRowRecentLayoutCal';
export class MultiRowRecentLayoutCal implements RecentLayoutCalculator {
  private readonly panelManager: SCBScenePanelManager;

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
  }

  getEnterRecentTargetOffsetX(relativeColumn: number, totalColumn: number, isFromApp: boolean): number {
    // 停顿在0列或者1列的时候，实际显示为1列或者2列，scroll可以滚动的距离是0，固定在0的位置
    // 当前为第二列且是倒数第二列的场景，需要显示右边界，不能直接return 0，需要增加一个offset
    if (relativeColumn <= 0 || (relativeColumn === 1 && relativeColumn !== totalColumn - 1)) {
      return 0;
    }
    let screenProperty = this.panelManager.getScreenProperty();
    let recentCardWidth = RecentLayoutManager.getCardWidth(screenProperty);
    let recentMargin = RecentLayoutManager.getWidthSpace();
    let recentTaskWidth = recentCardWidth + recentMargin;
    let multiRowPadding = RecentLayoutManager.getMultiRowPadding(screenProperty);
    // 实际3列以上的情况，offsetX = 0时，最左边卡片离左侧recentMargin，需要停顿在最右边卡片离右边界recentMargin的位置，
    // 只有3列的情况，移动(recentMargin - multiRowPadding) * 2 + 2，其中+2是为了消除右侧滑动的白边
    // 以此类推多一张卡片，offsetX多recentTaskWidth，计算出来的结果为右侧显示
    let offsetX = Math.max(0, (relativeColumn - 2) * recentTaskWidth) + (recentMargin - multiRowPadding) * 2 + 2;
    // 前两列和最后一列时，scroll不需要额外滑动,中间列时需要落位到中间，增加一列的距离
    if (relativeColumn > 1 && relativeColumn < totalColumn) {
      offsetX = offsetX + recentTaskWidth;
    }
    return offsetX;
  }

  getEndIndex(sessionCount: number): number {
    return Math.max(sessionCount - RecentsStyleConstants.RECENT_VIEW_COUNT_MULTI, 0)
  }

  getRecentLayoutWidth(sessionCountShowInRecent: number, recentPadding: number): number {
    let screenProperty = this.panelManager.getScreenProperty();
    let screenWidth = px2vp(screenProperty.width);
    // 双行计算时，卡片的数量需要除以2
    let columnCount = Math.ceil(sessionCountShowInRecent / 2);
    let multiRowPadding = RecentLayoutManager.getMultiRowPadding(screenProperty);
    let recentMargin = RecentLayoutManager.getWidthSpace();
    let widthAndSpace = RecentLayoutManager.getWidthAndSpace(screenProperty);
    // 计算scroll长度，1列和2列的时候长度为0，
    // 3列需要考虑可以贴左边recentMargin和贴右边recentMargin，加上(recentMargin - multiRowPadding) * 2
    // 3列以上每增加1列，长度增加widthAndSpace
    return vp2px(screenWidth + Math.max((recentMargin - multiRowPadding) * 2 +
      Math.max(columnCount - 3, 0) * widthAndSpace, 0));
  }
}