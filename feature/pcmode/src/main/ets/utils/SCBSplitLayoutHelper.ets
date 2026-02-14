/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import {
  SCBDividerParam,
  SCBSceneContainerSession,
  SCBSceneMode,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSessionRect,
} from '@ohos/windowscene';
import { SCBSystemSceneUtils } from './SCBSystemSceneUtils';
import { DividerStyle } from '../constants/DividerStyleConstants';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { LayoutPolicyHelper } from '../layout/LayoutPolicyHelper';

const TAG = 'SCBSplitLayoutHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const BASE_DENSITY: number = 160;

export class SCBSplitLayoutHelper {
  public static refreshSplitContainer(containerSession: SCBSceneContainerSession, screenProperty: SCBScreenProperty,
    uiContext: UIContext | undefined, withDfx: boolean = true): void {
    if (containerSession.isSplit && !containerSession.isPairSplitAnimating &&
      containerSession.screenProperty.screenId === screenProperty.screenId && containerSession.primarySession) {
      const currentDpi = SCBSceneSessionManager.getInstance().getCurrentDensityDpi();
      let density: number =
        currentDpi > 0 ? currentDpi / BASE_DENSITY : SCBSystemSceneUtils.getInstance().vp2px(uiContext, 1);
      let priRect =
        LayoutPolicyHelper.getInstance().getSplitCurrRect(screenProperty, containerSession.dividerParam, true);
      let secRect =
        LayoutPolicyHelper.getInstance().getSplitCurrRect(screenProperty, containerSession.dividerParam, false);
      log.showDebug(`refreshSplitContainer: priRect ${priRect.printPx()}, secRect ${secRect.printPx()}`);
      const priParam = containerSession.dividerParam.isSplitPrimaryMode ?
      containerSession.dividerParam.primary : containerSession.dividerParam.secondary;
      const secParam = containerSession.dividerParam.isSplitPrimaryMode ?
      containerSession.dividerParam.secondary : containerSession.dividerParam.primary;
      const dividerWidthPx = SCBSystemSceneUtils.getInstance().vp2px(uiContext, DividerStyle.DIVIDER_WIDTH);
      if (containerSession.dividerParam.isExpandUpDownSplit()) {
        const primaryHeight = Number.parseFloat(priParam.height) * 0.01 * screenProperty.height;
        const secondaryHeight = Number.parseFloat(secParam.height) * 0.01 * screenProperty.height;
        const halfHeight = (primaryHeight + secondaryHeight + dividerWidthPx) / 2;
        const secHeight = Math.max(secRect.height.getPx(), Math.min(halfHeight, secParam.minHeight * density));
        priRect.setSizeNum(Math.round(priRect.width.getPx()),
          Math.round(Math.max(priRect.height.getPx(), Math.min(halfHeight, priParam.minHeight * density))));
        secRect.setSizeNum(Math.round(secRect.width.getPx()), Math.round(secHeight));
        secRect.setPosNum(Math.round(secRect.left.getPx()), Math.round(dividerWidthPx +
          priRect.top.getPx() + primaryHeight - Math.round(secHeight) + secHeight));
        priRect.setPosNum(Math.round(priRect.left.getPx()), Math.round(priRect.top.getPx() -
          priRect.height.getPx() + primaryHeight));
      } else {
        const primaryWidth = Number.parseFloat(priParam.width) * 0.01 * screenProperty.width;
        const halfWidth = (screenProperty.width - dividerWidthPx) / 2;
        const secWidth = Math.max(secRect.width.getPx(), Math.min(halfWidth, secParam.minWidth * density));
        priRect.setSizeNum(Math.round(Math.max(priRect.width.getPx(),
          Math.min(halfWidth, priParam.minWidth * density))), Math.round(priRect.height.getPx()));
        secRect.setSizeNum(Math.round(secWidth), Math.round(secRect.height.getPx()));
        secRect.setPosNum(Math.round(primaryWidth + dividerWidthPx +
          priRect.left.getPx() - Math.round(secWidth) + secWidth), Math.round(priRect.top.getPx()));
        priRect.setPosNum(Math.round(primaryWidth - priRect.width.getPx() +
          priRect.left.getPx()), Math.round(priRect.top.getPx()));
      }
      if (withDfx) {
        log.showInfo(`refreshSplitContainer: primary ${priRect.printPx()}, secondary ${secRect.printPx()}`);
      }
      if (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
        containerSession.primarySession?.currRect.copyFrom(priRect);
        containerSession.secondarySession?.currRect.copyFrom(secRect);
      } else {
        containerSession.primarySession?.currRect.copyFrom(secRect);
        containerSession.secondarySession?.currRect.copyFrom(priRect);
      }
      SCBSplitLayoutHelper.updateSubSession(containerSession);
    }
  }

  private static updateSubSession(containerSession: SCBSceneContainerSession): void {
    if (containerSession.primarySession instanceof SCBSceneSession) {
      let primarySession: SCBSceneSession = containerSession.primarySession as SCBSceneSession;
      primarySession.subSessionList.forEach((item) => {
        item.notifyParentRectChange(primarySession.currRect, sceneSessionManager.SessionSizeChangeReason.UNDEFINED,
          primarySession.sceneInfo.screenId);
      });
    }

    if (containerSession.secondarySession instanceof SCBSceneSession) {
      let secondarySession: SCBSceneSession = containerSession.secondarySession as SCBSceneSession;
      secondarySession.subSessionList.forEach((item) => {
        item.notifyParentRectChange(secondarySession.currRect, sceneSessionManager.SessionSizeChangeReason.UNDEFINED,
          secondarySession.sceneInfo.screenId);
      });
    }
  }
}