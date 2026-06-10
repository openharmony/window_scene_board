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

import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';
import { SmartDockZoomAnimationConfig } from '../common/SmartDockZoomAnimationConfig';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { DockRegionLayoutPropertyVm } from './DockRegionLayoutPropertyVm';
import { SmartDockObserver } from './smartDockObserver';
import lazy { SmartDockZoomManager }from '@ohos/launchercommon/src/main/ets/dock/common/SmartDockZoomManager';
import { DockRegionType } from '../common/enum/SmartDockEnum';
import { GlobalContext } from '@ohos/frameworkwrapper';
import type ctx from '@ohos.app.ability.common';
import SmartDockConstants from '../common/constants/SmartDockConstants';

const TAG = 'SmartDock_VM_SmartDockZoomAnimationManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * dock缩放动画管理器
 * 运行dock缩放动效
 */
export class SmartDockZoomAnimationManager {
  private static instance: SmartDockZoomAnimationManager;
  // 动画队列，对不立即播放的动画进行排队播放
  public animationList: SmartDockAnimationEvent[] = [];
  // 当前dock动效状态
  public animationState: AnimationState = AnimationState.DEFAULT_STATE;
  private desktopContext?: ctx.ServiceExtensionContext = GlobalContext.getContext();

  public static getInstance() {
    if (!SmartDockZoomAnimationManager.instance) {
      SmartDockZoomAnimationManager.instance = new SmartDockZoomAnimationManager();
    }
    return SmartDockZoomAnimationManager.instance;
  }

  /**
   * 播放动画队列下一个动画
   */
  public runNextAnimation(): void {
    while (this.animationList.length !== 0) {
      const event = this.animationList.pop();
      if (!!event) {
        this.runAnimation('runNextAnimation', event.type, SmartDockAnimationType.IMMEDIATELY, event.change);
        break;
      }
    }
  }

  /**
   * 播放动效
   *
   * @param reason: 调用方信息
   * @param listType: 应用数量变化的分区
   * @param animationType: IMMEDIATELY为立即播放，DELAYEDLY为添加到队列顺序播放
   * @param change: 数量变化
   */
  public runAnimation(reason: string, listType: DockRegionType, animationType: SmartDockAnimationType,
    change: number = 0): void {
    log.showInfo('run Smartdock animation by %{public}s', reason);
    switch (animationType) {
      case SmartDockAnimationType.IMMEDIATELY:
        this.playAnimation(SmartDockObserver.getInstance().getLayoutPropertyVm(), listType);
        break;
      case SmartDockAnimationType.DELAYEDLY:
        DockRegionLayoutModel.getInstance().updateRegionLayoutLength(listType, change);
        this.animationList.push(new SmartDockAnimationEvent(listType, change));
        break;
      default:
        log.showWarn('animation type is illegal')
        break;
    }
  }

  /**
   * 当前dock动画状态
   *
   * @returns: true为动画中，false为静止状态
   */
  public isAnimating(): boolean {
    return this.animationState === AnimationState.ANIMATING_STATE;
  }

  /**
   * 播放动画
   *
   * @param dockRegionObserver：需要做动效的observer实例
   * @param sequential：是否为队列里的动效
   * @param hasAnimation: 是否需要动效
   * @returns
   */
  public playAnimation(dockRegionObserver: DockRegionLayoutPropertyVm, listType: DockRegionType,
    sequential: boolean = false): void {
    if (!dockRegionObserver) {
      log.showInfo('dockRegionObserver is empty');
      return;
    }
    const model = DockRegionLayoutModel.getInstance();
    const scale = model.calculateScale();
    SmartDockZoomManager.setDockScale(scale);
    model.setScale(scale);

    animateTo({
      curve: SmartDockZoomAnimationConfig.getAnimationCurve(),
      duration: SmartDockZoomAnimationConfig.getAnimationDuration(),
      onFinish: () => {
        TraceUtil.endTrace(DomainName.SCB, 'zoomAnimation');
        SmartDockZoomManager.setIsZooming(false);
        if (sequential) {
          this.runNextAnimation();
        }
      }
    },
      () => {
        TraceUtil.startTrace(DomainName.SCB, 'zoomAnimation');
        SmartDockZoomManager.setIsZooming(true);
        this.changeScale(dockRegionObserver, model);
        this.desktopContext?.eventHub.emit(SmartDockConstants.DOCK_ZOOM_EVENT, listType);
      }
    );
  }

  private changeScale(dockRegionObserver: DockRegionLayoutPropertyVm, model: DockRegionLayoutModel): void {
    dockRegionObserver.iconSize = model.getIconSize();
    dockRegionObserver.iconRadius = model.getIconRadius();
    dockRegionObserver.dockHeight = model.getDockHeight();
    dockRegionObserver.dockRadius = model.getDockRadius();
    dockRegionObserver.dividerWidth = model.getDividerWidth();
    dockRegionObserver.space = model.getSpace(1);
    dockRegionObserver.listPadding = model.getListPadding(1);
    dockRegionObserver.scale = model.getScale();
    dockRegionObserver.collaborationDividerWidth = model.getDividerWidth();
    log.showInfo('Settings updated: iconSize=%{public}d, iconRadius=%{public}d, dockHeight=%{public}d,' +
      'dockRadius=%{public}d, dividerWidth=%{public}d,space=%{public}d, listPadding=%{public}d, scale=%{public}d' +
      ', collaborationDividerWidth=%{public}d',
      dockRegionObserver.iconSize, dockRegionObserver.iconRadius, dockRegionObserver.dockHeight,
      dockRegionObserver.dockRadius, dockRegionObserver.dividerWidth, dockRegionObserver.space,
      dockRegionObserver.listPadding, dockRegionObserver.scale, dockRegionObserver.collaborationDividerWidth);
  }
}

class SmartDockAnimationEvent {
  constructor(type: DockRegionType, change: number) {
    this._type = type;
    this._change = change;
  }

  private _type: DockRegionType;

  public get type(): DockRegionType {
    return this._type;
  }

  private _change: number = 0;

  public get change(): number {
    return this._change;
  }
}

enum AnimationState {
  /* 初始化状态 */
  DEFAULT_STATE = -1,

  /* 停止状态 */
  STOP_STATE,

  /* 动效进行状态 */
  ANIMATING_STATE,

  /* 动效打断状态 */
  BREAKING_STATE
}

/**
 * 动画播放类型
 */
export enum SmartDockAnimationType {
  /* 默认类型 */
  DEFAULT_TYPE = -1,

  /* 立即播放，若当前有动画，则并行播放 */
  IMMEDIATELY,

  /* 顺序播放，若动画队列中有其他动画或当前有动画，则排队等待 */
  DELAYEDLY
}