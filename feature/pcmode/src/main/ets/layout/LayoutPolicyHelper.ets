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

import { LogDomain, Logger } from '@ohos/basicutils';
import { DividerStyleConstants } from '@ohos/commonconstants';
import {
  SCBDividerParam,
  ScbNumber,
  SCBSceneContainerSession,
  SCBSceneMode,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSessionRect,
  SCBSpecificSession,
  sSCBOobeManager,
  WindowDragHotAreaType,
  SystemBarType
} from '@ohos/windowscene';
import { RealScreenInfo, ViewModelConstant, WindowSizeLimits } from '../constants/BaseConstants';
import { DividerStyle } from '../constants/DividerStyleConstants';
import { SCBSystemSceneUtils } from '../utils/SCBSystemSceneUtils';
import { UIContextUtil } from '../utils/UIContextUtil';
import { LayoutConstants, SubWindowChangeReason } from '../constants/LayoutConstants';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBPcScenePanelManager } from '../instance/SCBPcScenePanelManager';
import { Pointer2D } from '../utils/SCBPcModeUtils';

const TAG: string = 'LayoutPolicyHelper';
const log: Logger = Logger.getLogHelper(LogDomain.WINDOW);

export class LayoutPolicyHelper {
  private static instance: LayoutPolicyHelper;

  private constructor() {
  }

  public static getInstance(): LayoutPolicyHelper {
    if (!LayoutPolicyHelper.instance) {
      LayoutPolicyHelper.instance = new LayoutPolicyHelper();
    }
    return LayoutPolicyHelper.instance;
  }

  /*
   * calculate scene session and subsession rect after rotation
   * @param sceneSession
   * @param screenProperty
   */
  public handleFullScreenWindowRect(sceneSession: SCBSceneSession, originalScreenProperty: SCBScreenProperty,
    currentScreenProperty: SCBScreenProperty): void {
    const screenId: number = currentScreenProperty.screenId;
    const statusbarHeight: number = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(screenId);
    const dockHeight: number =
      SCBSystemSceneUtils.getInstance().getDockHeightPx(screenId, UIContextUtil.getInstance().getUIContext(screenId));
    const screenWidth: number = currentScreenProperty.width;
    const screenHeight: number = currentScreenProperty.height;
    let rect = sceneSession.currRect;
    if (sceneSession.layoutFullScreen) {
      rect.width = new ScbNumber(screenWidth);
      rect.height = new ScbNumber(screenHeight);
      rect.top = new ScbNumber(0);
    } else {
      rect.width = new ScbNumber(screenWidth);
      rect.height = new ScbNumber(screenHeight - dockHeight - statusbarHeight);
      rect.top = new ScbNumber(statusbarHeight);
    }
    this.handleFreeWindowRect(sceneSession.lastRect, originalScreenProperty, currentScreenProperty, sceneSession);
    sceneSession.setWindowLastSafeRect(sceneSession.lastRect.left.getPx(), sceneSession.lastRect.top.getPx(),
      sceneSession.lastRect.width.getPx(), sceneSession.lastRect.height.getPx());
  }

  public handleFreeWindowRect(rect: SCBSessionRect, originalScreenProperty: SCBScreenProperty,
    currentScreenProperty: SCBScreenProperty, scbSceneSession?: SCBSceneSession): void {
    const originalScreenId: number = originalScreenProperty.screenId;
    const screenId: number = currentScreenProperty.screenId;
    const originalStatusbarHeight: number = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(originalScreenId);
    const originalDockHeight: number = SCBSystemSceneUtils.getInstance().getDockHeightPx(originalScreenId,
      UIContextUtil.getInstance().getUIContext(originalScreenId));
    const statusbarHeight: number = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(screenId);
    const dockHeight: number =
      SCBSystemSceneUtils.getInstance().getDockHeightPx(screenId, UIContextUtil.getInstance().getUIContext(screenId));
    const BORDER_RESERVE_PX: number = SCBSystemSceneUtils.getInstance().vp2px(
      UIContextUtil.getInstance().getUIContext(screenId), LayoutConstants.BORDER_RESERVE_VP);
    let newRect = rect.copy();
    let originalRect = rect.copy();
    const specialWidth: number | null =
      newRect.width.getPx() > originalScreenProperty.width ? newRect.width.getPx() : null;
    const specialHeight: number | null = newRect.height.getPx() >
      originalScreenProperty.height - originalStatusbarHeight - originalDockHeight ? newRect.height.getPx() : null;
    this.restrictSessionInsideScreen(newRect, originalScreenProperty, originalStatusbarHeight, originalDockHeight);
    newRect = this.calcSessionRectWhenStatusChange(newRect, originalScreenProperty,
      currentScreenProperty, specialWidth, specialHeight);
    if (scbSceneSession) {
      this.adjustRectByRatio(newRect, scbSceneSession, currentScreenProperty.height - dockHeight - statusbarHeight,
        currentScreenProperty.width, BORDER_RESERVE_PX);
    }
    rect.copyFrom(newRect);
  }


  /**
   * update single subsession rect
   *
   * @param oldMainRect
   * @param newMainRect
   * @param subSessionList
   * @param originalScreenProperty
   * @param currentScreenProperty
   * @param isNeedFollowMain
   */
  public updateSingleSubSessionRect(oldMainRect: SCBSessionRect, newMainRect: SCBSessionRect,
    subSession: SCBSpecificSession, originalScreenProperty: SCBScreenProperty,
    currentScreenProperty: SCBScreenProperty, isNeedFollowMain: boolean = true, targetDensity?: number): void {
    if (this.isFullScene(subSession.currRect, originalScreenProperty) ||
      (subSession.windowMode === SCBSceneMode.FULLSCREEN && subSession.layoutFullScreen)) {
      subSession.currRect.setRectNum(currentScreenProperty.left, currentScreenProperty.top,
        currentScreenProperty.width, currentScreenProperty.height);
    } else if (subSession.windowMode === SCBSceneMode.FULLSCREEN && !subSession.layoutFullScreen) {
      const screenId: number = currentScreenProperty.screenId;
      const statusbarHeight: number = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(screenId);
      const dockHeight: number =
        SCBSystemSceneUtils.getInstance().getDockHeightPx(screenId, UIContextUtil.getInstance().getUIContext(screenId));
      subSession.currRect.setRectNum(currentScreenProperty.left, currentScreenProperty.top + statusbarHeight,
        currentScreenProperty.width, currentScreenProperty.height - statusbarHeight - dockHeight);
    } else if (subSession.subWindowAnchorInfo.isFollowParent) {
      this.updateSubSessionWhenRelativeToParent(newMainRect, subSession);
    } else if (oldMainRect.equals(subSession.currRect)) {
      subSession.currRect.copyFrom(newMainRect);
    } else {
      SCBPcScenePanelManager.getInstance().updateRectWithDpiChange(subSession.currRect, originalScreenProperty.screenId,
        currentScreenProperty.screenId, targetDensity);
      this.handleSubWindowWhenStatusChange(oldMainRect, newMainRect, subSession.currRect, currentScreenProperty,
        SubWindowChangeReason.ROTATION, isNeedFollowMain);
    }
  }

  public handleSubWindowWhenStatusChange(oldMainRect: SCBSessionRect, newMainRect: SCBSessionRect,
    subWindowRect: SCBSessionRect, screenProperty: SCBScreenProperty, reason: SubWindowChangeReason,
    isNeedFollowMain: boolean = true): void {
    if (isNeedFollowMain) {
      const topRatio: number = (subWindowRect.top.getPx() - oldMainRect.top.getPx()) / oldMainRect.height.getPx();
      const leftRatio: number = (subWindowRect.left.getPx() - oldMainRect.left.getPx()) / oldMainRect.width.getPx();
      subWindowRect.setPosNum(newMainRect.left.getPx() + newMainRect.width.getPx() * leftRatio,
        newMainRect.top.getPx() + newMainRect.height.getPx() * topRatio);
    }
    const screenId: number = screenProperty.screenId;
    const statusbarHeight: number = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(screenId);
    const dockHeight: number =
      SCBSystemSceneUtils.getInstance().getDockHeightPx(screenId, UIContextUtil.getInstance().getUIContext(screenId));
    const BORDER_RESERVE_PX: number = SCBSystemSceneUtils.getInstance().vp2px(
      UIContextUtil.getInstance().getUIContext(screenId), LayoutConstants.BORDER_RESERVE_VP);
    switch (reason) {
      case SubWindowChangeReason.ROTATION:
        this.restrictSessionInsideScreen(subWindowRect, screenProperty, statusbarHeight, dockHeight, BORDER_RESERVE_PX);
        break;
      default:
        break;
    }
  }

  public restrictSessionInsideScreen(rect: SCBSessionRect, screenProperty: SCBScreenProperty, statusbarHeight: number,
    dockHeight: number, border: number = 0): void {
    if (rect.width.getPx() > screenProperty.width - 2 * border) {
      rect.width = new ScbNumber(screenProperty.width - 2 * border);
    }
    if (rect.height.getPx() > screenProperty.height - statusbarHeight - dockHeight) {
      rect.height = new ScbNumber(screenProperty.height - statusbarHeight - dockHeight);
    }

    if (rect.left.getPx() <= border) {
      rect.left = new ScbNumber(border);
    } else if (rect.left.getPx() + rect.width.getPx() > screenProperty.width - border) {
      rect.left = new ScbNumber(screenProperty.width - border - rect.width.getPx());
    }

    if (rect.top.getPx() <= statusbarHeight) {
      rect.top = new ScbNumber(statusbarHeight);
    } else if (rect.top.getPx() + rect.height.getPx() > screenProperty.height - dockHeight) {
      rect.top = new ScbNumber(screenProperty.height - rect.height.getPx() - dockHeight);
    }
  }

  public getRatio(numerator: number, denominator: number): number {
    if (numerator + denominator === 0) {
      return 0;
    }
    return numerator / (numerator + denominator);
  }

  public adjustRectByRatio(rect: SCBSessionRect, scbSceneSession: SCBSceneSession | null, screenHeight: number,
    screenWidth: number, borderReserve: number): void {
    // 兼容模式竖屏模式为固定宽高不受影响
    if (!scbSceneSession) {
      return;
    }
    const bundleName = scbSceneSession.sceneInfo.bundleName;
    const moduleName = scbSceneSession.sceneInfo.moduleName;
    const abilityName = scbSceneSession.sceneInfo.abilityName;
    const queryKey = bundleName + moduleName + abilityName;
    const windowSize = SCBSceneSessionManager.getInstance().getAbilityWindowSize(queryKey);
    if (!windowSize) {
      log.showWarn(TAG, 'windowSize is null');
      return;
    }
    const sizeLimit = new WindowSizeLimits();
    screenWidth -= borderReserve;
    sizeLimit.initAll(windowSize);
    sizeLimit.maxWindowWidth =
      sizeLimit.maxWindowWidth === 0 ? screenWidth : Math.min(sizeLimit.maxWindowWidth, screenWidth);
    sizeLimit.maxWindowHeight =
      sizeLimit.maxWindowHeight === 0 ? screenHeight : Math.min(sizeLimit.maxWindowHeight, screenHeight);
    rect.width.setNumber(Math.max(rect.width.getPx(), sizeLimit.minWindowWidth));
    rect.height.setNumber(Math.max(rect.height.getPx(), sizeLimit.minWindowHeight));
    const currentAspectRatio = rect.width.getPx() / rect.height.getPx();
    if (sizeLimit.minWindowRatio > 0 && currentAspectRatio < sizeLimit.minWindowRatio) {
      const minWidth = sizeLimit.minWindowRatio * rect.height.getPx();
      rect.width.setNumber(Math.max(rect.width.getPx(), minWidth));
      if (rect.width.getPx() < sizeLimit.minWindowWidth) {
        rect.width.setNumber(sizeLimit.minWindowWidth);
        rect.height.setNumber(Math.max(rect.width.getPx() / sizeLimit.minWindowRatio, sizeLimit.minWindowHeight));
      }
      if (rect.width.getPx() > sizeLimit.maxWindowWidth) {
        rect.width.setNumber(sizeLimit.maxWindowWidth);
        rect.height.setNumber(Math.max(rect.width.getPx() / sizeLimit.minWindowRatio, sizeLimit.minWindowHeight));
      }
    }
    if (sizeLimit.maxWindowRatio > 0 && currentAspectRatio > sizeLimit.maxWindowRatio) {
      const maxWidth = sizeLimit.maxWindowRatio * rect.height.getPx();
      rect.width.setNumber(Math.min(rect.width.getPx(), maxWidth));
      if (rect.width.getPx() < sizeLimit.minWindowWidth) {
        rect.width.setNumber(sizeLimit.minWindowWidth);
        rect.height.setNumber(Math.max(rect.width.getPx() / sizeLimit.maxWindowRatio, sizeLimit.minWindowHeight));
      }
      if (rect.width.getPx() > sizeLimit.maxWindowWidth) {
        rect.width.setNumber(sizeLimit.maxWindowWidth);
        rect.height.setNumber(Math.max(rect.width.getPx() / sizeLimit.maxWindowRatio, sizeLimit.minWindowHeight));
      }
    }
    if (rect.left.getPx() < 0) {
      rect.left = new ScbNumber(borderReserve);
    }
    log.showDebug(TAG, `adjustRectByRatio, queryKey: ${queryKey}, rect: ${rect.printPx()}`);
  }

  /**
   * 根据主副窗最小宽度计算分屏主窗口宽度
   *
   * @param containerSession 容器会话
   * @param screenProperty 屏幕信息
   * @param primaryWidth 主窗宽度
   * @param secondaryWidth 副窗宽度
   * @returns
   */
  public calculatePrimaryWidthBySplitMinWidth(containerSession: SCBSceneContainerSession,
    screenProperty: SCBScreenProperty, primaryWidth: number, secondaryWidth: number): number {
    const minPrimaryWidthPx = this.getMinWidthPx(containerSession.dividerParam.isSplitPrimaryMode, true,
      screenProperty, containerSession.dividerParam);
    const minSecondaryWidthPx = this.getMinWidthPx(containerSession.dividerParam.isSplitPrimaryMode, false,
      screenProperty, containerSession.dividerParam);
    if (primaryWidth <= minPrimaryWidthPx) {
      return minPrimaryWidthPx;
    } else if (secondaryWidth <= minSecondaryWidthPx) {
      return primaryWidth - minSecondaryWidthPx + secondaryWidth;
    }
    return primaryWidth;
  }

  /*
   * whether rect is same as full screen
   * @param currRect
   * @param screenProperty
   */
  public isFullScene(currRect: SCBSessionRect, screenProperty: SCBScreenProperty): boolean {
    let screenRect = new SCBSessionRect(screenProperty.left, screenProperty.top,
      screenProperty.width, screenProperty.height);
    return currRect.equals(screenRect);
  }

  public updateSubSessionWhenRelativeToParent(newMainRect: SCBSessionRect, subSession: SCBSpecificSession): void {
    subSession.notifyParentRectChange(newMainRect, sceneSessionManager.SessionSizeChangeReason.UNDEFINED,
      subSession.screenId);
  }

  public getDefaultAvailableWorkSpaceHeight(sceneSession: SCBSceneSession, screenProperty: SCBScreenProperty): number {
    const screenId = screenProperty.screenId;
    const statusBarHeight: number = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(screenId);;
    const dockHeight: number =
      SCBSystemSceneUtils.getInstance().getDockHeightPx(screenId, UIContextUtil.getInstance().getUIContext(screenId));
    return sceneSession.layoutFullScreen ?
    screenProperty.height : (screenProperty.height - statusBarHeight - dockHeight);
  }

  /**
   * 获取分屏初始窗口初始rect信息
   *
   * @param screenProperty 屏幕信息
   * @param dividerParam 分屏参数
   * @param isSplitPrimary 是否主分屏
   * @returns 分屏窗口的rect信息
   */
  public getSplitInitialRect(screenProperty: SCBScreenProperty,
    dividerParam: SCBDividerParam, isSplitPrimary: boolean): SCBSessionRect {
    let topThreshold = 0;
    const isDockAutoHideEnable = AppStorage.get<boolean>('isDockAutoHide');
    if (!isDockAutoHideEnable) {
      topThreshold = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(screenProperty.screenId);
    }
    let bottomThreshold = screenProperty.height;
    if (!isDockAutoHideEnable) {
      let dockHeight = SCBSystemSceneUtils.getInstance().getDockHeightPx(screenProperty.screenId,
        UIContextUtil.getInstance().getUIContext(screenProperty.screenId));
      if (dockHeight === 0) {
        // 尝试从AppStorage获取
        const savedDockHeight = AppStorage.get<number>('dockHeight');
        if (savedDockHeight && savedDockHeight > 0) {
          dockHeight = vp2px(savedDockHeight);
          log.showInfo(TAG, 'getSplitInitialRect - Get dock height from AppStorage (vp): ' + savedDockHeight + ', converted to px: ' + dockHeight);
        } else {
          // 使用硬编码默认值
          dockHeight = 99;
          log.showInfo(TAG, 'getSplitInitialRect - Use default dock height: ' + dockHeight);
        }
      }
      bottomThreshold = bottomThreshold - dockHeight;
      log.showInfo(TAG, 'getSplitInitialRect - Status bar height: ' + topThreshold + ', dock height: ' + dockHeight + ', calculated bottom threshold: ' + bottomThreshold);
    }
    const rect = new SCBSessionRect(0, 0, 0, 0);
    const width: number = this.getInitSplitSceneWidth(screenProperty, isSplitPrimary, dividerParam);
    if (isSplitPrimary) {
      rect.setRectNum(0, topThreshold, width, bottomThreshold - topThreshold);
    } else {
      rect.setRectNum(screenProperty.width - width, topThreshold,
        width, bottomThreshold - topThreshold);
    }
    return rect;
  }

  /**
   * 获取当前分屏窗口的rect信息
   *
   * @param screenProperty 屏幕信息
   * @param dividerParam 分屏参数
   * @param isSplitPrimary 是否主分屏
   * @returns 分屏窗口的rect信息
   */
  public getSplitCurrRect(screenProperty: SCBScreenProperty, dividerParam: SCBDividerParam,
    isSplitPrimary: boolean): SCBSessionRect {
    const width: number = this.getSplitWidthPx(screenProperty, dividerParam, isSplitPrimary);
    const height: number = this.getSplitHeightPx(screenProperty, dividerParam, isSplitPrimary);
    let topThreshold = 0;
    const isDockAutoHide = AppStorage.get<boolean>('isDockAutoHide');
    if (!isDockAutoHide) {
      topThreshold = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(screenProperty.screenId);
    }
    if (dividerParam.isExpandUpDownSplit()) {
      if (isSplitPrimary) {
        return new SCBSessionRect(0, topThreshold, width, height);
      } else {
        const primaryHeight: number = this.getSplitHeightPx(screenProperty, dividerParam, true);
        return new SCBSessionRect(0, topThreshold + primaryHeight + this.getDividerWidthPx(screenProperty.screenId),
          width, height);
      }
    }
    if (isSplitPrimary) {
      return new SCBSessionRect(0, topThreshold, Math.round(width), height);
    } else {
      return new SCBSessionRect(screenProperty.width - width, topThreshold, Math.round(width), height);
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

  private getDividerWidthPx(screenId: number): number {
    return SCBSystemSceneUtils.getInstance()
      .vp2px(UIContextUtil.getInstance().getUIContext(screenId), DividerStyle.DIVIDER_WIDTH);
  }

  private getInitSplitSceneWidth(screenProperty: SCBScreenProperty, isSplitPrimary: boolean,
    dividerParam: SCBDividerParam): number {
    let widthPercent = dividerParam.primary.width;
    if ((isSplitPrimary && !dividerParam.isSplitPrimaryMode) || (!isSplitPrimary && dividerParam.isSplitPrimaryMode)) {
      widthPercent = dividerParam.secondary.width;
    }
    if (widthPercent === '100%' || widthPercent === '0%') {
      return (screenProperty.width - this.getDividerWidthPx(screenProperty.screenId)) / 2;
    }
    return screenProperty.width * Number.parseFloat(widthPercent) / 100;
  }

  private calcSessionRectWhenStatusChange(originalRect: SCBSessionRect, originalScreenProperty: SCBScreenProperty,
    currentScreenProperty: SCBScreenProperty, specialWidth: number | null,
    specialHeight: number | null): SCBSessionRect {
    const originalScreenId: number = originalScreenProperty.screenId;
    const screenId: number = currentScreenProperty.screenId;
    const originalStatusbarHeight: number = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(originalScreenId);
    const originalDockHeight: number = SCBSystemSceneUtils.getInstance().getDockHeightPx(originalScreenId,
      UIContextUtil.getInstance().getUIContext(originalScreenId));
    const statusbarHeight: number = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(screenId);
    const dockHeight: number =
      SCBSystemSceneUtils.getInstance().getDockHeightPx(screenId, UIContextUtil.getInstance().getUIContext(screenId));
    const oldWidth: number = originalScreenProperty.width;
    const oldHeight: number = originalScreenProperty.height - originalDockHeight - originalStatusbarHeight;
    const newWidth: number = currentScreenProperty.width;
    const newHeight: number = currentScreenProperty.height - dockHeight - statusbarHeight;
    const BORDER_RESERVE_PX: number = SCBSystemSceneUtils.getInstance().vp2px(
      UIContextUtil.getInstance().getUIContext(screenId), LayoutConstants.BORDER_RESERVE_VP);
    let newRect: SCBSessionRect = originalRect.copy();
    newRect.width = new ScbNumber(Math.min(newWidth - BORDER_RESERVE_PX * 2, specialWidth ?? newRect.width.getPx()));
    newRect.height = new ScbNumber(Math.min(newHeight, specialHeight ?? newRect.height.getPx()));
    const marginTop: number = originalRect.top.getPx() - originalStatusbarHeight;
    const marginBottom: number = oldHeight - originalRect.height.getPx() - marginTop;
    const top = (newHeight - newRect.height.getPx()) * this.getRatio(marginTop, marginBottom) + statusbarHeight;
    newRect.top = new ScbNumber(top);
    const marginLeft = originalRect.left.getPx();
    const marginRight = oldWidth - originalRect.width.getPx() - marginLeft;
    let left: number = Math.max((newWidth - newRect.width.getPx()) * this.getRatio(marginLeft, marginRight),
      BORDER_RESERVE_PX);
    left = Math.min(left, newWidth - newRect.width.getPx() - BORDER_RESERVE_PX);
    newRect.left = new ScbNumber(left);
    return newRect;
  }

  private getMinWidthPx(isPrimaryMode: boolean, needPrimaryWidth: boolean, screenProperty: SCBScreenProperty,
    dividerParam: SCBDividerParam): number {
    const currentDpi = SCBSceneSessionManager.getInstance().getCurrentDensityDpi();
    let density: number = currentDpi > 0 ? currentDpi / ViewModelConstant.BASE_DENSITY : vp2px(1);
    const defaultMinWidth = vp2px(DividerStyleConstants.DEFAULT_SPLIT_MIN_SCENE_WIDTH);
    const halfScreenWidth = (screenProperty.width - vp2px(DividerStyle.DIVIDER_WIDTH)) / 2;
    if (isPrimaryMode && needPrimaryWidth || !isPrimaryMode && !needPrimaryWidth) {
      return Math.min(Math.max(dividerParam.primary.minWidth * density, defaultMinWidth), halfScreenWidth);
    }
    return Math.min(Math.max(dividerParam.secondary.minWidth * density, defaultMinWidth), halfScreenWidth);
  }

/**
 * scale window rect
 * 
 * @param curRect
 * @param scaleRatio
 * @param achor scale center. If undefined, window position will not change.
 */
  public updateRectWithDensityChange(curRect: SCBSessionRect, scaleRatio: number, anchor?: Pointer2D): void {
    if (!curRect) {
      log.showWarn(TAG, 'updateRectWithDensityChange curRect is null');
      return;
    }
    log.showInfo(TAG, `updateRectWidthDensityChange curRect:[${curRect.left.getPxStr()}, ${curRect.top.getPxStr()}, ` +
      `${curRect.width.getPxStr()}, ${curRect.height.getPxStr()}], scaleRatio:${scaleRatio}, ` +
      `anchor:[${anchor ? anchor.x : -1}, ${anchor ? anchor.y : -1}]`);
    let width = (curRect.width.getPx() * scaleRatio);
    let height = (curRect.height.getPx() * scaleRatio);
    let left = curRect.left.getPx();
    let top = curRect.top.getPx();

    // 默认以左上角为锚点缩放，设置锚点时，以锚点位置缩放
    if (anchor) {
      left = (anchor.x - (anchor.x - curRect.left.getPx()) * scaleRatio);
      top = (anchor.y - (anchor.y - curRect.top.getPx()) * scaleRatio);
    }

    curRect.setRectNum(left, top, width, height);
    log.showInfo(TAG, `updateRectWidthDensityChange after updated curRect:[${curRect.left.getPxStr()}, ` +
      `${curRect.top.getPxStr()}, ${curRect.width.getPxStr()}, ${curRect.height.getPxStr()}]`);
  }

  /**
   * adjust rect within workspace area
   * 
   * @currRect
   * @screenInfo workspace area
   */
  public restrictRectWithRealScreenArea(currRect: SCBSessionRect, screenInfo: RealScreenInfo): void {
    if (!currRect || !screenInfo) {
      log.showWarn(TAG, 'restrictRectWithRealScreenArea currRect is null');
      return;
    }
    let top: number = currRect.top.getPx();
    let left: number = currRect.left.getPx();
    let width: number = currRect.width.getPx();
    let height: number = currRect.height.getPx();

    let isNeedUpdate: boolean = false;
    if (width > screenInfo.screenWidth) {
      width = screenInfo.screenWidth;
      isNeedUpdate = true;
    }
    if (height > screenInfo.screenHeightLimit) {
      height = screenInfo.screenHeightLimit;
      isNeedUpdate = true;
    }
    if (top < screenInfo.maxTop) {
      top = screenInfo.maxTop;
      isNeedUpdate = true;
    }
    if (left < 0) {
      left = 0;
      isNeedUpdate = true;
    }
    if ((top + height) > screenInfo.maxBottom) {
      top = screenInfo.maxBottom - height;
      isNeedUpdate = true;
    }
    if (left + width > screenInfo.screenWidth) {
      left = screenInfo.screenWidth - width;
      isNeedUpdate = true;
    }

    if (isNeedUpdate) {
      currRect.setRectNum(left, top, width, height);
    }
  }

  /**
   * 计算应用最大化的rect信息
   * 1.特殊场景插桩直接返回
   * 2.计算屏幕宽高信息
   * 3.特殊场景默认全屏显示直接返回处理
   * 4.默认为沉浸式状态，判定是否沉浸式窗口，不是则计算避让后的信息
   *
   * @param sceneSession 窗口会话
   * @param screenProperty 屏幕信息
   * @returns 最大化的rect信息
   */
  public calculateMaxRect(sceneSession: SCBSceneSession, screenProperty: SCBScreenProperty): SCBSessionRect {
    const resultRect = new SCBSessionRect(0, 0, 0, 0);
    let screenWidth = screenProperty.width;
    let screenHeight = screenProperty.height;
    // 锁屏场景、OOBE场景、使能了自动隐藏DOCK场景，应用的最大化rect调整为全屏尺寸，不区分是否沉浸式
    const isScreenLocked = SCBSceneSessionManager.getInstance().isScreenLocked();
    const isOOBEActivated = sSCBOobeManager.isOobeActivated();
    const isDockAutoHideEnable = AppStorage.get<boolean>('isDockAutoHide');
    if (isScreenLocked || isOOBEActivated || isDockAutoHideEnable) {
      log.showInfo(TAG, 'calculateMaxRect isLocked:%{public}d, isOOBE: %{public}d, isDockAutoHide: %{public}d',
        isScreenLocked, isOOBEActivated, isDockAutoHideEnable);
      resultRect.setRectNum(0, 0, screenWidth, screenHeight);
      return resultRect;
    }
    // 沉浸式最大化窗口标志
    const layoutFullScreen = sceneSession.layoutFullScreen;
    let positionX = 0;
    let positionY = 0;
    let width = screenWidth;
    let height = screenHeight;
    log.showInfo(TAG, 'calculateMaxRect layoutFullScreen=' + layoutFullScreen);
    if (!layoutFullScreen) {
      // 沉浸式下dock栏高度不参与窗口大小计算
      const statusBarHeight = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(screenProperty.screenId);
      let dockHeight = SCBSystemSceneUtils.getInstance().getDockHeightPx(screenProperty.screenId,
        UIContextUtil.getInstance().getUIContext(screenProperty.screenId));

      // dock栏高度获取失败时
      if (dockHeight === 0) {
        // 尝试从AppStorage获取
        const savedDockHeight = AppStorage.get<number>('dockHeight');
        if (savedDockHeight && savedDockHeight > 0) {
          dockHeight = vp2px(savedDockHeight);
          log.showInfo(TAG,
            'calculateMaxRect - Get dock height from AppStorage (vp): ' + savedDockHeight + ', converted to px: ' +
              dockHeight);
        } else {
          // 使用默认值
          dockHeight = 99;
          log.showInfo(TAG, 'calculateMaxRect - Use default dock height: ' + dockHeight);
        }
      }

      const heightThreshold = dockHeight + statusBarHeight;
      positionY = statusBarHeight;
      height -= heightThreshold;

      log.showInfo(TAG, 'calculateMaxRect - Status bar height: ' + statusBarHeight + ', dock height: ' + dockHeight +
        ', calculated window height: ' + height);
    }
    resultRect.setRectNum(positionX, positionY, width, height);
    return resultRect;
  }

  /**
   * 是否是某种拖拽热区类型
   *
   * @param hotAreaType 校验的热区类型
   * @param windowDragHotAreaType 当前热区值
   * @returns 满足则返回true, 否则false
   */
  public isTouchDragHotArea(hotAreaType: number, windowDragHotAreaType: number): boolean {
    return (hotAreaType & windowDragHotAreaType) !== WindowDragHotAreaType.HOT_AREA_TYPE_INVALID;
  }
}