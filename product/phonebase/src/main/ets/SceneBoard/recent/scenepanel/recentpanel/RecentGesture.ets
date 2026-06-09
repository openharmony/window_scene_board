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

import curves from '@ohos.curves';
import {
  LogHelper,
  LogDomain
} from '@ohos/basicutils';
import {
  SCBSceneContainerSession,
  SCBScenePanelManager,
  SCBSessionShowInScreenIndex,
  SCBSceneContainerSessionArray
} from '@ohos/windowscene';
import { DebugCommand, DebugCommandManager, HiSysEventUtil, DeviceHelper } from '@ohos/frameworkwrapper';
import { RotationConstants } from '@ohos/commonconstants';
import { ItemUtils } from '@ohos/componenthelper';
import {
  animateExAddOnFinish,
  AnimateExArgsType,
  animateExBreak,
  animateExNew,
  animateExStart
} from '@ohos/windowscene/Index';
import { CommonConstants, StyleConstants } from '@ohos/launchercommon';
import { RecentsStyleConstants } from '@ohos/windowscene';
import { recentLayoutConfigInstance } from '@ohos/recents';
import systemparameter from '@ohos.systemParameterEnhance';
import { GestureHelper } from '../common/GestureHelper';
import { recentRuntimeInstance } from './RecentRuntimeModel';
import { RecentLayoutManager } from '../../common/RecentLayoutManager';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { ContainerBuilder, ContainerBuilderConfig } from '../../common/ContainerBuild';
import { RecentForegroundBlurAniMgr } from './RecentForegroundBlurAniMgr';
import { RecentAccessibilityUtils } from './RecentAccessibilityUtils';

const TAG = 'RecentGesture';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class RecentGesture {
  private readonly panelManager: SCBScenePanelManager
  private isNewStyle: boolean = true;

  /* start: cache for high performance */
  public removingIndex: number = -1;
  public removingContainerSession: SCBSceneContainerSession | null = null;
  private screenWidth: number = 0;
  public recentScale: number = 0;
  public recentCardBorderRadius: number = 0;
  /* end: cache for high performance */

  public gestureHelperInstance: GestureHelper = new GestureHelper();
  // 多任务卡片数量信息
  public multiCardsNum: number = 0;
  public multiColumnNum: number = 0;
  public totalColumnNum: number = 0;
  // 跟手动效属性值
  public translationUpY: number = 0;
  public translationDownY: number = 0;
  // 补位动效属性值
  public deleteColumnIndex: number = 0;
  public actualAnimationLength: number = 0;
  public actualAnimationColumnLength: number = 0;
  public multiAnimationLength: number = 0;
  // 整体布局信息
  public leftColumnIndex: number = 0;
  public middleColumnIndex: number = 0;
  public rightColumnIndex: number = 0;
  public isRightContainerFill: boolean = false;
  public correctScreenOffsetX: number = 0;
  public tolerance: number = 10;
  public isFourthColumnShown: boolean = false;
  // 当前卡片的左右侧卡片偏移信息
  public leftCardTranslateX: number = 0;
  public rightCardTranslateX: number = 0;

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
    this.isNewStyle = (systemparameter.getSync('sceneboard.isNewStyle', 'true') === 'true');
    this.registerDebugCommand();
    this.createAnimations();
  }

  private createAnimations(): void {
    this.createRestoreMoveUpAnimation();
  }

  // 初始化部分基础值
  public initGestureValue(multiCardsNum: number, curIndex: number, curOffsetX: number) {
    this.multiCardsNum = multiCardsNum;
    this.multiColumnNum = Math.floor((multiCardsNum - recentRuntimeInstance.leftBoundaryIndex + 1) / 2) +
    recentRuntimeInstance.leftBoundaryColumn;
    this.totalColumnNum = this.multiColumnNum;
    this.getScreenColumnIndexInMultiRow(curIndex);
    this.checkFourthColumnVisibility(curOffsetX);
  }

  // 更新与跟手动效相关的属性
  public updateGestureValue(sceneContainerSessionList: SCBSceneContainerSession[]) {
    if (!sceneContainerSessionList) {
      return;
    }
    let screenProperty = this.panelManager.getScreenProperty();
    let recentScale = RecentLayoutManager.getScale(screenProperty);
    let length = sceneContainerSessionList.length;
    // 跟手移动的距离计算
    this.translationUpY = (length >= recentRuntimeInstance.leftBoundaryIndex + 1) ?
      sceneContainerSessionList[length - 1]?.needRenderTranslate.translateY : 0;
    this.translationDownY = (length >= recentRuntimeInstance.leftBoundaryIndex + 2) ?
      sceneContainerSessionList[length - 2]?.needRenderTranslate.translateY : 0;
    this.screenWidth = px2vp(screenProperty.width);
    this.recentScale = recentScale;
  }

  // 判断删除后左补位或右补位，更新与补位动效相关的属性
  public setContainerFillDirection(curIndex: number, curOffsetX: number, index: number, isFloatSession: boolean): void {
    // 删除双行小卡片做右补位的前提是有列变换
    if ((this.multiCardsNum - recentRuntimeInstance.leftBoundaryIndex) % 2 == 1) {
      this.setContainerFillDirectionColumnIsChange(curOffsetX, index);
    } else {
      this.isRightContainerFill = false;
    }
    if (!this.isRightContainerFill) {
      if (curIndex <= 1) {
        this.actualAnimationLength = index;
      } else {
        this.actualAnimationLength = RecentsStyleConstants.RECENT_VIEW_COUNT_MULTI -
          (2 * curIndex + 3 - (this.multiCardsNum - recentRuntimeInstance.leftBoundaryIndex) % 2 - index);
        this.actualAnimationLength = Math.max(this.actualAnimationLength, 0);
      }
    }
  }

  private setContainerFillDirectionColumnIsChange(curOffsetX: number, index: number): void {
    if (this.leftColumnIndex <= recentRuntimeInstance.leftBoundaryColumn &&
      this.rightColumnIndex < this.totalColumnNum - 1) {
      this.isRightContainerFill = true;
      this.correctScreenOffsetX = curOffsetX;
      this.actualAnimationLength = index; // 做交叉动效的卡片张数
      this.deleteColumnIndex = this.multiColumnNum + index - this.multiCardsNum;
      if (this.middleColumnIndex <= 0) {
        this.actualAnimationColumnLength = 2 - this.deleteColumnIndex; // 做平移动效的卡片列数
      } else {
        this.actualAnimationColumnLength = 3 - this.deleteColumnIndex;
      }
      this.multiAnimationLength = 7; // 要做动效的小卡片总张数（包含交叉动效、平移动效和删除当前张）
    } else if (this.multiCardsNum == recentRuntimeInstance.leftBoundaryIndex + 5) {
      let tempOffsetX: number = curOffsetX - (this.recentScale * this.screenWidth +
      Number(StyleConstants.RECENT_MARGIN_SPACING_MULTI));
      if (tempOffsetX < 0) {
        this.isRightContainerFill = true;
        this.actualAnimationLength = index;
        this.multiAnimationLength = 5;
        this.correctScreenOffsetX = (3 * this.recentScale - 1) / 2 * this.screenWidth +
          2 * Number(StyleConstants.RECENT_MARGIN_SPACING_MULTI);
      } else {
        this.isRightContainerFill = false;
      }
    } else {
      this.isRightContainerFill = false;
    }
  }

  // 获取屏幕中显示的左、中、右三列任务在整个任务列表中的列下标。若显示四列，获取前三列下标
  public getScreenColumnIndexInMultiRow(curIndex: number): void {
    if (this.multiColumnNum == recentRuntimeInstance.leftBoundaryColumn + 1) {
      this.middleColumnIndex = -1;
    } else {
      this.middleColumnIndex = curIndex;
    }
    this.leftColumnIndex = this.middleColumnIndex - 1;
    this.rightColumnIndex = this.middleColumnIndex + 1;
  }

  // 判断屏幕是否显示四列
  public checkFourthColumnVisibility(curOffsetX: number): void {
    if (this.multiColumnNum == recentRuntimeInstance.leftBoundaryColumn) {
      this.isFourthColumnShown = false;
      return;
    }
    let supposeOffsetX: number = curOffsetX;
    let recentScale: number = this.recentScale;
    let screenWidth: number = this.screenWidth;
    let columnSpacing: number = StyleConstants.RECENT_MARGIN_SPACING_MULTI;
    if (this.multiColumnNum == recentRuntimeInstance.leftBoundaryColumn + 1) {
      supposeOffsetX = recentScale * screenWidth + columnSpacing;
    } else {
      supposeOffsetX = recentScale * screenWidth / 2 + columnSpacing + (this.totalColumnNum - 1) *
        (recentScale * screenWidth + columnSpacing) - screenWidth / 2;
    }
    if (Math.abs(supposeOffsetX - curOffsetX) < this.tolerance) {
      this.isFourthColumnShown = false;
    } else {
      this.isFourthColumnShown = true;
    }
    return;
  }

  public playTranslateAnimationForNeighborCards(index: number): void {
    if (!this.isNewStyle) {
      return;
    }
    if (recentRuntimeInstance.notRemovingSessionList.isEmpty()) {
      log.info(`recentRuntimeInstance.notRemovingSessionList is empty.`);
      return;
    }
    let sceneContainerSession = recentRuntimeInstance.notRemovingSessionList[index];
    if (!sceneContainerSession) {
      log.info(`playTranslateAnimationForNeighborCards return. index ${index}`);
      return;
    }
    let componentInfo = ItemUtils.getRectangleById(sceneContainerSession.getSceneContainerComponentId());
    let diffScaleX = sceneContainerSession.needRenderScale.scaleX - componentInfo.scale.x;
    let distanceX = px2vp(componentInfo.size.width) * diffScaleX / 2;
    let diffScaleY = sceneContainerSession.needRenderScale.scaleY - componentInfo.scale.y;
    let distanceY = px2vp(componentInfo.size.height) * diffScaleY / 2;
    let param: AnimateParam = {
      curve: curves.responsiveSpringMotion()
    };
    animateTo(param, () => {
      if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
        this.setCardTranslateXYInRecent(index, distanceX, distanceY);
      } else {
        this.setCardTranslateXInRecent(index, distanceX);
      }
    })
  }

  public cancel(): void {
    let container = recentRuntimeInstance.notRemovingSessionList[this.removingIndex];
    this.containerUnsinking(container);
    this.restoreContainerCenter(container);
    this.onRecentGestureFinish();
    log.showInfo(`cancel ${container?.containerId}`);
  }

  public createRestoreMoveUpAnimation() {
    animateExNew('restoreMoveUpAnimation',
      {
        curve: Curve.Friction,
        duration: 200,
      },
      /* event = */(...args: AnimateExArgsType[]) => {
        let sceneContainerSession = args[0] as SCBSceneContainerSession;
        sceneContainerSession.needRenderRotate.setAngle(0);
        sceneContainerSession.needRenderBlurRadius.reset();
        // 下拉卡片位置还原
        sceneContainerSession.needRenderPos.setPosY(0);
        sceneContainerSession.needRenderTitleViewAlpha.setTitleViewAlpha(1.0);
        if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
          this.setCardTranslateXYInRecent(this.removingIndex, 0, 0);
        } else {
          this.setCardTranslateXInRecent(this.removingIndex, 0);
        }
        sceneContainerSession?.needRenderZIndex.setZIndex(1);
      },
      /* onFinish = */(...args: AnimateExArgsType[]) => {
        this.onRecentGestureFinish();
      });
    animateExAddOnFinish('restoreMoveUpAnimation',
      /* event = */(...args: AnimateExArgsType[]) => {
        let sceneContainerSession = args[0] as SCBSceneContainerSession;
        sceneContainerSession?.needRenderRotate.setCenterX('50%');
        sceneContainerSession?.needRenderRotate.setCenterY('50%');
      }, false);
  }

  private checkRemovingIndexByContainerId(containerId : number): number {
    let index = recentRuntimeInstance.notRemovingSessionList.findIndexByContainerId(containerId);
    if (this.removingIndex !== index) {
      log.info(`removingIndex change from ${this.removingIndex} to ${index}`)
      this.removingIndex = index;
    }
    return index;
  }

  public restoreMoveUpAnimate(containerId: number): void {
    let index = this.checkRemovingIndexByContainerId(containerId);
    if (index === -1) {
      log.info(`restoreMoveUpAnimate get invalid containerId ${containerId}`)
      return;
    }
    let sceneContainerSession = recentRuntimeInstance.notRemovingSessionList[this.removingIndex];
    if (!sceneContainerSession) {
      log.showInfo(`sceneContainerSession is null!`);
      return;
    }
    animateExStart('restoreMoveUpAnimation', sceneContainerSession);
  }

  private setCardTranslateXYDelete(index: number, translateX: number, translateY: number): void {
    if (recentRuntimeInstance.notRemovingSessionList[index]?.isFloat) {
      for (let i: number = index + 1; i < index + this.actualAnimationColumnLength; i++) {
        recentRuntimeInstance.notRemovingSessionList[i]?.needRenderTranslate.setTranslateX(-translateX);
      }
    } else {
      // 遍历被删小卡片左边所有小卡片，做交叉动效
      for (let i = recentRuntimeInstance.leftBoundaryIndex; i < index; i++) {
        let container = recentRuntimeInstance.notRemovingSessionList[i];
        if (container && (this.multiCardsNum - i) % 2 == 0) {
          container.needRenderTranslate.setTranslateX(-translateX);
          container.needRenderTranslate.setTranslateY(this.translationDownY + translateY);
        } else {
          container.needRenderTranslate.setTranslateX(0);
          container.needRenderTranslate.setTranslateY(this.translationUpY - translateY);
        }
      }
      // 遍历被删小卡片右边做平移动效的卡片
      for (let i = index + 1; i < this.multiAnimationLength; i++) {
        recentRuntimeInstance.notRemovingSessionList[i]?.needRenderTranslate.setTranslateX(-translateX);
      }
      // 遍历被删小卡片右边做平移动效的悬浮窗卡片
      for (let i = this.multiColumnNum; i < this.totalColumnNum; i++) {
        recentRuntimeInstance.notRemovingSessionList[i]?.needRenderTranslate.setTranslateX(-translateX);
      }
    }
  }

  /**
   * 恢复双行下滑相邻卡片的位置
   */
  private resetGatherCardTranslate(): void {
    let leftIndex = this.removingIndex - 2;
    let rightIndex = this.removingIndex + 2;
    if (leftIndex >= 0) {
      recentRuntimeInstance.notRemovingSessionList[leftIndex].needRenderTranslate.setTranslateX(0);
    }
    if (rightIndex < recentRuntimeInstance.notRemovingSessionList.length) {
      recentRuntimeInstance.notRemovingSessionList[rightIndex].needRenderTranslate.setTranslateX(0);
    }
  }

  private resetCardTranslateXY(index: number, centerColumn: number, translateX: number, translateY: number): void {
    let maxAnimationLength = 6;
    let animationSceneSessionListCount = 0;
    this.resetGatherCardTranslate();
    if (recentRuntimeInstance.notRemovingSessionList[index]?.isFloat) {
      maxAnimationLength = this.cardsMoveWithDeleteFloating(centerColumn);
      for (let formerIndex: number = index - 1; formerIndex >= 0; formerIndex--) {
        animationSceneSessionListCount++;
        if (animationSceneSessionListCount > maxAnimationLength) {
          break;
        }
        recentRuntimeInstance.notRemovingSessionList[formerIndex].needRenderTranslate.setTranslateX(translateX);
      }
    } else {
      maxAnimationLength = this.actualAnimationLength;
      for (let formerIndex = index - 1; formerIndex >= 0; formerIndex--) {
        animationSceneSessionListCount++;
        if (animationSceneSessionListCount > maxAnimationLength) {
          break;
        }
        if ((this.multiCardsNum - formerIndex) % 2 === 0) {
          let newTranslateY = this.translationDownY + translateY;
          recentRuntimeInstance.notRemovingSessionList[formerIndex].needRenderTranslate.setTranslateX(0);
          recentRuntimeInstance.notRemovingSessionList[formerIndex].needRenderTranslate.setTranslateY(newTranslateY);
        } else {
          let newTranslateY = this.translationUpY - translateY;
          recentRuntimeInstance.notRemovingSessionList[formerIndex].needRenderTranslate.setTranslateX(translateX);
          recentRuntimeInstance.notRemovingSessionList[formerIndex].needRenderTranslate.setTranslateY(newTranslateY);
        }
      }
    }
  }

  private setCardTranslateXYInRecent(index: number, translateX: number, translateY: number) {
    let centerColumn = recentRuntimeInstance.autoCenterColumn;
    if (this.isRightContainerFill) {
      this.setCardTranslateXYDelete(index, translateX, translateY);
    } else {
      // 上划删除一张卡片反悔的情况
      this.resetCardTranslateXY(index, centerColumn, translateX, translateY);
    }
  }

  private cardsMoveWithDeleteFloating(currColumn: number): number {
    let maxAnimCards = 0;
    let floatingLeft = this.deleteColumnIndex - this.multiColumnNum;
    floatingLeft = floatingLeft > 0 ? floatingLeft : 0;
    if (this.deleteColumnIndex < currColumn) {
      maxAnimCards = 0;
    } else if (this.deleteColumnIndex === currColumn) {
      maxAnimCards = 2;
      maxAnimCards -= Math.min(floatingLeft, 1);
    } else if (this.deleteColumnIndex === currColumn + 1) {
      maxAnimCards = 4;
      maxAnimCards -= Math.min(floatingLeft, 2);
    } else {
      maxAnimCards = 6;
      maxAnimCards -= Math.min(floatingLeft, 3);
    }
    log.showInfo(`cardsMoveWithHand maxAnimCards = ${maxAnimCards}`);
    return maxAnimCards;
  }

  private setCardTranslateXInRecent(curIndex: number, offsetX: number) {
    let leftIndex = curIndex - 1;
    let rightIndex = curIndex + 1

    let targetIndex = leftIndex;
    if (targetIndex < 0) {
      targetIndex = rightIndex;
      if (targetIndex >= recentRuntimeInstance.notRemovingSessionList.length) {
        return;
      }
      // right card move to left
      recentRuntimeInstance.notRemovingSessionList[targetIndex].needRenderTranslate
        .setTranslateX(-offsetX + this.rightCardTranslateX);
      return;
    }
    // left card move to right
    recentRuntimeInstance.notRemovingSessionList[targetIndex]?.needRenderTranslate
      .setTranslateX(offsetX + this.leftCardTranslateX);
    if (offsetX === 0) {
      recentRuntimeInstance.notRemovingSessionList[rightIndex]?.needRenderTranslate
        .setTranslateX(this.rightCardTranslateX);
    }
  }

  private playRotateAnimation(offsetY: number): void {
    let sceneContainerSession = recentRuntimeInstance.notRemovingSessionList[this.removingIndex];
    if (!sceneContainerSession) {
      log.info(`sceneContainerSession is null!`);
      return;
    }
    let unclearAble = false;
    if (sceneContainerSession.primarySession?.sceneInfo) {
      unclearAble = sceneContainerSession.primarySession?.isUnclearable() ||
        !!sceneContainerSession.secondarySession?.isUnclearable();
    }
    let param: AnimateParam = {
      curve: curves.responsiveSpringMotion()
    };
    if (!this.isNewStyle) {
      param.duration = 300;
      param.curve = Curve.Linear;
    }
    animateTo(param, () => {
      let angle = this.getRotateByOffset(offsetY, unclearAble);
      sceneContainerSession.needRenderRotate.setAngle(angle);
      let titleOpacity = this.getTitleOpacity(angle);
      sceneContainerSession.needRenderTitleViewAlpha.setTitleViewAlpha(titleOpacity);
      let blurRadius = this.getForegroundBlurRadius(sceneContainerSession.needRenderRotate.angle);
      RecentForegroundBlurAniMgr.getInstance().startForegroundBlurAnimation(sceneContainerSession, blurRadius, false);
    });
  }

  private getForegroundBlurRadius(angle: number): number {
    if (angle >= RecentsStyleConstants.MIN_DEL_ANI_ANGLE) {
      return -1;
    }
    if (angle <= RecentsStyleConstants.MAX_DEL_ANI_ANGLE) {
      return RecentsStyleConstants.FOREGROUND_BLUR_RADIUS;
    }
    // 20-85度之间线性模糊
    return (angle - RecentsStyleConstants.MIN_DEL_ANI_ANGLE) /
      (RecentsStyleConstants.MAX_DEL_ANI_ANGLE - RecentsStyleConstants.MIN_DEL_ANI_ANGLE) *
      RecentsStyleConstants.FOREGROUND_BLUR_RADIUS;
  }

  private getRotateByOffset(offsetY: number, unclearAble: boolean): number {
    // follow handle 3.8vp/degree
    let rotate = offsetY / 6;
    if (unclearAble) {
      // 不可删除卡片，上滑增加阻尼系数0.15
      rotate = Math.max(0.15 * rotate, -20);
    }
    rotate = -Math.abs(rotate) < -85 ? -85 : -Math.abs(rotate);
    return rotate;
  }

  private getTitleOpacity(rotateAngle: number): number {
    if (rotateAngle <= -30) {
      return 0;
    }
    if (rotateAngle >= 0) {
      return 1;
    }
    return 1 - (rotateAngle / -30);
  }

  public getSceneSessionScreenIndex(containerId: number): number {
    let centerIndex = recentRuntimeInstance.autoCenterColumn;
    let leftMissionId = recentRuntimeInstance.notRemovingSessionList[centerIndex - 1]?.containerId;
    let rightMissionId = recentRuntimeInstance.notRemovingSessionList[centerIndex + 1]?.containerId;
    let middleMissionId = recentRuntimeInstance.notRemovingSessionList[centerIndex]?.containerId;

    if (containerId === middleMissionId) {
      return SCBSessionShowInScreenIndex.INDEX_MIDDLE;
    } else if (containerId === leftMissionId) {
      return SCBSessionShowInScreenIndex.INDEX_LEFT;
    } else if (containerId === rightMissionId) {
      return SCBSessionShowInScreenIndex.INDEX_RIGHT;
    }
    return SCBSessionShowInScreenIndex.INDEX_NONE;
  }

  private onRecentGestureBeginInitParam(containerId: number): void {
    animateExBreak('restoreMoveUpAnimation', 'onRecentGestureBeginInitParam');
    this.removingIndex = recentRuntimeInstance.notRemovingSessionList.findIndex((item) => {
      return (item.containerId === containerId);
    });
    if (this.removingIndex < recentRuntimeInstance.leftBoundaryIndex) {
      let container = this.panelManager.getSceneContainerSessionList().findByContainerId(containerId);
      let containerForView = this.panelManager.getSceneContainerSessionListForView().findByContainerId(containerId);
      log.showError(`not find ${container?.sessionData.pendingRemove} ${containerForView?.sessionData.pendingRemove}`);
      return;
    }
    this.removingContainerSession = recentRuntimeInstance.notRemovingSessionList[this.removingIndex];
    log.showInfo(`recent gesture will remove container: ${this.removingContainerSession.getName()}, \
    index ${this.removingIndex}`);
  }

  public onRecentGestureBegin(containerId: number, currentOffsetX: number,
    totalList: SCBSceneContainerSessionArray): void {
    this.onRecentGestureBeginInitParam(containerId);
    if (this.removingIndex < 0) {
      log.showInfo(`onRecentGestureActionBegin:${this.removingIndex}`);
      return;
    }
    if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      this.initParamForMultiRow(this.removingIndex, currentOffsetX, totalList);
    }
    this.containerSinking(this.removingIndex);
    this.containerCenter(this.removingIndex);
  }

  public initParamForMultiRow(index: number, currentOffsetX: number, totalList: SCBSceneContainerSessionArray) {
    let curColumn: number = recentRuntimeInstance.autoCenterColumn;
    this.initGestureValue(
      recentRuntimeInstance.notRemovingSessionList.length,
      curColumn, currentOffsetX);
    this.updateGestureValue(totalList);
    this.setContainerFillDirection(curColumn, currentOffsetX, index, totalList[index]?.isFloat);
  }

  public onRecentGestureFinish(): void {
    this.removingIndex = -1;
    this.removingContainerSession = null;
  }

  /**
   * 获取当前卡片左右侧卡片偏移量
   * @param containerId 容器id
   * @param cardInterval 卡片间隔
   */
  public setCardsTranslateX(containerId: number, cardInterval: number): void {
    const removingIndex = recentRuntimeInstance.notRemovingSessionList.findIndexByContainerId(containerId);
    let leftIndex = removingIndex - cardInterval;
    let rightIndex = removingIndex + cardInterval;
    if (leftIndex >= 0) {
      this.leftCardTranslateX =
        recentRuntimeInstance?.notRemovingSessionList[leftIndex]?.needRenderTranslate.translateX;
    }
    if (rightIndex < recentRuntimeInstance.notRemovingSessionList.length) {
      this.rightCardTranslateX =
        recentRuntimeInstance?.notRemovingSessionList[rightIndex]?.needRenderTranslate.translateX;
    }
  }

  /**
   * 重置左右侧卡片偏移量记录值
   */
  public resetCardsTranslateX(): void {
    this.leftCardTranslateX = 0;
    this.rightCardTranslateX = 0;
  }

  /**
   * 卡片靠拢动画
   * @param distance
   * @param index
   */
  private cardGatherAnimate(distance: number, index: number): void {
    animateToImmediately({
      curve: curves.responsiveSpringMotion()
    }, () => {
      recentRuntimeInstance?.notRemovingSessionList[index]?.needRenderTranslate.setTranslateX(distance);
    })
  }

  /**
   * 单行多任务下拉两侧卡片靠拢逻辑
   * @param containerId
   * @param offsetY
   */
  private singleRowSlideAndOtherCardsCloseAnimate(containerId: number, offsetY: number): void {
    let showInScreenIndex: number = this.getSceneSessionScreenIndex(containerId);
    let distance = Math.min(offsetY * RecentsStyleConstants.SLIDE_GATHER_RATE,
      RecentsStyleConstants.MAX_GATHER_DISTANCE);
    switch (showInScreenIndex) {
      case SCBSessionShowInScreenIndex.INDEX_MIDDLE:
        let leftIndex = this.removingIndex - 1;
        let rightIndex = this.removingIndex + 1;
        if (leftIndex >= 0) {
          this.cardGatherAnimate(distance + this.leftCardTranslateX, leftIndex);
        }
        if (rightIndex < recentRuntimeInstance.notRemovingSessionList.length) {
          this.cardGatherAnimate(-1 * distance + this.rightCardTranslateX, rightIndex);
        }
        break;
      case SCBSessionShowInScreenIndex.INDEX_LEFT:
        rightIndex = this.removingIndex + 1;
        if (rightIndex < recentRuntimeInstance.notRemovingSessionList.length) {
          this.cardGatherAnimate(-1 * distance + this.rightCardTranslateX, rightIndex);
        }
        break;
      case SCBSessionShowInScreenIndex.INDEX_RIGHT:
        leftIndex = this.removingIndex - 1;
        if (leftIndex >= 0) {
          this.cardGatherAnimate(distance + this.leftCardTranslateX, leftIndex);
        }
        break;
      default:
    }
  }

  /**
   * 双行多任务下拉两侧卡片靠拢逻辑
   * @param offsetY
   */
  private multiRowSlideAndOtherCardsCloseAnimate(offsetY: number): void {
    let distance = Math.min(offsetY * RecentsStyleConstants.SLIDE_GATHER_RATE,
      RecentsStyleConstants.MAX_GATHER_DISTANCE);
    let leftIndex = this.removingIndex - 2;
    let rightIndex = this.removingIndex + 2;
    if (leftIndex >= 0) {
      this.cardGatherAnimate(distance + this.leftCardTranslateX, leftIndex);
    }
    if (rightIndex < recentRuntimeInstance.notRemovingSessionList.length) {
      this.cardGatherAnimate(-1 * distance + this.rightCardTranslateX, rightIndex);
    }
  }

  /**
   * 下滑卡片跟手动画
   * @param offsetY
   */
  private slideCardFollowingAnimate(offsetY: number): void {
    let sceneContainerSession = recentRuntimeInstance.notRemovingSessionList[this.removingIndex];
    if (!sceneContainerSession) {
      log.info(`sceneContainerSession is null!`);
      return;
    }
    let param: AnimateParam = {
      curve: curves.responsiveSpringMotion()
    };
    animateTo(param, () => {
      let maxSlideDistance = recentLayoutConfigInstance.isNeedMultiRowLayout() ?
        RecentsStyleConstants.MULTI_ROW_MAX_SLIDE_DISTANCE : RecentsStyleConstants.SINGLE_ROW_MAX_SLIDE_DISTANCE;
      let distance = Math.min(offsetY * RecentsStyleConstants.SLIDE_FOLLOWING_RATE, maxSlideDistance);
      sceneContainerSession.needRenderPos.setPosYWithDfx(distance, TAG, 'slideLockAction');
    });
  }

  public onRecentGestureUpdate(containerId: number, event: GestureEvent): void {
    let index = this.checkRemovingIndexByContainerId(containerId);
    if (index === -1) {
      log.info(`onRecentGestureUpdate get invalid containerId ${containerId}`)
      return;
    }
    // 下滑操作处理
    if (event.offsetY > 0) {
      this.slideCardFollowingAnimate(event.offsetY);
      if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
        this.multiRowSlideAndOtherCardsCloseAnimate(event.offsetY);
      } else {
        this.singleRowSlideAndOtherCardsCloseAnimate(containerId, event.offsetY);
      }
      return;
    }
    this.playRotateAnimation(event.offsetY);
    // 单行多任务，左右卡片补位运动
    let isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
    if (!isNeedChangeToMultiRow) {
      let showInScreenIndex: number = this.getSceneSessionScreenIndex(containerId);
      if (showInScreenIndex === SCBSessionShowInScreenIndex.INDEX_MIDDLE) {
        this.playTranslateAnimationForNeighborCards(this.removingIndex);
      }
    }
  }

  private containerSinkingSingleRow(sessionIdx: number): void {
    recentRuntimeInstance.notRemovingSessionList[sessionIdx]?.needRenderZIndex.setZIndex(0);
  }

  private containerUnsinkingSingleRow(container: SCBSceneContainerSession): void {
    container?.needRenderZIndex.setZIndex(1);
  }

  private containerSinkingMultiRow(sessionIdx: number): void {
    for (let i = 0; i < recentRuntimeInstance.notRemovingSessionList.length; i++) {
      let container = recentRuntimeInstance.notRemovingSessionList[i];
      if (container && container.needRenderShowInRecent.showInRecent) {
        let newZIndex = recentRuntimeInstance.notRemovingSessionList.length - i - 1;
        container.needRenderZIndex.setZIndex(newZIndex);
      }
    }
  }

  private containerUnsinkingMultiRow(): void {
    for (let i = 0; i < recentRuntimeInstance.notRemovingSessionList.length; i++) {
      let container = recentRuntimeInstance.notRemovingSessionList[i];
      if (container && container.needRenderShowInRecent.showInRecent) {
        container.needRenderZIndex.resetZIndex();
      }
    }
  }

  public containerUnsinking(container: SCBSceneContainerSession): void {
    let isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
    if (isNeedChangeToMultiRow) {
      this.containerUnsinkingMultiRow();
    } else {
      this.containerUnsinkingSingleRow(container);
    }
  }

  public containerSinking(index: number): void {
    let isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
    if (isNeedChangeToMultiRow) {
      this.containerSinkingMultiRow(index);
    } else {
      this.containerSinkingSingleRow(index);
    }
  }

  public containerCenter(index: number): void {
    let containerSession = recentRuntimeInstance.notRemovingSessionList[index];
    let isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
    if (isNeedChangeToMultiRow) {
      let center = this.calculateCenterXYForMultiRow(index);
      containerSession.needRenderRotate.setCenterX('50%');
      containerSession.needRenderRotate.setCenterY(center[1]);
    } else {
      let centerX = this.calculateCenterX(index);
      containerSession.needRenderRotate.setCenterX(centerX);
      containerSession.needRenderRotate.setCenterY('50%');
    }
  }

  public restoreContainerCenter(containerSession: SCBSceneContainerSession): void {
    containerSession?.needRenderRotate.setCenterX('50%');
    containerSession?.needRenderRotate.setCenterY('50%');
  }

  private calculateCenterXYForMultiRow(index: number): number[] {
    let sceneContainerSession = recentRuntimeInstance.notRemovingSessionList[index];
    let screenWidth = px2vp(this.panelManager.getScreenProperty().width);
    let screenHeight = px2vp(this.panelManager.getScreenProperty().height);

    let colIndex: number = 0;
    let center: number[] = [0, 0];
    let containerListLen = this.panelManager.getSceneContainerSessionList().length;
    if (sceneContainerSession.isFloat) {
      center[1] = screenHeight / 2;
      colIndex = this.deleteColumnIndex;
    } else {
      center[0] = screenWidth / 2;
      colIndex = Math.floor((containerListLen + 1) / 2) - 1 - (Math.floor((containerListLen - 1 - index) / 2));
      let rowIndex: number = (containerListLen - 1 - index) % 2;
      if (rowIndex === 0) {
        center[1] = screenHeight * 3 / 4;
      } else {
        center[1] = screenHeight / 4;
      }
    }
    let screenColumnIndex: number[] = this.getScreenColumnIndexInRecentMultiRow();
    let leftColumnIndex: number = screenColumnIndex[0];
    let midColumnIndex: number = screenColumnIndex[1];

    if (colIndex === leftColumnIndex) {
      center[0] = screenWidth / 2 + screenWidth;
    } else if (colIndex === midColumnIndex) {
      center[0] = screenWidth / 2;
    } else {
      center[0] = screenWidth / 2 - screenWidth;
    }
    return center;
  }

  public getScreenColumnIndexInRecentMultiRow(): number[] {
    let multiColumnNum: number = Math.floor((this.panelManager.getSceneContainerSessionListForView().length + 1) / 2);
    let curColumnIndex = recentRuntimeInstance.autoCenterColumn;
    let rightColumnIndex: number = curColumnIndex + 1;
    let leftColumnIndex: number = curColumnIndex - 1;
    let midColumnIndex: number = curColumnIndex;
    if (multiColumnNum === 1 && this.panelManager.getFloatingSessionListForView().length === 0) {
      midColumnIndex = -1;
      rightColumnIndex = midColumnIndex + 1;
      leftColumnIndex = midColumnIndex - 1;
    }
    let screenColumnIndex = [leftColumnIndex, midColumnIndex, rightColumnIndex];
    return screenColumnIndex;
  }

  public calculateCenterX(index: number): number {
    let centerX: number = 0;
    let sceneContainerSession = recentRuntimeInstance.notRemovingSessionList[index];
    let screenWidth = px2vp(this.panelManager.getScreenProperty().width);
    let halfScreenWidth = screenWidth / 2;
    let showInScreenIndex = this.getSceneSessionScreenIndex(sceneContainerSession.containerId);
    let recentScale = RecentLayoutManager.getScale(this.panelManager.getScreenProperty());
    let recentMargin = RecentLayoutManager.getWidthSpace();
    if (recentRuntimeInstance.notRemovingSessionList.length === 1 ||
      showInScreenIndex === SCBSessionShowInScreenIndex.INDEX_MIDDLE) {
      // middle card
      centerX = halfScreenWidth;
    } else if (showInScreenIndex === SCBSessionShowInScreenIndex.INDEX_LEFT) {
      // left card
      if (this.isNeedNegativeCenterX(sceneContainerSession)) {
        centerX = halfScreenWidth - 2 * (screenWidth * recentScale + recentMargin);
      } else {
        centerX = halfScreenWidth + 2 * (screenWidth * recentScale + recentMargin);
      }
    } else if (showInScreenIndex === SCBSessionShowInScreenIndex.INDEX_RIGHT) {
      // right card
      if (this.isNeedNegativeCenterX(sceneContainerSession)) {
        centerX = halfScreenWidth + 2 * (screenWidth * recentScale + recentMargin);
      } else {
        centerX = halfScreenWidth - 2 * (screenWidth * recentScale + recentMargin);
      }
    }
    return centerX;
  }

  private isNeedNegativeCenterX(sceneContainerSession: SCBSceneContainerSession): boolean {
    if (!sceneContainerSession) {
      return false;
    }
    if (this.panelManager.getScreenProperty().rotation === RotationConstants.ROTATION_90) {
      return sceneContainerSession.currentRotation === RotationConstants.ROTATION_0;
    } else if (this.panelManager.getScreenProperty().rotation === RotationConstants.ROTATION_0) {
      return sceneContainerSession.currentRotation === RotationConstants.ROTATION_270;
    }
    return false;
  }

  public playTitleAppearAnimation(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      log.showError('[TitleAppear]sceneSession or sceneInfo is null, just retrun');
      return;
    }
    containerSession.needRenderShowRecentTitle.setShowRecentTitle(true);
    let param: AnimateParam = {
      curve: curves.springMotion(0.28, 1, 0)
    };
    if (!this.isNewStyle) {
      param.curve = Curve.Linear;
      param.duration = 150;
    }
    animateTo(param, () => {
      containerSession.needRenderTitleViewAlpha.setTitleViewAlpha(1.0);
    })
  }

  private isVertical(rotation: number): boolean {
    // should return 90 270 in pc
    return rotation === RotationConstants.ROTATION_0 ||
      rotation === RotationConstants.ROTATION_180 ||
      rotation === RotationConstants.ROTATION_360;
  }


  /**
   * 补位过来的卡片设置translateX
   *
   * @param { number } deleteIdx 补位卡片的index
   * @returns { void }
   */
  public playAnimationForFillingContainers(): void {
    performanceMonitor.begin(HiSysEventUtil.RECENT_REALIGN_ANI, performanceMonitor.ActionType.FIRST_MOVE);
    let param: AnimateParam = {
      duration: 200,
      curve: !this.isVertical(this.panelManager.getScreenProperty().rotation) ? Curve.Linear :
      curves.interpolatingSpring(0, 1, 171, 22),
      onFinish: () => {
        RecentAccessibilityUtils.requestFocusForSession(recentRuntimeInstance.autoCenterContainerSession, false);
        performanceMonitor.end(HiSysEventUtil.RECENT_REALIGN_ANI);
      }
    };
    if (!this.isNewStyle) {
      param.duration = 300;
      param.curve = Curve.Linear;
    }
    animateTo(param, () => {
      let isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
      if (!isNeedChangeToMultiRow) {
        this.playTrailingAnimationSingleRow();
      } else {
        this.playTrailingAnimationMultiRow();
      }
    });
  }

  /**
   * 双行刷新补卡片的 translateX，包含滑动中删除卡片场景；leftIndex rightIndex 当前删除卡片之后，屏幕内卡片的左边卡片和右边卡片的列下标，
   * 如果滑动中删除屏幕中央左边界的列，需要 rightIndex + 1设置补位过来的列的translateX
   *
   * @param { number } deleteIdx - 被删除卡片的index.
   * @returns { void }
   */
  private playTrailingAnimationMultiRow(): void {
    let containerShowListLen = recentRuntimeInstance.containerCountsShowInRecent - 1;
    let centerColumn = recentRuntimeInstance.autoCenterColumn;
    let leftIndex = Math.max((centerColumn - 2) * 2 - containerShowListLen % 2 -
      recentRuntimeInstance.leftBoundaryIndex % 2, recentRuntimeInstance.leftBoundaryIndex);
    let rightIndex = Math.min((centerColumn + 2) * 2 + (containerShowListLen + 1) % 2 -
      recentRuntimeInstance.leftBoundaryIndex % 2,
      recentRuntimeInstance.rightBoundaryIndex);
    let len = recentRuntimeInstance.notRemovingSessionList.length;
    for (let i = leftIndex; i <= rightIndex + 1 && i < len; i++) {
      let containerSession = recentRuntimeInstance.notRemovingSessionList[i];
      if (!containerSession) {
        continue;
      }
      containerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'playAnimationForFillingContainers',
        containerSession.getName());
    }
  }

  /**
   * 单行刷新补卡片的 translateX，包含滑动中删除卡片场景；leftIndex rightIndex 当前删除卡片之后，屏幕内卡片的左边卡片和右边卡片的下标，
   * 如果滑动中删除屏幕中央左边界的列，需要 centerIndex + 2设置补位过来的列的translateX
   *
   * @param { number } deleteIdx - 被删除卡片的index.
   * @returns { void }
   */
  private playTrailingAnimationSingleRow(): void {
    let centerIndex = recentRuntimeInstance.autoCenterColumn;
    let leftIndex = Math.max(recentRuntimeInstance.leftBoundaryIndex, centerIndex - 1);
    let rightIndex = Math.min(centerIndex + 2, recentRuntimeInstance.rightBoundaryIndex);
    for (let i = leftIndex; i <= rightIndex; i++) {
      let containerSession = recentRuntimeInstance.notRemovingSessionList[i];
      if (!containerSession) {
        continue;
      }
      containerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'playAnimationForFillingContainers',
        containerSession.getName());
    }
  }

  public buildFillingContainers(containers: SCBSceneContainerSessionArray): void {
    if (!containers) {
      return;
    }
    let recentScale = RecentLayoutManager.getScale(this.panelManager.getScreenProperty());
    let borderRadius = CommonConstants.getDeviceRadius();
    let config = new ContainerBuilderConfig()
      .setVisibility(true)
      .setAlpha(1.0)
      .setScale({ x: recentScale, y: recentScale })
      .setBorderRadius(borderRadius);
    containers?.forEach((containerSession) => {
      ContainerBuilder.tryBuildContainer(containerSession, config);
    });
  }

  public deleteSingleRowContainerFromRecent(isNotRemovingSessionList: SCBSceneContainerSession[],
    index: number,
    showInScreenIndex: number,
    curOffsetX: number,
    fillingContainers: SCBSceneContainerSessionArray): number {
    let newOffsetX: number = 0;
    if (!isNotRemovingSessionList || !fillingContainers) {
      return newOffsetX;
    }
    if (showInScreenIndex === SCBSessionShowInScreenIndex.INDEX_MIDDLE) {
      if (index === recentRuntimeInstance.leftBoundaryIndex) {
        this.otherContainerRightFilling(index, 2, isNotRemovingSessionList, fillingContainers);
      } else {
        this.otherContainerLeftFilling(index, 2, isNotRemovingSessionList, fillingContainers);
      }
    } else if (showInScreenIndex === SCBSessionShowInScreenIndex.INDEX_RIGHT) {
      this.otherContainerRightFilling(index, 1, isNotRemovingSessionList, fillingContainers);
    } else if (showInScreenIndex === SCBSessionShowInScreenIndex.INDEX_LEFT) {
      this.otherContainerLeftFilling(index, 1, isNotRemovingSessionList, fillingContainers);
    } else {
      // 屏幕外的卡片只做posX变动，不做补位动效
      this.otherContainerNoneFilling(index, isNotRemovingSessionList);
    }
    if (isNotRemovingSessionList[recentRuntimeInstance.autoCenterColumn]) {
      newOffsetX = isNotRemovingSessionList[recentRuntimeInstance.autoCenterColumn].needRenderPos.posX;
    }
    return newOffsetX;
  }

  public deleteMultiRowContainerFromRecentIsRightFill(isNotRemovingSessionList: SCBSceneContainerSession[],
    index: number, curOffsetX: number, correctScreenOffsetX: number,
    fillingContainers: SCBSceneContainerSessionArray): number {
    let newOffsetX = correctScreenOffsetX;
    if (!isNotRemovingSessionList || !fillingContainers) {
      return newOffsetX;
    }
    let containerListLen = isNotRemovingSessionList.length;
    if (recentRuntimeInstance.rightBoundaryIndex - recentRuntimeInstance.leftBoundaryIndex <= 4) {
      newOffsetX = 0;
    }
    newOffsetX = Math.max(newOffsetX, 0);
    let crossAnimationSceneSession =
      this.updateMultiRowContainerRightFill(isNotRemovingSessionList, index, curOffsetX, fillingContainers, newOffsetX);
    this.otherContainerAnimationWhenDeleteFromRecentMultiRow(
      crossAnimationSceneSession, containerListLen - recentRuntimeInstance.leftBoundaryIndex - 1,
      index - recentRuntimeInstance.leftBoundaryIndex);
    return newOffsetX;
  }

  public deleteMultiRowContainerFromRecentNotRightFill(isNotRemovingSessionList: SCBSceneContainerSession[],
    index: number, curOffsetX: number, fillingContainers: SCBSceneContainerSessionArray): number {
    let screenProperty = this.panelManager.getScreenProperty();
    let containerListLen = isNotRemovingSessionList.length;
    let newOffsetX = 0;
    if (!fillingContainers) {
      return newOffsetX;
    }
    // 计算newOffsetX值
    if ((containerListLen - recentRuntimeInstance.leftBoundaryIndex) % 2 == 1 &&
      (containerListLen - recentRuntimeInstance.leftBoundaryIndex) > 3) {
      newOffsetX = curOffsetX - RecentLayoutManager.getWidthAndSpace(screenProperty);
    } else {
      newOffsetX = curOffsetX;
    }
    newOffsetX = Math.max(newOffsetX, 0);
    this.updateMultiRowContainerNotRightFill(isNotRemovingSessionList, index, curOffsetX, fillingContainers,
      newOffsetX);
    fillingContainers.reverse();
    this.otherContainerAnimationWhenDeleteFromRecentMultiRow(
      fillingContainers, containerListLen - recentRuntimeInstance.leftBoundaryIndex - 1,
      index - recentRuntimeInstance.leftBoundaryIndex);
    return newOffsetX;
  }

  private updateMultiRowContainerRightFill(isNotRemovingSessionList: SCBSceneContainerSession[], index: number,
    curOffsetX: number, fillingContainers: SCBSceneContainerSessionArray,
    newOffsetX: number): SCBSceneContainerSessionArray {
    let crossAnimationSceneSession: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    // 遍历被删小卡片左边所有小卡片，做交叉动效
    for (let i: number = recentRuntimeInstance.leftBoundaryIndex; i < index; i++) {
      let containerSession: SCBSceneContainerSession = isNotRemovingSessionList[i];
      let originalPosX: number = containerSession.needRenderPos.posX;
      let targetPosX: number = this.getPositionXIsDeleting(i);
      animateTo({ duration: 0 }, () => {
        containerSession.needRenderPos.setPosXWithDfx(targetPosX, TAG,
          'deleteSceneContainerFromRecentWithAnimation', containerSession.getName());
        containerSession.needRenderTranslate.setTranslateXWithDfx(
          originalPosX - targetPosX - (curOffsetX - newOffsetX), TAG,
          'deleteSceneContainerFromRecentWithAnimation', containerSession.getName());
      })
      crossAnimationSceneSession.push(containerSession);
    }
    let leftIndex = recentRuntimeInstance.rightBoundaryIndex -
    recentRuntimeInstance.leftBoundaryIndex <= 4 ? index + 1 : index;
    // 遍历被删小卡片右边做平移动效的小卡片
    for (let i: number = leftIndex; i <= recentRuntimeInstance.rightBoundaryIndex; i++) {
      let containerSession: SCBSceneContainerSession = isNotRemovingSessionList[i];
      let originalPosX: number = containerSession.needRenderPos.posX;
      let targetPosX: number = this.getPositionXIsDeleting(i - 1);
      animateTo({ duration: 0 }, () => {
        containerSession.needRenderPos.setPosXWithDfx(targetPosX, TAG,
          'deleteSceneContainerFromRecentWithAnimation', containerSession.getName());
        containerSession.needRenderTranslate.setTranslateXWithDfx(
          originalPosX - targetPosX - (curOffsetX - newOffsetX), TAG,
          'deleteSceneContainerFromRecentWithAnimation', containerSession.getName()); // 这个要改
      })
      fillingContainers.push(containerSession);
    }
    // 处理三列转为两列的position变化的特殊情况
    this.updateMultiRowContainerToTwoColumn(isNotRemovingSessionList, index, curOffsetX, newOffsetX);
    return crossAnimationSceneSession;
  }

  private updateMultiRowContainerToTwoColumn(isNotRemovingSessionList: SCBSceneContainerSession[],
    index: number,
    curOffsetX: number,
    newOffsetX: number): void {
    // 处理三列转为两列的position变化的特殊情况
    if (recentRuntimeInstance.rightBoundaryIndex - recentRuntimeInstance.leftBoundaryIndex === 4 &&
      curOffsetX !== 0) {
      let containerSession: SCBSceneContainerSession = isNotRemovingSessionList[index];
      if (containerSession) {
        let originalPosX: number = containerSession.needRenderPos.posX;
        animateTo({ duration: 0 }, () => {
          containerSession.needRenderPos.setPosXWithDfx(originalPosX - curOffsetX, TAG,
            'deleteSceneContainerFromRecentWithAnimation', containerSession.getName());
          containerSession.needRenderTranslate.setTranslateXWithDfx(newOffsetX, TAG,
            'deleteSceneContainerFromRecentWithAnimation', containerSession.getName()); // 这个要改
        })
      }
    }
  }

  private updateMultiRowContainerNotRightFill(isNotRemovingSessionList: SCBSceneContainerSession[], index: number,
    curOffsetX: number, fillingContainers: SCBSceneContainerSessionArray, newOffsetX: number): void {
    let containerListLen = isNotRemovingSessionList.length;
    // 从删除的当前张往后遍历,卡片剩余5张的话，当前删除的卡片不用移动位置
    let leftIndex = recentRuntimeInstance.containerCountsShowInRecent <= 5 ? index + 1 : index;
    for (let i: number = leftIndex; i < containerListLen; i++) {
      let containerSession = isNotRemovingSessionList[i];
      let deletedPosX: number = this.getPositionXIsDeleting(i - 1);
      containerSession.needRenderPos.setPosXWithDfx(deletedPosX, TAG, 'deleteSceneContainerFromRecentWithAnimation',
        containerSession.getName());
    }
    // 从删除的当前张往前遍历（仅要做动效的卡片）
    for (let animIndex: number = index - 1; animIndex >= index - this.actualAnimationLength &&
      animIndex >= recentRuntimeInstance.leftBoundaryIndex; animIndex--) {
      let containerSession = isNotRemovingSessionList[animIndex];
      if (containerSession) {
        let animPosX: number = containerSession.needRenderPos.posX;
        let deletedPosX: number = this.getPositionXIsDeleting(animIndex);
        animateTo({ duration: 0 }, () => {
          containerSession.needRenderPos.setPosXWithDfx(deletedPosX, TAG,
            'deleteSceneContainerFromRecentWithAnimation', containerSession.getName());
          if (isNotRemovingSessionList.length === 3) {
            containerSession.needRenderTranslate.setTranslateXWithDfx(animPosX - deletedPosX, TAG,
              'deleteSceneContainerFromRecentWithAnimation', containerSession.getName());
          } else {
            containerSession.needRenderTranslate.setTranslateXWithDfx(
              animPosX - deletedPosX - (curOffsetX - newOffsetX), TAG,
              'deleteSceneContainerFromRecentWithAnimation', containerSession.getName());
          }
        })
        containerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'otherContainerFilling',
          containerSession.getName());
        fillingContainers.push(containerSession);
      }
    }
    for (let stableIndex = index - this.actualAnimationLength - 1;
      stableIndex >= recentRuntimeInstance.leftBoundaryIndex; stableIndex--) {
      let stableContainerSession = isNotRemovingSessionList[stableIndex];
      if (stableContainerSession) {
        let deletedPosX: number = this.getPositionXIsDeleting(stableIndex);
        stableContainerSession.needRenderPos.setPosXWithDfx(deletedPosX, TAG,
          'deleteSceneContainerFromRecentWithAnimation', stableContainerSession.getName());
        stableContainerSession.needRenderTranslate.setTranslateYWithDfx(((
          isNotRemovingSessionList.length - stableIndex) % 2 === 0) ? this.translationUpY :
        this.translationDownY, TAG,
          'deleteSceneContainerFromRecentWithAnimation', stableContainerSession.getName());
      }
    }
  }

  private otherContainerAnimationWhenDeleteFromRecentMultiRow(animationSceneSessions: SCBSceneContainerSessionArray,
    restArrayLength: number, index: number): void {
    log.showInfo(`restArrayLength: ${restArrayLength}`);
    // animate translateX of modified card
    performanceMonitor.begin(HiSysEventUtil.RECENT_REALIGN_ANI, performanceMonitor.ActionType.FIRST_MOVE);
    let param: AnimateParam = {
      curve: curves.interpolatingSpring(0, 1, 130, 19),
      onFinish: () => {
        performanceMonitor.end(HiSysEventUtil.RECENT_REALIGN_ANI);
      },
      finishCallbackType: FinishCallbackType.LOGICALLY
    };
    if (!this.isNewStyle) {
      param.duration = 300;
      param.curve = Curve.Linear;
    }
    animateTo(param, () => {
      for (let i = animationSceneSessions.length - 1; i >= 0; i--) {
        let containerSession = animationSceneSessions[i];
        log.showInfo(`target index:${i} containerSession.needRenderTranslate.translateX:${containerSession.needRenderTranslate.translateX} containerSession.needRenderPos.posX:${containerSession.needRenderPos.posX}`);
        containerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG,
          'otherContainerAnimationWhenDeleteFromRecentMultiRow', containerSession.getName());
        log.showInfo(`original translateXY: ${containerSession.needRenderTranslate.translateX}, ${containerSession.needRenderTranslate.translateY}`);
        if ((restArrayLength + 1 - (index - animationSceneSessions.length + i)) % 2 === 0) { // 第二行
          containerSession.needRenderTranslate.setTranslateYWithDfx(this.translationUpY, TAG,
            'otherContainerAnimationWhenDeleteFromRecentMultiRow', containerSession.getName());
        } else {
          containerSession.needRenderTranslate.setTranslateYWithDfx(this.translationDownY, TAG,
            'otherContainerAnimationWhenDeleteFromRecentMultiRow', containerSession.getName());
        }
      }
    })
  }

  private otherContainerLeftFilling(deleteIdx: number,
    fillingNum: number,
    sessionList: SCBSceneContainerSession[],
    fillingContainers: SCBSceneContainerSessionArray): void {
    let screenProperty = this.panelManager.getScreenProperty();
    let listLen = sessionList.length;
    let recentCardWidthAndSpace = RecentLayoutManager.getWidthAndSpace(screenProperty);
    let initTranslateY = RecentLayoutManager.getSingleRowInitTranslateY(screenProperty);
    let reason = 'otherContainerFilling';
    for (let i = listLen - 1; i >= deleteIdx; i--) {
      sessionList[i].needRenderPos.setPosXWithDfx(recentRuntimeInstance.getRelativeColumn(i - 1) *
        recentCardWidthAndSpace, TAG, reason, sessionList[i].getName());
    }
    for (let i = deleteIdx - 1; i >= deleteIdx - fillingNum && i >= recentRuntimeInstance.leftBoundaryIndex; i--) {
      let containerSession = sessionList[i];
      let nameForDfx = containerSession.getName();
      containerSession.needRenderPos.setPosXWithDfx(recentRuntimeInstance.getRelativeColumn(i) *
        recentCardWidthAndSpace, TAG, reason, nameForDfx);
      let newTranslateX = containerSession.needRenderTranslate.translateX - recentCardWidthAndSpace;
      containerSession.needRenderTranslate.setTranslateXWithDfx(newTranslateX, TAG, reason, nameForDfx);
      containerSession.needRenderTranslate.setTranslateYWithDfx(initTranslateY, TAG, reason, nameForDfx);
      containerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, reason, nameForDfx);
      fillingContainers.push(containerSession);
    }
  }

  private otherContainerNoneFilling(deleteIdx: number,
    sessionList: SCBSceneContainerSession[]): void {
    let screenProperty = this.panelManager.getScreenProperty();
    let listLen = sessionList.length;
    let recentCardWidthAndSpace = RecentLayoutManager.getWidthAndSpace(screenProperty);
    let reason = 'otherContainerFilling';
    for (let i = listLen - 1; i >= deleteIdx; i--) {
      sessionList[i].needRenderPos.setPosXWithDfx(recentRuntimeInstance.getRelativeColumn(i - 1) *
        recentCardWidthAndSpace, TAG, reason, sessionList[i].getName());
    }
  }

  private otherContainerRightFilling(deleteIdx: number,
    fillingNum: number,
    sessionList: SCBSceneContainerSession[],
    fillingContainers: SCBSceneContainerSessionArray): void {
    let screenProperty = this.panelManager.getScreenProperty();
    let listLen = sessionList.length;
    let recentCardWidthAndSpace = RecentLayoutManager.getWidthAndSpace(screenProperty);
    let initTranslateY = RecentLayoutManager.getSingleRowInitTranslateY(screenProperty);
    let reason = 'otherContainerFilling';
    for (let i = deleteIdx + 1; i < listLen; i++) {
      let containerSession = sessionList[i];
      let nameForDfx = containerSession.getName();
      containerSession.needRenderPos.setPosXWithDfx(recentRuntimeInstance.getRelativeColumn(i - 1) *
        recentCardWidthAndSpace, TAG, reason, nameForDfx);
      if (i <= deleteIdx + fillingNum) {
        let newTranslateX = containerSession.needRenderTranslate.translateX + recentCardWidthAndSpace;
        containerSession.needRenderTranslate.setTranslateXWithDfx(newTranslateX, TAG, reason, nameForDfx);
        containerSession.needRenderTranslate.setTranslateYWithDfx(initTranslateY, TAG, reason, nameForDfx);
        containerSession.needRenderVisibility.setVisibilityWithDfx(true, TAG, reason, nameForDfx);
        containerSession.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'deleteScene');
        fillingContainers.push(containerSession);
      }
    }
  }

  private getPositionXIsDeleting(index: number): number {
    let screenProperty = this.panelManager.getScreenProperty();
    let widthSpace = RecentLayoutManager.getWidthSpace();
    let taskWidth = RecentLayoutManager.getCardWidth(screenProperty) + widthSpace;
    let multiRowPadding = RecentLayoutManager.getMultiRowPadding(screenProperty);
    let columnIndex =
      Math.max(this.getMultiRowColumnInDeleting(index - recentRuntimeInstance.leftBoundaryIndex), 0);
    let relativeRightColumn = this.getMultiRowColumnInDeleting(
      recentRuntimeInstance.rightBoundaryIndex - recentRuntimeInstance.leftBoundaryIndex - 1);
    if (relativeRightColumn === 0 || relativeRightColumn === 1) {
      return (columnIndex + 1 - relativeRightColumn) * taskWidth - (widthSpace - multiRowPadding) + 1;
    }
    return (columnIndex - 1) * taskWidth - multiRowPadding + widthSpace + 2;
  }

  public getMultiRowColumn(index: number): number {
    return Math.floor((index - recentRuntimeInstance.leftBoundaryIndex +
      (recentRuntimeInstance.rightBoundaryIndex - recentRuntimeInstance.leftBoundaryIndex + 1) % 2) / 2) +
    recentRuntimeInstance.leftBoundaryColumn;
  }

  public getMultiRowColumnInDeleting(index: number): number {
    return Math.floor((index + (recentRuntimeInstance.rightBoundaryIndex -
    recentRuntimeInstance.leftBoundaryIndex) % 2) / 2);
  }

  public getPositionX(index: number, sessionCount: number): number {
    let screenProperty = this.panelManager.getScreenProperty();
    let relativeRightColumn = recentRuntimeInstance.getRelativeColumn(recentRuntimeInstance.rightBoundaryIndex);
    let relativeColumn = recentRuntimeInstance.getRelativeColumn(index);
    return RecentLayoutManager.getPositionX(relativeRightColumn, relativeColumn, sessionCount, screenProperty);
  }

  private debugCommand(): string {
    let ret = 'removing index: ' + this.removingIndex.toString();
    ret += '\r\n';
    ret = 'removing container: ' + this.removingContainerSession?.getName();
    ret += '\r\n';
    return ret;
  }

  private registerDebugCommand(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'info',
        callback: (args: string[]): string => {
          return this.debugCommand();
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

  public resetZindexAndCenterOnfinish(sceneContainerSession: SCBSceneContainerSession, animationNum: number): void {
    if (animationNum !== sceneContainerSession?.getTransitionCount()) {
      log.info(`delete break, return`);
      return;
    }
    this.containerUnsinking(sceneContainerSession);
    this.restoreContainerCenter(sceneContainerSession);
  }
}