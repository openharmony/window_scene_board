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
import { NumberConstants } from '@ohos/commonconstants';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { layoutConfigManager, StyleConstants } from '@ohos/launchercommon';
import { SmartDockStyleConfig } from '../common/SmartDockStyleConfig';
import { DockRegionType } from '../common/enum/SmartDockEnum';
import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';
import { SmartDockAnimationType, SmartDockZoomAnimationManager } from './SmartDockZoomAnimationManager';
import FeatureConstants from '../common/constants/FeatureConstants';

const TAG = 'SmartDock_VM_SmartDockZoomEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const SAFE_SCREEN_GAP: number = 24;

/**
 *  dock应用变化事件类
 *  dock分区如下：
 *  协同区：collaboration，常驻区：resident，最近任务区：recent
 */
export class SmartDockZoomEvent {
  private static instance: SmartDockZoomEvent;

  public static getInstance(): SmartDockZoomEvent {
    if (!SmartDockZoomEvent.instance) {
      SmartDockZoomEvent.instance = new SmartDockZoomEvent();
      SmartDockZoomEvent.instance.setMinZoomLimit();
    }
    return SmartDockZoomEvent.instance;
  }
  /* 需要缩放动效的最小图标数量 */
  private minZoomLimit: number = 19;

  /**
   * 常驻区文件夹小转大
   *
   * @param residentNum：resident应用数量
   */
  public onSmallFolderConvertToBig(residentNum: number): boolean {
    const dockRegionLayoutModel = DockRegionLayoutModel.getInstance();
    dockRegionLayoutModel.updateRegionLayoutLength(DockRegionType.RESIDENT, residentNum);
    return !this.isRequiredZoom(dockRegionLayoutModel.getListCount() + 1);
  }

  /**
   * 最近任务区应用移除
   *
   * @param recentNum： recent应用数量
   */
  public onRecentAppMove(recentNum: number): void {
    this.onListNumChange(SmartDockAnimationType.DELAYEDLY, DockRegionType.RECENT, recentNum);
  }

  /**
   * 常驻区应用卸载
   *
   * @param residentNum：resident应用数量
   */
  public onAppUninstall(residentNum: number): void {
    this.onListNumChange(SmartDockAnimationType.DELAYEDLY, DockRegionType.RESIDENT, residentNum);
  }

  /**
   * dock常驻区拖拽应用进入事件
   *
   * @param residentNum：resident区应用数量，包含占位框（即resident显示长度对应的应用数量）
   */
  public onDragSqueezing(residentNum: number): void {
    log.showInfo('onDragSqueezing zoom animation');
    const dockRegionLayoutModel = DockRegionLayoutModel.getInstance();
    const listNumberBefore: number = dockRegionLayoutModel.getListCount();
    dockRegionLayoutModel.updateRegionLayoutLength(DockRegionType.RESIDENT, residentNum);
    const listNumber: number = dockRegionLayoutModel.getListCount();
    if (!this.isRequiredZoom(Math.max(listNumber, listNumberBefore)) || listNumberBefore === listNumber) {
      return;
    }

    SmartDockZoomAnimationManager.getInstance()
      .runAnimation('onDragSqueezing', DockRegionType.RESIDENT, SmartDockAnimationType.IMMEDIATELY);
  }

  /**
   * dock多设备协同连接事件
   *
   * @param collaborationNum：协同区应用数量
   */
  public onConnectChange(collaborationNum: number): void {
    this.onDockRefresh(DockRegionType.COLLABORATION, collaborationNum);
  }

  /**
   * dock刷新
   *
   * @param listType:调用该方法的分区
   * @param listNum:调用该方法的分区应用数量
   */
  public onDockRefresh(listType: DockRegionType, listNum: number): void {
    log.showInfo('list number change by %{public}s, to %{public}d', listType, listNum);
    const dockRegionLayoutModel = DockRegionLayoutModel.getInstance();
    const listNumberBefore: number = dockRegionLayoutModel.getListCount();
    dockRegionLayoutModel.updateRegionLayoutLength(listType, listNum);
    const listNumber: number = dockRegionLayoutModel.getListCount();
    if (!this.isRequiredZoom(Math.max(listNumberBefore, listNumber))) {
      return;
    }
    SmartDockZoomAnimationManager.getInstance().runAnimation('onDockRefresh', listType, SmartDockAnimationType.IMMEDIATELY);
  }

  /**
   * 屏幕宽度变化
   * 如屏幕旋转，屏幕折叠展开等
   *
   * @param isPortrait:屏幕变化后是否为竖屏
   */
  public onPortraitStatusChange(): void {
    this.setMinZoomLimit();
  }

  /**
   * 是否需要缩放
   *
   * @returns 是否需要缩放
   */
  private isRequiredZoom(listNumber: number): boolean {
    return listNumber > this.getMinZoomLimit();
  }

  /**
   * dock区图标数量变化
   *
   * @param animationType:动画播放类型，IMMEDIATELY为立即播放，DELAYEDLY为顺序播放
   * @param listType:数量变化的区域
   * @param num: 变化后该区域图标数量
   */
  private onListNumChange(animationType: SmartDockAnimationType, listType: DockRegionType, num: number): void {
    const dockRegionLayoutModel = DockRegionLayoutModel.getInstance();
    const listNumberBefore: number = dockRegionLayoutModel.getListCount();
    dockRegionLayoutModel.updateRegionLayoutLength(listType, num);
    const listNumber: number = dockRegionLayoutModel.getListCount();
    log.showInfo('list number change by %{public}s,from %{public}d to %{public}d',
      SmartDockAnimationType[animationType], listNumberBefore, listNumber);

    if (!this.isRequiredZoom(Math.max(listNumber, listNumberBefore)) || listNumberBefore === listNumber) {
      return;
    }

    SmartDockZoomAnimationManager.getInstance().runAnimation('OnListNumChange', listType, animationType);
  }


  /**
   * 获取需要缩放动效的最少应用数量
   */
  public getMinZoomLimit(): number {
    return this.minZoomLimit;
  }

  /**
   * 设置需要缩放动效的最少应用数量
   */
  public setMinZoomLimit(limit?: number): void {
    if (!!limit) {
      this.minZoomLimit = limit;
      log.showInfo('set zoom animation in debug mode minZoomLimit to: %{public}d', limit);
      return;
    }
    const minZoomLimit: number = this.calculateMinZoomLimit();
    log.showInfo('set zoom animation minZoomLimit to: %{public}d', minZoomLimit);
    this.minZoomLimit = minZoomLimit;
  }

  /**
   * 设置需要缩放动效的最少应用数量
   */
  private calculateMinZoomLimit(): number {
    // UX要求屏幕两侧保留24vp的安全距离，加起来48vp
    const safeScreenWidth: number =
      AppStorage.get<number>('screenWidth') as number - SAFE_SCREEN_GAP * NumberConstants.CONSTANT_NUMBER_TWO;
    const smartDockStyleConfig: SmartDockStyleConfig =
      layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME);
    // 间隔条宽度总和
    let dividerWidth = 0;
    // 每栏左侧应用与背板间隔总和
    let leftPadding = smartDockStyleConfig.mDockPadding;
    let arrowWidth = 0;
    const dockRegionLayoutModel = DockRegionLayoutModel.getInstance();
    const recentNum: number = dockRegionLayoutModel.getRegionLayoutLength(DockRegionType.RECENT);
    // recent区宽度
    dividerWidth += smartDockStyleConfig.mDividerWidth;
    leftPadding += smartDockStyleConfig.mDockPadding;
    if (SCBSceneSessionManager.getInstance().isPcMode() && recentNum > smartDockStyleConfig.mRecentDockMaxNumber) {
      arrowWidth += StyleConstants.DEFAULT_32 * NumberConstants.CONSTANT_NUMBER_TWO;
    }
    // 计算最小值时需要考虑协同区divider与背板间距的影响
    dividerWidth += smartDockStyleConfig.mDividerWidth;
    leftPadding += smartDockStyleConfig.mDockPadding;

    // dock区最多能放下的应用数量为可放应用的宽度/（应用宽度+应用间隔）,自由多窗模式还要减去运行区双箭头的宽
    return Math.floor((safeScreenWidth - dividerWidth - leftPadding - arrowWidth) /
      (smartDockStyleConfig.mIconSize + smartDockStyleConfig.mListItemGap));
  }
}