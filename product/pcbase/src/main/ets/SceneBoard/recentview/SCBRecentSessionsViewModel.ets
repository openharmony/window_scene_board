/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
 * limitations under the License.2
 */

import sceneSessionManager from '@ohos.sceneSessionManager';
import BundleManager from '@ohos.bundle.bundleManager';
import { StyleConstants, LayoutViewModel } from '@ohos/launchercommon';
import {
  SCBSceneContainerSession,
  SCBRecentSessionInfo,
  SCBSceneContainerSessionArray,
  SCBSceneSession,
  SCBSceneSessionManager,
  ControlType,
} from '@ohos/windowscene';
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  CommonUtils,
  SingleBase,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import {
  DebugCommand,
  GlobalContext,
  DeviceHelper,
  DebugCommandManager
} from '@ohos/frameworkwrapper';
import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';
import { SCBRecentStyle, SCBRecentStyleManager } from './foldMachine/SCBRecentStyle';
import { SCBRecentPrepareManager } from './SCBRecentPrepareManager';
import { SCBRecentNotShowViewModel } from './SCBRecentNotShowViewModel';
import { SCBHprRecentLayout, SCBRecentLayout } from './SCBRecentLayout';
import { DesktopSwitchController } from '../virtualmachine/DesktopSwitchController';

const TAG = 'SCBRecentSessionsViewModel';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

interface SCBRecentSessionRowInfo {
  startIndex: number,
  endIndex: number
}

/**
 * Class RecentSessionsViewModel.
 */
export class SCBRecentSessionsViewModel extends SingleBase {
  private static Screen2RecentViewModelMap: Map<number, SCBRecentSessionsViewModel> = new Map();
  public static singleName: string = 'SCBRecentSessionsViewModel';
  private mRecentSessionsList: SCBRecentSessionInfo[] = [];
  private mSplittingSessionId: number = -1;
  private mScreenWidth: number = 0;
  private mScreenHeight: number = 0;
  private mScreenId: number;
  private mCurrentShowWidth: number = 0;
  private mCurrentShowHeight: number = 0;
  private mCardMaxHeight: number = 0;
  private mCardMinHeight: number = 0;
  private mWorkspaceWidth: number = 0;
  private mWorkspaceHeight: number = 0;
  private mCurrCardHeight: number = SCBRecentStyleConstants.DEFAULT_APP_IMAGE_HEIGHT;
  private marginToLeftEdge: number = 0;
  private splitOffsetX: number = 0;
  private splitOffsetY: number = 0;
  private cardWidthMargin: number = 0;
  private curCardHeightPercent: number;
  private scrollYOffset: number = 0;
  private rowsInfo: SCBRecentSessionRowInfo[] = [];
  private recentStyleManager: SCBRecentStyleManager;
  private bSideLastCardTop: number = 0;
  private recentLayout: SCBRecentLayout;

  public constructor(ctx?: SingleContext) {
    super(ctx);
    this.mScreenId = ctx?.extendScreenId ?? 0;
    this.recentStyleManager = SCBRecentStyleManager.getInstance(this.singleContext);
    this.curCardHeightPercent = this.recentStyleManager.getStyle().cardHeightMaxPercent;
    this.recentLayout = new SCBRecentLayout(this.mScreenId);
    this.registerDebugCommand();
  }

  /**
   * Get the recent session view model object.
   *
   * @return {object} recent session view model singleton
   */
  static getInstance(ctx?: SingleContext): SCBRecentSessionsViewModel {
    const screenId: number = ctx?.extendScreenId ?? 0;
    let recentSessionsViewModel = SCBRecentSessionsViewModel.Screen2RecentViewModelMap.get(screenId);
    if (CheckEmptyUtils.isEmpty(recentSessionsViewModel)) {
      let viewModel = new SCBRecentSessionsViewModel(ctx);
      SCBRecentSessionsViewModel.Screen2RecentViewModelMap.set(screenId, viewModel);
      return viewModel;
    }
    return recentSessionsViewModel as SCBRecentSessionsViewModel;
  }

  private rowsInfoInit(): void {
    this.rowsInfo = [];
  }

  private rowsInfoAdd(startIndex: number, endIndex: number): void {
    this.rowsInfo.push({ startIndex: startIndex, endIndex: endIndex });
    log.showInfo(`add a new row, startIndex: ${startIndex}, rowNum: ${this.getRowNum()}`);
  }

  private getRowNum(): number {
    return this.rowsInfo.length;
  }

  private getTopRowInfo(): SCBRecentSessionRowInfo | null {
    let rowNum = this.getRowNum();
    if (rowNum === 0) {
      return null;
    }
    return this.rowsInfo[rowNum - 1];
  }

  /**
   * set screen property and init
   *
   * @param width screen width
   * @param height screen height
   */
  setScreenProperty(width: number, height: number): void {
    this.mScreenWidth = width;
    this.mScreenHeight = height;
  }

  setScreenId(screenId: number): void {
    this.mScreenId = screenId;
    this.recentStyleManager = SCBRecentStyleManager.getInstance(this.singleContext);
  }

  /**
   * get screen id
   *
   * @returns screen width
   */
  getScreenId(): number {
    return this.mScreenId;
  }


  /**
   * get screen width
   *
   * @returns screen width
   */
  getScreenWidth(): number {
    return this.mScreenWidth;
  }

  /**
   * get screen height
   *
   * @returns screen height
   */
  getScreenHeight(): number {
    return this.mScreenHeight;
  }

  /**
   * set recent state property
   *
   * @param left recent left
   * @param top recent top
   * @param width recent width
   * @param height recent height
   * @param isSplitMode is in split mode, default is false
   */
  setRecentProperty(left: number, top: number, width: number, height: number): void {
    this.splitOffsetX = left;
    this.splitOffsetY = top;
    this.mCurrentShowWidth = width;
    this.mCurrentShowHeight = height;
    const recentStyle = this.recentStyleManager.getStyle();
    this.mCardMaxHeight = this.mScreenHeight * recentStyle.cardHeightMaxPercent;
    this.mCardMinHeight = this.mScreenHeight * recentStyle.cardHeightMinPercent;
    this.mWorkspaceWidth = this.mCurrentShowWidth * recentStyle.workSpacePercent;
    this.mWorkspaceHeight = this.mScreenHeight - LayoutViewModel.getInstance(this.singleContext).getDockHeight();
    this.cardWidthMargin = this.mCurrentShowWidth * SCBRecentStyleConstants.CARD_MARING_PERCENT;
    this.marginToLeftEdge = (this.mCurrentShowWidth - this.mWorkspaceWidth) / 2;
    this.recentLayout.updateRecentInfo(width, height);
    log.showInfo('recentProperty: [%{public}d, %{public}d, %{public}d, %{public}d], %{public}d, %{public}d',
      left, top, width, height, this.mWorkspaceWidth, this.marginToLeftEdge);
  }

  public getMarginToLeftEdge(): number {
    return this.marginToLeftEdge;
  }

  /**
   * get current recent show width
   *
   * @returns current recent show width
   */
  public getCurrentShowWidth(): number {
    return this.mCurrentShowWidth;
  }

  /**
   * get current recent show height
   *
   * @returns current recent show height
   */
  public getCurrentShowHeight(): number {
    return this.mCurrentShowHeight;
  }

  public getRecentWorkspaceHeight(): number {
    return this.mWorkspaceHeight;
  }

  public getRecentWorkSpaceWidth(): number {
    return this.mWorkspaceWidth;
  }

  public getRecentCardMinHeight(): number {
    return this.mCardMinHeight;
  }

  public getRecentCardMaxHeight(): number {
    return this.mCardMaxHeight;
  }

  public getRecentRowHeight(): number {
    return this.mCurrCardHeight;
  }

  /**
   * get offset in split recent mode
   *
   * @returns offset
   */
  getSplitOffsetX(): number {
    return this.splitOffsetX;
  }

  /**
   * get offset in split recent mode
   *
   * @returns offset
   */
  getSplitOffsetY(): number {
    return this.splitOffsetY;
  }

  /**
   * get recent session info that not support split mode
   *
   * @returns session info
   */
  getRecentSessionsListIfNotSupportSplitMode(): SCBRecentSessionInfo[] {
    let allContainerSessionList = SCBSceneSessionManager.getInstance().getAllContainerSessionList();
    allContainerSessionList.forEach((item) => {
      item.isNotSupportSplit = false;
    });
    let containerSessionList: SCBSceneContainerSessionArray = this.getContainerSessionList();
    const recentSessionsList: SCBRecentSessionInfo[] = [];
    for (const containerSession of Array.from(containerSessionList.values())) {
      if (containerSession.primarySession == null) {
        continue;
      }
      if (containerSession.primarySession.session.persistentId === this.mSplittingSessionId) {
        containerSession.isNotSupportSplit = false;
        continue;
      }
      let recentSessionInfo = this.getRecentSessionInfo(containerSession.primarySession);
      let supportSplit = this.isSupportSplitMode(containerSession.primarySession);
      containerSession.isNotSupportSplit = !supportSplit;
      const dialogIndex = containerSession.primarySession.subSessionList.findIndex(item => {
        return [sceneSessionManager.SubWindowModalType.TYPE_DIALOG,
          sceneSessionManager.SubWindowModalType.TYPE_WINDOW_MODALITY,
          sceneSessionManager.SubWindowModalType.TYPE_APPLICATION_MODALITY].includes(item.session.subWindowModalType);
      });
      if (!supportSplit) {
        recentSessionsList.push(recentSessionInfo);
      } else if ((dialogIndex >= 0 && !containerSession.isSplit) ||
        containerSession.primarySession.useControlList?.[0] === ControlType.PARENT_CONTROL ||
        containerSession.primarySession.useControlList?.[0] === ControlType.APP_LOCK) {
        containerSession.isNotSupportSplit = true;
        recentSessionsList.push(recentSessionInfo);
      } else if (containerSession.isSplit && containerSession.secondarySession) {
        containerSession.dividerParam.isSplitRecentPair = true;
      }
    }
    return recentSessionsList;
  }

  /**
   * get recent sessions
   *
   * @returns session info
   */
  getRecentSessionsNotInclude(persistentIds: number[]): SCBRecentSessionInfo[] {
    let recentSessions = this.getRecentSessionsListInner();
    recentSessions = recentSessions.filter((item) => {
      for (let persistentId of persistentIds) {
        if (item.sessionId === persistentId) {
          return false;
        }
      }
      return true;
    });
    this.updateRecentSessionsSize(recentSessions);
    this.layoutCards(recentSessions);
    this.judgeAnimationType(recentSessions);
    this.mRecentSessionsList = recentSessions;
    log.showInfo(`getRecentSessionsNotInclude:${recentSessions.length}, ${this.splitOffsetX}, ${this.splitOffsetY}`);
    return recentSessions;
  }

  /**
   * get recent sessions
   *
   * @returns session info
   */
  getRecentSessions(): SCBRecentSessionInfo[] {
    let recentSessions = this.getRecentSessionsListInner();
    this.updateRecentSessionsSize(recentSessions);
    this.layoutCards(recentSessions);
    this.judgeAnimationType(recentSessions);
    this.mRecentSessionsList = recentSessions;
    log.showInfo(`getRecentSessions:${this.mRecentSessionsList.length}, ${this.splitOffsetX}, ${this.splitOffsetY}`);
    return this.mRecentSessionsList;
  }

  public getRecentSessionList(): SCBRecentSessionInfo[] {
    return this.mRecentSessionsList;
  }

  /**
   * set current split window id
   *
   * @param sessionId
   */
  setSplittingSessionId(sessionId: number): void {
    this.mSplittingSessionId = sessionId;
  }

  /**
   * translate window session info to recent session info
   *
   * @param scbSceneSession scene session
   * @returns recent session info
   */
  private getRecentSessionInfo(scbSceneSession: SCBSceneSession): SCBRecentSessionInfo {
    const recentSessionInfo = new SCBRecentSessionInfo();
    recentSessionInfo.sessionId = scbSceneSession.session.persistentId;
    recentSessionInfo.bundleName = scbSceneSession.sceneInfo.bundleName;
    recentSessionInfo.abilityName = scbSceneSession.sceneInfo.abilityName;
    recentSessionInfo.moduleName = scbSceneSession.sceneInfo.moduleName;
    recentSessionInfo.width = scbSceneSession.currRect.width.getVp();
    recentSessionInfo.height = scbSceneSession.currRect.height.getVp();
    if (recentSessionInfo.width === 0 || recentSessionInfo.height === 0) {
      recentSessionInfo.aspectRatio = SCBRecentStyleConstants.DEFAULT_APP_RADIO;
    } else {
      recentSessionInfo.aspectRatio = recentSessionInfo.width / recentSessionInfo.height;
    }
    return recentSessionInfo;
  }

  /**
   * translate window session info to recent session info
   *
   * @param scbSceneSession scene session
   * @returns is support split mode or not
   */
  private isSupportSplitMode(scbSceneSession: SCBSceneSession): boolean {
    const supportModes = this.getSupportWindowModes(scbSceneSession);
    return supportModes?.indexOf(BundleManager.SupportWindowMode.SPLIT) > -1;
  }

  private getSupportWindowModes(scbSceneSession: SCBSceneSession): BundleManager.SupportWindowMode[] {
    if (scbSceneSession.sceneInfo.supportWindowModes !== null &&
      scbSceneSession.sceneInfo.supportWindowModes !== undefined &&
      scbSceneSession.sceneInfo.supportWindowModes.length !== 0) {
      return scbSceneSession.sceneInfo.supportWindowModes;
    }
    if (scbSceneSession.sceneInfo.bundleName === undefined || scbSceneSession.sceneInfo.moduleName === undefined ||
      scbSceneSession.sceneInfo.abilityName === undefined) {
      return [];
    }
    let queryKey = scbSceneSession.sceneInfo.bundleName + scbSceneSession.sceneInfo.moduleName +
    scbSceneSession.sceneInfo.abilityName;
    let supportModes = SCBSceneSessionManager.getInstance().getAbilityWindowSupportInfo(queryKey);
    if (supportModes) {
      return supportModes;
    }
    return [];
  }

  private filterContainerByScreenId(containerSessionList: SCBSceneContainerSessionArray):
    SCBSceneContainerSessionArray {
    if (!containerSessionList) {
      return new SCBSceneContainerSessionArray();
    }
    const result: SCBSceneContainerSession[] = containerSessionList.filter((item) => {
      return item.screenProperty.screenId === this.mScreenId;
    });
    return result as SCBSceneContainerSessionArray;
  }

  /**
   * get all SCBSceneContainerSession in Recent after filtering virtualMachine and SubWindow by ScreenId
   * @param screenId
   * @returns
   */
  private getContainerSessionListByScreenId(screenId: number): SCBSceneContainerSessionArray {
    let containerSessionList: SCBSceneContainerSessionArray =
      SCBSceneSessionManager.getInstance().getContainerSessionList(screenId);
    containerSessionList = this.isVM(containerSessionList);
    containerSessionList = this.filterContainerByScreenId(containerSessionList);
    // 用as进行类型强转未生效
    containerSessionList = this.convertToSCBSceneContainerSessionArray(containerSessionList);
    log.showInfo(`getContainerSessionListByScreenId ${screenId}, ${containerSessionList.length}`);
    return containerSessionList as SCBSceneContainerSessionArray;
  }

  /**
   * get all SCBSceneContainerSession in Recent after filtering virtualMachine and SubWindow
   * @param screenId
   * @returns
   */
  public getContainerSessionList(): SCBSceneContainerSessionArray {
    return this.getContainerSessionListByScreenId(this.mScreenId);
  }

  /**
   * 显示在任务中心的containerSession
   * @returns
   */
  public getShowInRecentContainerSessionList(): SCBSceneContainerSessionArray {
    const showInRecentContainerSessionList = this.getContainerSessionListByScreenId(this.mScreenId).filter(session => {
      return !SCBRecentNotShowViewModel.isNotShowInRecent(session);
    })
    return this.convertToSCBSceneContainerSessionArray(showInRecentContainerSessionList);
  }

  /**
   * 数组[] 转化为SCBSceneContainerSessionArray 对象
   * @returns
   */
  private convertToSCBSceneContainerSessionArray(originArray: SCBSceneContainerSession[]):
    SCBSceneContainerSessionArray {
    let result: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    originArray.forEach((containerSession: SCBSceneContainerSession) => {
      result.add(containerSession);
    })
    return result;
  }

  /**
   * translate window session info to recent session info
   *
   * @param isSplittingMode
   * @returns
   */
  private getRecentSessionsListInner(): SCBRecentSessionInfo[] {
    let containerSessionList: SCBSceneContainerSessionArray = this.getShowInRecentContainerSessionList();
    const recentSessionsList: SCBRecentSessionInfo[] = [];
    for (const containerSession of Array.from(containerSessionList.values())) {
      if (!containerSession.primarySession || containerSession.primarySession.isClosing) {
        continue;
      }
      let recentSessionInfo = this.getRecentSessionInfo(containerSession.primarySession);
      recentSessionInfo = this.updateRecentSessionInfo(recentSessionInfo, containerSession);
      recentSessionsList.push(recentSessionInfo);
    }
    return recentSessionsList.reverse();
  }

  private updateRecentSessionInfo(recentSessionInfo: SCBRecentSessionInfo,
    containerSession: SCBSceneContainerSession): SCBRecentSessionInfo {
    recentSessionInfo.isActive = containerSession.isActive;
    if (containerSession.primarySession) {
      recentSessionInfo.isMinimizing = containerSession.primarySession.isMinimizing;
    }
    recentSessionInfo.isSplitRecentPair = containerSession.dividerParam.isSplitRecentPair;
    recentSessionInfo.isUpDownSplit = containerSession.dividerParam.isExpandUpDownSplit();
    if (recentSessionInfo.isSplitRecentPair && containerSession.secondarySession && recentSessionInfo.width &&
      containerSession.secondarySession.currRect.height.getVp() > 0) {
      recentSessionInfo.secondaryWidth = containerSession.secondarySession.currRect.width.getVp();
      recentSessionInfo.secondaryAspectRatio = recentSessionInfo.secondaryWidth /
      containerSession.secondarySession.currRect.height.getVp();
    }
    if (containerSession.isSplit && (!recentSessionInfo.isSplitRecentPair ||
      (recentSessionInfo.isSplitRecentPair && recentSessionInfo.isUpDownSplit))) {
      let priSession = containerSession.dividerParam.isSplitPrimaryMode ? containerSession.primarySession :
      containerSession.secondarySession;
      let secSession = containerSession.dividerParam.isSplitPrimaryMode ? containerSession.secondarySession :
      containerSession.primarySession;
      let splitWidth = 0;
      let splitHeight = 0;
      if (priSession && secSession) {
        splitWidth = secSession.currRect.left.getVp() - priSession.currRect.left.getVp() +
        secSession.currRect.width.getVp();
        splitHeight = secSession.currRect.top.getVp() - priSession.currRect.top.getVp() +
        secSession.currRect.height.getVp();
      }
      if (splitHeight > 0 && splitWidth > 0) {
        recentSessionInfo.aspectRatio = splitWidth / splitHeight;
      }
    }
    return recentSessionInfo;
  }

  private isVM(containerSessionList: SCBSceneContainerSessionArray): SCBSceneContainerSessionArray {
    if (DesktopSwitchController.getInstance().hasVmAbility() &&
    DesktopSwitchController.getInstance().getVmSceneContainerSession()) {
      let arr = new SCBSceneContainerSessionArray().concat(containerSessionList);
      let session = DesktopSwitchController.getInstance().getVmSceneContainerSession();
      if (session) {
        const index = arr.findIndex((item) => {
          return item.containerId === session?.containerId;
        });
        if (index !== -1) {
          log.showInfo(`scene container session(id: ${session.containerId}) is not in container`);
          arr.splice(index, 1);
          return arr as SCBSceneContainerSessionArray;
        }
      }
    }
    return containerSessionList;
  }

  private canAddToRow(recentSessions: SCBRecentSessionInfo[], startIndex: number, endIndex: number,
    heightPercent: number): boolean {
    let totalWidth: number = 0;
    let cardHeight = this.calcRecentCardHeightByPercent(heightPercent);
    for (let i = startIndex; i <= endIndex; i++) {
      let item = recentSessions[i];
      let cardWidth = this.calcRecentCardWidthByAspectWithLimit(item, cardHeight);
      totalWidth += cardWidth;
      totalWidth += this.cardWidthMargin;
    }
    // N个card中间有N-1个margin，因此减去1个margin
    totalWidth -= this.cardWidthMargin;
    if (totalWidth < this.mWorkspaceWidth || CommonUtils.equals(totalWidth, this.mWorkspaceWidth)) {
      return true;
    }
    return false;
  }

  private getEffectiveNumber(rawNumber: number, digit: number): number {
    return Math.round(rawNumber * Math.pow(10, digit)) / Math.pow(10, digit);
  }

  private tryReduceCardHeightPercent(recentSessions: SCBRecentSessionInfo[], startIndex: number,
    endIndex: number): boolean {
    let reducedHeightPercent = this.curCardHeightPercent;
    const minHeightPercent: number = this.recentStyleManager.getStyle().cardHeightMinPercent;
    if (CommonUtils.equals(reducedHeightPercent, minHeightPercent)) {
      return false;
    }
    reducedHeightPercent -= 0.01;
    while (reducedHeightPercent > minHeightPercent ||
    CommonUtils.equals(this.getEffectiveNumber(reducedHeightPercent, 5), minHeightPercent)) {
      let success = this.canAddToRow(recentSessions, startIndex, endIndex, reducedHeightPercent);
      if (success) {
        this.curCardHeightPercent = reducedHeightPercent;
        this.mCurrCardHeight = this.calcRecentCardHeightByPercent(this.curCardHeightPercent);
        return true;
      }
      reducedHeightPercent -= 0.01;
    }
    // reduce recent card height to mini percent(18%)
    this.curCardHeightPercent = minHeightPercent;
    this.mCurrCardHeight = this.calcRecentCardHeightByPercent(this.curCardHeightPercent);
    return false;
  }

  private calcRecentCardWidthByAspect(recentSession: SCBRecentSessionInfo, cardHeight: number): number {
    let cardWidth = cardHeight * Number(recentSession.aspectRatio);
    if (recentSession.isSplitRecentPair && !recentSession.isUpDownSplit) {
      cardWidth += SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE;
      cardWidth += Math.max(cardHeight * Number(recentSession.secondaryAspectRatio));
    }
    if (this.isTooLongWhenMinPercent(recentSession, cardHeight)) {
      cardWidth = SCBRecentStyleConstants.CARD_MAX_WIDTH;
    }
    return cardWidth;
  }

  private calcRecentCardWidthByAspectWithLimit(recentSession: SCBRecentSessionInfo, cardHeight: number): number {
    let cardWidth = Math.max(SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH,
      cardHeight * Number(recentSession.aspectRatio));
    if (recentSession.isSplitRecentPair && !recentSession.isUpDownSplit) {
      cardWidth += SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE;
      cardWidth += Math.max(SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH,
        cardHeight * Number(recentSession.secondaryAspectRatio));
    }
    if (this.isTooLongWhenMinPercent(recentSession, cardHeight)) {
      cardWidth = SCBRecentStyleConstants.CARD_MAX_WIDTH;
    }
    return cardWidth;
  }

  private calcRecentCardHeightByPercent(heightPercent: number): number {
    return this.mScreenHeight * heightPercent;
  }

  private calcRecentCardHeightPercent(heightPercent: number): number {
    return heightPercent / this.mScreenHeight;
  }

  public setScrollYOffset(yOffset: number): number {
    let res: number = yOffset % (this.mCurrCardHeight + this.getHeightMargin());
    const windowMidPoint = this.getTitleHeight() + this.mCurrCardHeight / 2;
    if (res < windowMidPoint) {
      res = -res;
    } else {
      res = this.mCurrCardHeight + this.getHeightMargin() - res;
    }
    this.scrollYOffset = yOffset + res;
    return this.scrollYOffset;
  }

  public getSessionScrollOffsetY(offsetY: number = 0): number {
    return 0;
  }

  /**
   * B面最后一张卡片相对屏幕的位置
   */
  public getBSideLastCardTop(): number {
    return this.bSideLastCardTop - this.scrollYOffset;
  }

  /**
   * layout window cards in recent state
   *
   * @param recentSessions recent window session info
   */
  private layoutCards(recentSessions: SCBRecentSessionInfo[]): void {
    const marginToTopEdge = this.recentLayout.getMarginTop() + this.recentLayout.getPaddingTop();
    log.showInfo(`layoutCards rowNum: ${this.getRowNum()}, ${marginToTopEdge}`);
    const len = recentSessions.length;
    let left = this.marginToLeftEdge + this.splitOffsetX;
    let animateLeft = this.splitOffsetX;
    let top = marginToTopEdge + this.splitOffsetY;
    let enterAnimateTop = top * SCBRecentStyleConstants.RECENT_ANIM_RATIO;
    let exitAnimateTop = enterAnimateTop;
    let rowWidth: number = 0;
    let rowNum: number = 0;
    let column: number = 0;
    for (let i = 0; i < len; i++) {
      let recentSession = recentSessions[i];
      rowWidth += Number(recentSession.bgWidth);
      if (rowWidth > this.mWorkspaceWidth) {
        left = this.marginToLeftEdge + this.splitOffsetX;
        animateLeft = this.splitOffsetX;
        top += this.mCurrCardHeight + this.getHeightMargin();
        enterAnimateTop += (this.mCurrCardHeight + this.getHeightMargin()) *
        SCBRecentStyleConstants.RECENT_ANIM_RATIO;
        exitAnimateTop += this.mCurrCardHeight + this.getHeightMargin();
        rowWidth = Number(recentSession.bgWidth);
        rowNum++;
        column = 0;
      }
      rowWidth += this.cardWidthMargin;
      recentSession.left = left;
      recentSession.top = top;
      recentSession.animateLeft = animateLeft;
      recentSession.enterAnimateTop = enterAnimateTop;
      recentSession.exitAnimateTop = enterAnimateTop;
      recentSession.rowNum = rowNum;
      recentSession.column = column;
      left += Number(recentSession.bgWidth) + this.cardWidthMargin;
      animateLeft += Number(recentSession.bgWidth) * SCBRecentStyleConstants.RECENT_ANIM_RATIO +
      this.cardWidthMargin;
      column++;
    }
    // cards align center
    for (let row = 0; row <= rowNum; row++) {
      let sessions = recentSessions.filter(session => Number(session.rowNum) === row);
      let rWidth: number = 0;
      let animateWidth: number = 0;
      sessions.forEach(session => {
        rWidth += Number(session.bgWidth);
        animateWidth += Number(session.bgWidth) * SCBRecentStyleConstants.RECENT_ANIM_RATIO;
      });
      rWidth += (sessions.length - 1) * this.cardWidthMargin;
      animateWidth += (sessions.length - 1) * this.cardWidthMargin;
      let diff = (this.mCurrentShowWidth - rWidth) / 2 - this.marginToLeftEdge;
      let animateDiff = (this.mCurrentShowWidth - animateWidth) / 2;
      sessions.forEach(session => {
        session.left += diff;
        session.animateLeft += animateDiff;
      });
    }
  }

  public getMarginBottom(): number {
    const recentStyle = this.recentStyleManager.getStyle();
    return this.recentLayout.getMarginTop() + this.recentLayout.getPaddingTop();
  }

  /**
   * get title view height
   *
   * @returns height
   */
  private getTitleHeight(): number {
    return SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE +
      SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN * 2;
  }

  /**
   * get the distance between two rows
   *
   * @returns distance
   */
  public getHeightMargin(): number {
    return this.mScreenHeight * this.recentStyleManager.getStyle().cardLineSpacePercent;
  }

  /**
   * determine the dynamic effect type based on the location and active
   * @param recentSessions recent window session info
   * @param scroll current offset
   */
  public judgeAnimationType(recentSessions: SCBRecentSessionInfo[], offsetY: number = 0): void {
    const len = recentSessions.length;
    for (let i = 0; i < len; i++) {
      let recentSession = recentSessions[i];
      const sessionCurrentPos = recentSession.top - offsetY - this.splitOffsetY;
      // 不在屏幕内的窗口，不做动效
      if (sessionCurrentPos < 0 || sessionCurrentPos > this.mScreenHeight) {
        recentSession.animType = SCBRecentStyleConstants.RECENT_ANIM_TYPE_FADE_OUT;
      } else {
        recentSession.animType = (!recentSession.isActive || recentSession.isMinimizing) ?
        SCBRecentStyleConstants.RECENT_ANIM_TYPE_CHAIN : SCBRecentStyleConstants.RECENT_ANIM_TYPE_DEFAULT;
      }
    }
  }

  public isTooShortWhenMinPercent(recentSession: SCBRecentSessionInfo, destHeight: number): boolean {
    // 缩放比例到最小(0.18)， 等比缩小到目标高度, 宽度还是太窄
    // 如果还没锁缩放到最小， width还有进一步缩小的空间，无法判断是否为超宽卡片还是超短卡片
    const minHeightPercent: number = this.recentStyleManager.getStyle().cardHeightMinPercent;
    let heightPercent = this.calcRecentCardHeightPercent(destHeight);
    if (CommonUtils.equals(heightPercent, minHeightPercent) || heightPercent < minHeightPercent) {
      let destWidth = destHeight * recentSession.aspectRatio;
      return SCBRecentSessionsViewModel.isRecentCardWidthMinLimit(destWidth);
    }
    return false;
  }

  public isTooLongWhenMinPercent(recentSession: SCBRecentSessionInfo, destHeight: number): boolean {
    // 缩放比例到最小(0.18)，等比缩小到目标高度，宽度还是太宽
    // 如果还没锁缩放到最小， width还有进一步缩小的空间，无法判断是否为超宽卡片还是超短卡片
    const minHeightPercent: number = this.recentStyleManager.getStyle().cardHeightMinPercent;
    let heightPercent = this.calcRecentCardHeightPercent(destHeight);
    if (CommonUtils.equals(heightPercent, minHeightPercent) || heightPercent < minHeightPercent) {
      let destWidth = destHeight * recentSession.aspectRatio;
      return SCBRecentSessionsViewModel.isRecentCardWidthMaxLimit(destWidth);
    }
    return false;
  }

  public static isRecentCardWidthMinLimit(scaledWidth: number): boolean {
    return (scaledWidth < SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH) ||
    CommonUtils.equals(scaledWidth, SCBRecentStyleConstants.CARD_TITLE_MIN_WIDTH);
  }

  public static isRecentCardWidthMaxLimit(scaledWidth: number): boolean {
    return (scaledWidth > SCBRecentStyleConstants.CARD_MAX_WIDTH) ||
    CommonUtils.equals(scaledWidth, SCBRecentStyleConstants.CARD_MAX_WIDTH);
  }

  private updateRecentSessionsSize(recentSessions: SCBRecentSessionInfo[]): void {
    let recentCardHeight = this.calculateRecentCardHeight(recentSessions);
    recentSessions.forEach((item) => {
      item.height = recentCardHeight;
      item.bgHeight = recentCardHeight;
      item.width = this.calcRecentCardWidthByAspect(item, recentCardHeight);
      item.bgWidth = this.calcRecentCardWidthByAspectWithLimit(item, recentCardHeight);
      // if recent card is too long, width will limit to CARD_MAX_WIDTH, so height will aspect scale
      if (this.isTooLongWhenMinPercent(item, recentCardHeight)) {
        item.height = item.width / Number(item.aspectRatio);
      }
      // if recent card has secondary session, ratio will change, update aspect ratio
      item.aspectRatio = item.width / item.height;
      if (item.isUpDownSplit && item.isSplitRecentPair) {
        item.height -= SCBRecentStyleConstants.SPLIT_UP_DOWN_SPACE;
      }
    });
    this.recentLayout.updateCardInfo(this.mCurrCardHeight, this.getHeightMargin(), this.getRowNum());
  }

  private calculateRecentCardHeight(recentSessions: SCBRecentSessionInfo[]): number {
    if (recentSessions.length === 0) {
      return 0;
    }
    this.rowsInfoInit();
    // add the first row
    this.rowsInfoAdd(0, -1);
    // init curCardHeightPercent and mCurrCardHeight
    this.curCardHeightPercent = this.recentStyleManager.getStyle().cardHeightMaxPercent;
    this.mCurrCardHeight = this.calcRecentCardHeightByPercent(this.curCardHeightPercent);
    this.calculateRecentCardHeightRecursive(recentSessions, 0);

    return this.mCurrCardHeight;
  }

  private calculateRecentCardHeightRecursive(recentSessions: SCBRecentSessionInfo[], startIndex: number): void {
    for (let i = startIndex; i < recentSessions.length; i++) {
      if (this.canAddToRow(recentSessions, startIndex, i, this.curCardHeightPercent)) {
        let curRowInfo = this.getTopRowInfo();
        if (curRowInfo) {
          curRowInfo.endIndex = i;
        }
        log.showDebug(`index: ${i} add to row ${this.getRowNum()} success`);
        continue;
      }
      if (this.tryReduceCardHeightPercent(recentSessions, startIndex, i)) {
        log.showInfo(`reduceCardHeightPercent success, new heightPercent ${this.curCardHeightPercent}`);
        // update current row info's endIndex
        let curRowInfo = this.getTopRowInfo();
        if (curRowInfo) {
          curRowInfo.endIndex = i;
        }
        log.showDebug(`index: ${i} add to row ${this.getRowNum()} success`);
        continue;
      }
      if (i === startIndex) {
        log.showFatal(`add ${i} to row ${this.getRowNum()} failed. \
            current height percent ${this.curCardHeightPercent}, aspect: ${recentSessions[i].aspectRatio}, \
            height: ${recentSessions[i].height}, width: ${recentSessions[i].width}, \
            name: ${recentSessions[i].bundleName}`);
        return;
      }
      // add a new row
      let nextRowStartIndex = i;
      this.rowsInfoAdd(nextRowStartIndex, -1);
      this.calculateRecentCardHeightRecursive(recentSessions, nextRowStartIndex);
      // return, terminate recursive
      return;
    }
  }

  public destroy(): void {
    this.unregisterDebugCommand();
  }

  public print(): void {
    let info: string = '';
    info += `screen width: ${this.mScreenWidth}, screen height: ${this.mScreenHeight} \r\n`;
    info += `split offset:[${this.splitOffsetX}, ${this.splitOffsetY}]`;
    info += `workspace width: ${this.mWorkspaceWidth}, workspace height: ${this.mWorkspaceHeight} \r\n`;
    info += `current card height: ${this.mCurrCardHeight}, height percent: ${this.curCardHeightPercent} \r\n`;
    info += `recent sessions length: ${this.mRecentSessionsList.length}.\r\n`;
    this.mRecentSessionsList.forEach((item, index) => {
      info += `${index}: ${item.bundleName}/${item.abilityName}/${item.moduleName}(id: ${item.sessionId}) `;
      info += `width: ${item.width}, height: ${item.height}, aspectRatio: ${item.aspectRatio}, `;
      info += `scaleX: ${item.scaleX}, scaleY: ${item.scaleY}, `;
      info += `top: ${item.top}, left: ${item.left}, isSplitRecentPair: ${item.isSplitRecentPair}, `;
      info += `row: ${item.rowNum}, animationType: ${item.animType}, active: ${item.isActive}.\r\n`;
    });
    this.rowsInfo.forEach((item, row) => {
      info += `row: ${row}, startIndex: ${item.startIndex}, endIndex: ${item.endIndex}, `;
    })
    log.showInfo(info);
  }

  private debugGetRecentSessionsInfo(args: string[]): string {
    if (args.length === 0) {
      return JSON.stringify(this.mRecentSessionsList);
    }
    let index = Number(args[0]);
    if (index >= this.mRecentSessionsList.length) {
      return 'index is out of bounds';
    }
    return JSON.stringify(this.mRecentSessionsList[index]);
  }

  private registerDebugCommand(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'info',
        callback: (args: string[]): string => {
          return this.debugGetRecentSessionsInfo(args);
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG + this.mScreenId, cmds);
  }

  private unregisterDebugCommand(): void {
    DebugCommandManager.getInstance().unregister(TAG + this.mScreenId);
  }
}

export class MemoryHelper {
  private memoryList: number[] = [];
  private static screen2MemoryHelper: Map<number, MemoryHelper> = new Map();
  private mScreenId: number = -1;

  constructor() {
    GlobalContext.getInstance().setObject('memoryRefresh', ((): void => {
      this.refresh();
    }));
  }

  /**
   * set the screenId
   * @param screenId
   */
  public setScreenId(screenId: number): void {
    this.mScreenId = screenId;
  }

  /**
   * get the screenId
   * @returns
   */
  public getScreenId(): number {
    return this.mScreenId;
  }

  static getInstance(screenId: number): MemoryHelper {
    let curMemoryHelper = MemoryHelper.screen2MemoryHelper.get(screenId);
    if (CheckEmptyUtils.isEmpty(curMemoryHelper)) {
      let memoryHelper = new MemoryHelper();
      memoryHelper.setScreenId(screenId);
      MemoryHelper.screen2MemoryHelper.set(screenId, memoryHelper);
      return memoryHelper;
    }
    return curMemoryHelper as MemoryHelper;
  }

  /**
   * init the memory
   */
  public init(len: number): void {
    if (this.memoryList.length > 0) {
      this.memoryList = [];
    }
    for (let index = 0; index <= len; index++) {
      this.memoryList[index] = -1;
    }
    log.showInfo(`init len:${this.memoryList.length}`);
  }

  /**
   * reset the memory
   */
  public refresh(): void {
    this.memoryList = [];
  }

  /**
   * get the length of memory
   */
  public getLength(): number {
    return this.memoryList.length;
  }

  /**
   * set value in memory
   * @param index
   * @param value
   */
  public setCache(index: number, value: number): void {
    this.memoryList[index] = value;
    log.showInfo(`index:${index} value:${this.memoryList[index]}`);
  }

  /**
   * get value from memory by index
   * @param index
   * @returns
   */
  public getCache(index: number): number {
    log.showInfo(`resultIndex${this.memoryList[index]} rowNum${index}`);
    return this.memoryList[index];
  }

  /**
   * destroy the  memory instance with screenId
   */
  public destroy(): void {
    MemoryHelper.screen2MemoryHelper.delete(this.mScreenId);
  }
}
