/*
 * Copyright (c) 2026 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
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
  ScbNumber,
  SCBSceneContainerSession,
  SCBSceneMode,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSessionRect,
  windowMgr,
} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { DividerStyleConstants, WindowConstants } from '@ohos/commonconstants';
import { IconResourceManager } from '@ohos/frameworkwrapper';
import { image } from '@kit.ImageKit';

const TAG = 'SCBSplitManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const BASE_DENSITY: number = 160;

export class SCBSplitManager {
  /**
   * Get the singleton of the SCBSplitManager.
   */
  static getInstance(): SCBSplitManager {
    if (!globalThis.SCBSplitManagerInstance) {
      globalThis.SCBSplitManagerInstance = new SCBSplitManager();
    }
    return globalThis.SCBSplitManagerInstance;
  }

  private constructor() {
  }

  /**
   * 获取当前分屏窗口的rect信息
   *
   * @param screenProperty 屏幕信息
   * @param dividerParam 分屏参数
   * @param isSplitPrimary 是否主分屏
   * @returns 分屏窗口的rect信息
   */
  private getSplitCurrRect(screenProperty: SCBScreenProperty, dividerParam: SCBDividerParam, isSplitPrimary: boolean): SCBSessionRect {
    const width: number = this.getSplitWidthPx(screenProperty, dividerParam, isSplitPrimary);
    const height: number = this.getSplitHeightPx(screenProperty, dividerParam, isSplitPrimary);
    let topThreshold = Math.round(windowMgr.getWindowPosition(WindowConstants.WINDOW_NAME_STATUS_BAR).height);
    if (dividerParam.isExpandUpDownSplit()) {
      if (isSplitPrimary) {
        return new SCBSessionRect(0, topThreshold, width, height);
      } else {
        const primaryHeight: number = this.getSplitHeightPx(screenProperty, dividerParam, true);
        return new SCBSessionRect(0, topThreshold + primaryHeight + this.getDividerWidthPx(),
          width, height);
      }
    } else {
      if (isSplitPrimary) {
        return new SCBSessionRect(0, topThreshold, Math.round(width), height);
      } else {
        return new SCBSessionRect(screenProperty.width - width, topThreshold, Math.round(width), height);
      }
    }
  }

  private getSplitWidthPx(screenProperty: SCBScreenProperty, dividerParam: SCBDividerParam,
    needPrimaryWidth: boolean): number {
    if (dividerParam.isSplitPrimaryMode === needPrimaryWidth) {
      return Number.parseFloat(dividerParam.primary.width) * 0.01 * screenProperty.width;
    }
    return Number.parseFloat(dividerParam.secondary.width) * 0.01 * screenProperty.width;
  }

  private getSplitHeightPx(screenProperty: SCBScreenProperty, dividerParam: SCBDividerParam,
    needPrimaryHeight: boolean): number {
    if (dividerParam.isSplitPrimaryMode === needPrimaryHeight) {
      return Number.parseFloat(dividerParam.primary.height) * 0.01 * screenProperty.height;
    }
    return Number.parseFloat(dividerParam.secondary.height) * 0.01 * screenProperty.height;
  }

  private getDividerWidthPx(): number {
    return vp2px(DividerStyleConstants.DIVIDER_HEIGHT);
  }

  public refreshSplitContainer(containerSession: SCBSceneContainerSession, screenProperty: SCBScreenProperty, withDfx: boolean = false): void {
    if (containerSession.isSplit && !containerSession.isPairSplitAnimating &&
      containerSession.screenProperty.screenId === screenProperty.screenId && containerSession.primarySession) {
      const currentDpi = SCBSceneSessionManager.getInstance().getCurrentDensityDpi();
      let density: number = currentDpi > 0 ? currentDpi / BASE_DENSITY : vp2px(1);
      let priRect = this.getSplitCurrRect(screenProperty, containerSession.dividerParam, true);
      let secRect = this.getSplitCurrRect(screenProperty, containerSession.dividerParam, false);
      log.showInfo(`refreshSplitContainer: priRect ${priRect.printPx()}, secRect ${secRect.printPx()}`);
      const priParam = containerSession.dividerParam.isSplitPrimaryMode ?
        containerSession.dividerParam.primary : containerSession.dividerParam.secondary;
      const secParam = containerSession.dividerParam.isSplitPrimaryMode ?
        containerSession.dividerParam.secondary : containerSession.dividerParam.primary;
      const dividerWidthPx = vp2px(DividerStyleConstants.DIVIDER_HEIGHT);
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
        containerSession.primarySession?.updateRect(priRect.left, priRect.top, priRect.width, priRect.height);
        containerSession.secondarySession?.updateRect(secRect.left, secRect.top, secRect.width, secRect.height);
      } else {
        containerSession.secondarySession?.updateRect(priRect.left, priRect.top, priRect.width, priRect.height);
        containerSession.primarySession?.updateRect(secRect.left, secRect.top, secRect.width, secRect.height,);
      }
      this.updateSubSession(containerSession);
    }
  }

  private updateSubSession(containerSession: SCBSceneContainerSession): void {
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

  public getCombIcon(sceneContainerSession: SCBSceneContainerSession, isPrimary: boolean): image.PixelMap | null {
    const sceneSession: SCBSceneSession | null =
      isPrimary ? sceneContainerSession.primarySession : sceneContainerSession.secondarySession;
    if (sceneSession) {
      let combIcon: image.PixelMap = IconResourceManager.getInstance().getCachedCombIconSync(
        sceneSession.sceneInfo.bundleName,
        sceneSession.sceneInfo.moduleName,
        sceneSession.sceneInfo.abilityName
      );
      return combIcon;
    }
    return null;
  }
}